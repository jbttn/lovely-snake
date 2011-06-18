Snake = class('Snake', Actor)

--Snake.CLASS_VAR = 0 --this is a class variable

function Snake:initialize()
  Actor.initialize(self) -- call the parent's constructor on self
  self.body = {head={x=x_start, y=y_start}}
  self.direction = "up"
  --food.list = {} --food class?
end

function Snake:init()
  self.body = {head={x=x_start, y=y_start, dir="right"}}
  self.direction = "up"
  --food.list = {}
end

function Snake:move()
  local pos = Actor.update_position(self.body["head"]["x"], self.body["head"]["y"])
  -- Keep track of where the snake was
  local old_x = pos.x * block_size
  local old_y = pos.y * block_size
  local temp
  
  -- Move the snakes head (the first block of the snake)
  --camera:debug_print()
  if self.direction == "up" and (camera.bounds.south > 0 or camera.bounds.north > 0) then
    self.body["head"]["y"] = self.body["head"]["y"] - block_size
    if camera.bounds.south > 0 then
      camera.bounds.south = camera.bounds.south - 1
    end
  elseif self.direction == "down" and (camera.bounds.north > 0 or camera.bounds.south > 0) then
    self.body["head"]["y"] = self.body["head"]["y"] + block_size
    if camera.bounds.north > 0 then
      camera.bounds.north = camera.bounds.north - 1
    end
  elseif self.direction == "left" and (camera.bounds.east > 0 or camera.bounds.west > 0) then
    self.body["head"]["x"] = self.body["head"]["x"] - block_size
    if camera.bounds.east > 0 then
      camera.bounds.east = camera.bounds.east - 1
    end
  elseif self.direction == "right" and (camera.bounds.west > 0 or camera.bounds.east > 0) then
    self.body["head"]["x"] = self.body["head"]["x"] + block_size
    if camera.bounds.west > 0 then
      camera.bounds.west = camera.bounds.west - 1
    end
  end
  
  self:debug_print() -- lets see the location of the snake
  check_collision(pos)
end

function Snake:check_collision(pos)
  -- Check collision with wall
  if self.body["head"]["y"] >= max_height or self.body["head"]["y"] < 0 then
    print("Hit y wall")
    return kill_snake()
  end
  if self.body["head"]["x"] > max_width or self.body["head"]["x"] < 0 then
    print("Hit x wall")
    return kill_snake()
  end
  
  -- Check collision with body
  for key, value in pairs(self.body) do
    if key ~= "head" then
      if pos.x * block_size == value.x and pos.y * block_size == value.y then
print("Body collision at x: " .. value.x .. " y: " .. value.y, pos.x * block_size, pos.y * block_size, key)
        return kill_snake()
      end
    end
  end
  
  -- Check collision with food
  --local temp = level:get_coords("world", self.body["head"]["x"], self.body["head"]["y"]) -- if snake in middle with screen scroll snake loc doesnt change...but then we need world locs? NEED TO CHECK IF TEMP IS NIL!!!!!!
--  print("CHECK COLLISION: ", pos.x * block_size, pos.y * block_size, food.list[1]["x"], food.list[1]["y"])
  if pos.x * block_size == food.list[1]["x"] and pos.y * block_size == food.list[1]["y"] then
    print("Food colision")
    table.remove(food.list)
--print("SNAKE BODY INSERTED AT: ", self.body["head"]["x"], self.body["head"]["y"])
    --table.insert(self.body, {x=self.body["head"]["x"], y=self.body["head"]["y"], dir=snake_direction})
--print("SNAKE BODY INSERTED AT: ", pos.x * 32, pos.y * 32)
    table.insert(self.body, {x = pos.x * block_size, y = pos.y * blcok_size})
  end
end

function Snake:kill()
  game_state = "main_menu"
  self:init()
end

function Snake:debug_print()
  print(self.position.x, self.position.y)
  local pos = Actor.update_position(self, self.body["head"]["x"], self.body["head"]["y"])
  local head_world_coords = level:get_coords("world", self.body["head"]["x"], self.body["head"]["y"])
  
  print("Snake location on level", head_world_coords.x * block_size, head_world_coords.y * block_size) -- block size neeeds to be defined in the engine?
end






























