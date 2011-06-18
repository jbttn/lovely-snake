--
----- SNAKE FUNCTIONS -----
--


function init_snake()
  snake_loc = {head={x=x_start, y=y_start, dir="right"}}
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
  
  temp1 = level:get_coords("world", snake_loc["head"]["x"], snake_loc["head"]["y"])
  check_collision()
  
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
print(key .. " loc on map       ", value.x, value.y)
    end
  end
end

function check_collision()
  --local l_width, l_height = level:get_size()
  -- Check collision with wall
  if snake_loc["head"]["y"] >= max_height or snake_loc["head"]["y"] < 0 then
    print("Hit y wall")
    return kill_snake()
  end
  if snake_loc["head"]["x"] > max_width or snake_loc["head"]["x"] < 0 then
    print("Hit x wall")
    return kill_snake()
  end
  
  -- Check collision with body
  for key, value in pairs(snake_loc) do
    if key ~= "head" then
      if temp1.x * 32 == value.x and temp1.y * 32 == value.y then
print("Body collision at x: " .. value.x .. " y: " .. value.y, temp1.x * 32, temp1.y * 32, key)
        return kill_snake()
      end
    end
  end
  
  -- Check collision with food
  local temp = level:get_coords("world", snake_loc["head"]["x"], snake_loc["head"]["y"]) -- if snake in middle with screen scroll snake loc doesnt change...but then we need world locs? NEED TO CHECK IF TEMP IS NIL!!!!!!
--  print("CHECK COLLISION: ", temp.x * 32, temp.y * 32, snake_food[1]["x"], snake_food[1]["y"])
  if temp.x * 32 == snake_food[1]["x"] and temp.y * 32 == snake_food[1]["y"] then
    print("Food colision")
    table.remove(snake_food)
--print("SNAKE BODY INSERTED AT: ", snake_loc["head"]["x"], snake_loc["head"]["y"])
    --table.insert(snake_loc, {x=snake_loc["head"]["x"], y=snake_loc["head"]["y"], dir=snake_direction})
--print("SNAKE BODY INSERTED AT: ", temp.x * 32, temp.y * 32)
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
  local level_size = level:get_level_size()
  local l_width, l_height = level:get_level_size()
print(level_size.width, level_size.height)
  if next(snake_food) == nil then -- Table is empty
    local random_x = block_size * math.random(0, (level_size.width - block_size) / block_size)
    local random_y = block_size * math.random(0, (level_size.height - block_size) / block_size)
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
