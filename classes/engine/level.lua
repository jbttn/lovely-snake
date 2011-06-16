Level = class('Level')

-- "self" variables can't be used in the draw function apparently?
local tile_img
local DISP_BUFFER = 1

function Level:initialize()
  self.path = nil
  
  self.tile_size = 0
  self.height = 0 -- the width and height of the entire level
  self.width = 0
  self.screen_width = 0 -- the width and height of the curently displayed stuff
  self.screen_height = 0
  self.x = 0 -- the current x and y position of the level
  self.y = 0
  
  tile_img = nil -- doesn't like it when it's self...look into that
  self.tile_img_w = 0
  self.tile_img_h = 0
  
  self.quads = {}
  self.level_table = {}
  
  self.screen_loc = {}
  self.world_loc = {}
  
  print("initialized level", path)
end

function Level:load_level(path, tile_w, tile_h)
  self.path = path
  self.tile_w = tile_w
  self.tile_h = tile_h
  
  local res = get_current_resolution()
  
  self.screen_width = res.x / 32 -- this should be the resolution, needs to be updated on res change
  self.screen_height = res.y / 32
  
  love.filesystem.load(path)()
end

function Level:new_level(tile_path, tile_string, quad_data)
  print("new level")
  
  self.width = #(tile_string:match("[^\n]+"))
  self.height = 0
  for line in tile_string:gmatch("[^\r\n]+") do
    self.height = self.height + 1
  end

  tile_img = love.graphics.newImage(tile_path)
  self.tile_img_w, self.tile_img_h = tile_img:getWidth(), tile_img:getHeight()
  
  self.quads = {}
  self.level_table = {}
  
  for key, value in ipairs(quad_data) do
    -- info[1] = the character, info[2] = x, info[3] = y
    self.quads[value[1]] = love.graphics.newQuad(value[2], value[3], self.tile_w,  self.tile_h, self.tile_img_w, self.tile_img_h)
  end

  for i = 1, self.width do self.level_table[i] = {} end

  local row_i = 1
  local col_i = 1
  for row in tile_string:gmatch("[^\n]+") do
    assert(#row == self.width, 'Map is not aligned: width of row ' .. tostring(row_i) .. ' should be ' .. tostring(self.width) .. ', but it is ' .. tostring(#row))
    col_i = 1
    for symbol in row:gmatch(".") do
      self.level_table[col_i][row_i] = symbol
      col_i = col_i + 1
    end
    row_i = row_i + 1
  end
end

function Level:draw_level()
  --print("drawing level")
  
  local offset_x = self.x % self.tile_w
  local offset_y = self.y % self.tile_h
  local first_tile_x = math.floor(self.x / self.tile_w)
  local first_tile_y = math.floor(self.y / self.tile_h)
--[[  
  for col_i, column in ipairs(self.level_table) do
    for row_i, symbol in ipairs(column) do
      -- col_i is x, row_i is y
      if row_i + first_tile_y >= 1 and row_i + first_tile_y <= self.height and col_i + first_tile_x >= 1 and col_i + first_tile_x <= self.width then
        love.graphics.drawq(tile_img, self.quads[symbol], (col_i * self.tile_w) - offset_x - self.tile_w, (row_i * self.tile_h) - offset_y - self.tile_h)
      end
    end
  end]]
  
      for y=1, (self.screen_height + DISP_BUFFER) do
        for x=1, (self.screen_width + DISP_BUFFER) do
            -- Note that this condition block allows us to go beyond the edge of the map.
            if y+first_tile_y >= 1 and y+first_tile_y <= self.height and x+first_tile_x >= 1 and x+first_tile_x <= self.width then
                love.graphics.drawq(tile_img, self.quads[self.level_table[x+first_tile_x][y+first_tile_y]], (x * self.tile_w) - offset_x - self.tile_w, (y * self.tile_h) - offset_y - self.tile_h)
            end
        end
    end
end

function Level:update_level(dt)
  if love.keyboard.isDown( "up" ) then
    --self.y = self.y - (100 * dt)
    self.y = self.y - block_size
  end
  if love.keyboard.isDown( "down" ) then
    --self.y = self.y + (100 * dt)
    self.y = self.y + block_size
  end
  if love.keyboard.isDown( "left" ) then
    --self.x = self.x - (100 * dt)
    self.x = self.x - block_size
  end
  if love.keyboard.isDown( "right" ) then
    --self.x = self.x + (100 * dt)
    self.x = self.x + block_size
  end
  
  -- testing
  --[[
  if snake_direction == "up" then
    self.y = self.y - block_size
  end
  if snake_direction == "down" then
    self.y = self.y + block_size
  end
  if snake_direction == "left" then
    self.x = self.x - block_size
  end
  if snake_direction == "right" then
    self.x = self.x + block_size
  end]]
  
  print("x: ", self.x, "y: ", self.y)
  
  --self:get_coords("world")

  if self.x < 0 then
    self.x = 0
  end
  if self.y < 0 then
    self.y = 0
  end 
  if self.x > self.width * self.tile_w - self.screen_width * self.tile_w then
    self.x = self.width * self.tile_w - self.screen_width * self.tile_w
  end
  if self.y > self.height * self.tile_h - self.screen_height * self.tile_h then
    self.y = self.height * self.tile_h - self.screen_height * self.tile_h
  end
  
  -- TEMP FOR TESTING, should only update on resolution change, not all the time
  local res = get_current_resolution()
  self.screen_width = res.x / 32 -- this should be the resolution, needs to be updated on res change
  self.screen_height = res.y / 32
end

function Level:get_coords(type_of_coords)
  local mouse_x = love.mouse.getX()
  local mouse_y = love.mouse.getY()
  
  local first_tile_x = math.floor(self.x / self.tile_w)
  local first_tile_y = math.floor(self.y / self.tile_h)
  
  if type_of_coords == "screen" then
    for k, v in pairs(self.screen_loc) do self.screen_loc[k] = nil end -- clear table
  else
    for k, v in pairs(self.world_loc) do self.world_loc[k] = nil end
  end

  for x, column in ipairs(self.level_table) do
    for y, symbol in ipairs(column) do
        if type_of_coords == "screen" then
          table.insert(self.screen_loc, {x = (x * self.tile_w) - self.tile_w, y = (y * self.tile_h) - self.tile_h})
        else
          table.insert(self.world_loc, {x = (x * self.tile_w) - self.tile_w, y = (y * self.tile_h) - self.tile_h})
        end
    end
  end
  
  for i = 1, #self.screen_loc do
    if mouse_inside("both", mouse_x, mouse_y, self.screen_loc[i].x, self.screen_loc[i].y, self.tile_w, self.tile_h) then
      --print("Mouse over screen coords " .. math.floor(self.screen_loc[i].x / 32) .. ' ' .. math.floor(self.screen_loc[i].y / 32))
    end
  end
  for i = 1, #self.world_loc do
    if mouse_inside("both", mouse_x + self.x, mouse_y + self.y, self.world_loc[i].x, self.world_loc[i].y, self.tile_w, self.tile_h) then
      --print("Mouse over world coords " .. math.floor(self.world_loc[i].x / 32) .. ' ' .. math.floor(self.world_loc[i].y / 32))
    end
  end
end

function Level:get_size()
  print("size: " .. (self.width * self.tile_w) - (self.screen_width * self.tile_w) .. " " .. (self.height * self.tile_h) - (self.screen_height * self.tile_h) )
  return (self.width * self.tile_w) - (self.screen_width * self.tile_w), (self.height * self.tile_h) - (self.screen_height * self.tile_h)
end

function Level:set_x_y(sx, sy)
  self.x = sx
  self.y = sy
end