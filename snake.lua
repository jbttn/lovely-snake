--
----- SNAKE FUNCTIONS -----
--


function init_snake()
  snake_loc = {head={x=x_start, y=y_start, dir="right"}, {x=x_start, y=y_start, dir="right"}}
  snake_direction = "right"
  snake_food = {}
  had_meal = false
  
  north = 0
south = 0
east = 0
west = 0
end

function move_snake(dt)
  -- Keep track of where the snake was
  local old_x = snake_loc["head"]["x"]
  local old_y = snake_loc["head"]["y"]
  local temp
  
  -- Move the snakes head (the first block of the snake)
  print("N: " .. north .. " S: " .. south .. " E: " ..  east .. " W: " ..  west)
  if snake_direction == "up" and (south > 0 or north > 0) then
    snake_loc["head"]["y"] = snake_loc["head"]["y"] - block_size
    if south > 0 then
      south = south - 1
    end
  elseif snake_direction == "down" and (north > 0 or south > 0) then
    snake_loc["head"]["y"] = snake_loc["head"]["y"] + block_size
    if north > 0 then
      north = north - 1
    end
  elseif snake_direction == "left" and (east > 0 or west > 0) then
    snake_loc["head"]["x"] = snake_loc["head"]["x"] - block_size
    if east > 0 then
      east = east - 1
    end
  elseif snake_direction == "right" and (west > 0 or east > 0) then
    snake_loc["head"]["x"] = snake_loc["head"]["x"] + block_size
    if west > 0 then
      west = west - 1
    end
  end
  
  local t1 = level:get_coords("world", snake_loc["head"]["x"], snake_loc["head"]["y"])
  print("snake loc", snake_loc["head"]["x"], snake_loc["head"]["y"])
  print("snake loc on map", t1.x * 32, t1.y * 32)
  --local l_width, l_height = level:get_size()
  local camera_x, camera_y = snake_loc["head"]["x"], snake_loc["head"]["y"]
  camera_x = snake_loc["head"]["x"]
  camera_y = snake_loc["head"]["y"]
  --print("camera:  ", camera_x, camera_y)
  --level:set_x_y(camera_x, camera_y)
  
  check_collision()
  
  local temp1 = level:get_coords("world", snake_loc["head"]["x"], snake_loc["head"]["y"])
  old_x = temp1.x * 32
  old_y = temp1.y * 32
  for key, value in pairs(snake_loc) do
    if key ~= "head" then
      temp = value.x
      value.x = old_x
      old_x = temp
      
      temp = value.y
      value.y = old_y
      old_y = temp
    end
  end
  
  -- if the snake just had a meal, then dont do antthing this tick.
  --if had_meal ~= true then
  --[[
    -- iterate over body and update
    local old_dir, temp_dir
    for key, value in ipairs(snake_loc) do
      if key == 1 then
        old_dir = snake_direction
        value.dir = snake_direction
      else
        print("DKJHSJDHJKS", old_dir)
        temp_dir = value.dir
        value.dir = old_dir
        old_dir = temp_dir
      end
      if key ~= "head" then
        if value.dir == "up" then
          if north == 0 then
            value.y = value.y - block_size / 8
          end
        elseif value.dir == "down" then
          if south == 0 then
            value.y = value.y + block_size / 8
          end
        elseif value.dir == "left" then
          if west == 0 then
            value.x = value.x - block_size / 8
          end
        elseif value.dir == "right" then
          if east == 0 then
            value.x = value.x + block_size / 8
          end
        end
      end
      print("BODY: ", key, value.x, value.y, value.dir)
    end
    had_meal = false]]
  --end
  --[[
  local old_dir = snake_direction
  local temp_dir
  for key, value in pairs(snake_loc) do
    if key ~= "head" then
      if key == 1 then
        value.dir = old_dir
      end
      temp_dir = value.dir
      value.dir = old_dir
      old_dir = temp_dir
      if level:is_scrolling("both") == false then
        temp = value.x
        value.x = old_x
        old_x = temp
      
        temp = value.y
        value.y = old_y
        old_y = temp
      else
        temp = value.x
        if value.dir == "left" then
          value.x = old_x - 32
        elseif value.dir == "right" then
          value.x = old_x + 32
        end
        old_x = temp
        
        temp = value.y
        if value.dir == "up" then
          value.y = old_y - 32
        elseif value.dir == "down" then
          value.y = old_y + 32
        end
        old_y = temp
      end
    end
  end]]
  --[[
  local temp1 = level:get_coords("world", snake_loc["head"]["x"], snake_loc["head"]["y"]) -- if snake in middle with screen scroll snake loc doesnt change...but then we need world locs? NEED TO CHECK IF TEMP IS NIL!!!!!!
  local temp2 = {}
  temp1.x = temp1.x * 32
  temp1.y = temp1.y * 32
  old_x = temp1.x
  old_y = temp1.y
  --if temp1.x == snake_food[1]["x"] and temp1.y == snake_food[1]["y"] then
  for key, value in pairs(snake_loc) do
    if key ~= "head" then
      temp2 = level:get_coords("world", value.x, value.y)
      print("TESTTT: ", key, value.x, value.y, temp1.x, temp1.y, temp2.x * 32, temp2.y * 32)
      temp = value.x
      value.x = old_x
      old_x = temp
      
      temp = value.y
      value.y = old_y
      old_y = temp
    end
  end]]
  --[[
  if snake_direction == "up" and (south > 0 or north > 0) then
    for key, value in ipairs(snake_loc) do
      --snake_loc["head"]["y"] = snake_loc["head"]["y"] - block_size
      temp2 = level:get_coords("world", value.x, value.y)
      temp2.y = temp2.y - 32
    end
  elseif snake_direction == "down" and (north > 0 or south > 0) then
    --snake_loc["head"]["y"] = snake_loc["head"]["y"] + block_size
    for key, value in ipairs(snake_loc) do
      temp2 = level:get_coords("world", value.x, value.y)
      temp2.y = temp2.y + 32
    end
  elseif snake_direction == "left" and (east > 0 or west > 0) then
    --snake_loc["head"]["x"] = snake_loc["head"]["x"] - block_size
    for key, value in ipairs(snake_loc) do
      temp2 = level:get_coords("world", value.x, value.y)
      temp2.x = temp2.x - 32
    end
  elseif snake_direction == "right" and (west > 0 or east > 0) then
    --snake_loc["head"]["x"] = snake_loc["head"]["x"] + block_size
    for key, value in ipairs(snake_loc) do
      temp2 = level:get_coords("world", value.x, value.y)
      temp2.x = temp2.x + 32
    end
  end]]
--print("IS SCROLLING: ", level:is_scrolling("both"))
  -- Move the rest of the snake
  --[[
  for key, value in pairs(snake_loc) do
    if key ~= "head" then
      temp = value.x
      value.x = old_x
      old_x = temp
      
      temp = value.y
      value.y = old_y
      old_y = temp
    end
  end]]
end

function check_collision()
  --local l_width, l_height = level:get_size()
  -- Check collision with wall
  if snake_loc["head"]["y"] >= max_height or snake_loc["head"]["y"] < 0 then
    print("Hit y wall")
    --return kill_snake()
  end
  if snake_loc["head"]["x"] > max_width or snake_loc["head"]["x"] < 0 then
    print("Hit x wall")
    --return kill_snake()
  end
  
  -- Check collision with body
  for key, value in pairs(snake_loc) do
    if key ~= "head" then
      if snake_loc["head"]["x"] == value.x and snake_loc["head"]["y"] == value.y then
        --return kill_snake()
      end
    end
  end
  
  -- Check collision with food
  local temp = level:get_coords("world", snake_loc["head"]["x"], snake_loc["head"]["y"]) -- if snake in middle with screen scroll snake loc doesnt change...but then we need world locs? NEED TO CHECK IF TEMP IS NIL!!!!!!
  print("CHECK COLLISION: ", temp.x * 32, temp.y * 32, snake_food[1]["x"], snake_food[1]["y"])
  if temp.x * 32 == snake_food[1]["x"] and temp.y * 32 == snake_food[1]["y"] then
    print("Food colision")
    table.remove(snake_food)
--print("SNAKE BODY INSERTED AT: ", snake_loc["head"]["x"], snake_loc["head"]["y"])
    --table.insert(snake_loc, {x=snake_loc["head"]["x"], y=snake_loc["head"]["y"], dir=snake_direction})
print("SNAKE BODY INSERTED AT: ", temp.x * 32, temp.y * 32)
    table.insert(snake_loc, {x=temp.x*32, y=temp.y*32, dir=snake_direction})
    had_meal = true
  end
end

function kill_snake()
  game_state = "main_menu"
  init_snake()
end

--
----- FOOD FUNCTIONS -----
--

function generate_food()
  local l_width, l_height = level:get_level_size()
print(l_width, l_height)
  if next(snake_food) == nil then -- Table is empty
    local random_x = block_size * math.random(0, (l_width - block_size) / block_size)
    local random_y = block_size * math.random(0, (l_height - block_size) / block_size)
    --snake_food = {x=random_x, y=random_y}
    -- Inserting this way means we can have multiple snake foods, maybe with different attributes
    table.insert(snake_food, {x=random_x, y=random_y})
    print("Food: " .. snake_food[1]["x"] .. " " .. snake_food[1]["y"])
  end
end

function hit_camera_wall(direction)
  if direction == "north" then
    north = north + 1
  elseif direction == "south" then
    south = south + 1
  elseif direction == "east" then
    east = east + 1
  elseif direction == "west" then
    west = west + 1
  end
end
