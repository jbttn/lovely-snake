--
----- SNAKE FUNCTIONS -----
--

function init_snake()
  --snake_loc = {{x_start, y_start}}
  snake_loc = {head={x=x_start, y=y_start}}
  snake_direction = "up"
  snake_food = {}
end

function move_snake(dt)
  -- Keep track of where the snake was
  local old_x = snake_loc["head"]["x"]
  local old_y = snake_loc["head"]["y"]
  local temp
  
  -- Move the snakes head (the first block of the snake)
  if snake_direction == "up" then
    snake_loc["head"]["y"] = snake_loc["head"]["y"] - block_size
  end
  if snake_direction == "down" then
    snake_loc["head"]["y"] = snake_loc["head"]["y"] + block_size
  end
  if snake_direction == "left" then
    snake_loc["head"]["x"] = snake_loc["head"]["x"] - block_size
  end
  if snake_direction == "right" then
    snake_loc["head"]["x"] = snake_loc["head"]["x"] + block_size
  end
  
  check_collision()
  
  -- Move the rest of the snake
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
end

function check_collision()
  -- Check collision with wall
  if snake_loc["head"]["y"] > max_height or snake_loc["head"]["y"] < 0 then
    print("Hit y wall")
    return kill_snake()
  end
  if snake_loc["head"]["x"] > max_width or snake_loc["head"]["x"] < 0 then
    print("Hit x wall")
    return kill_snake()
  end
  
  -- Check collision with body
  
  -- Check collision with food
  if snake_loc["head"]["x"] == snake_food[1]["x"] and snake_loc["head"]["y"] == snake_food[1]["y"] then
    print("Food colision")
    table.remove(snake_food)
    table.insert(snake_loc, {x=snake_loc["head"]["x"], y=snake_loc["head"]["y"]})
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
  if next(snake_food) == nil then -- Table is empty
    local random_x = block_size * math.random(0, (max_width - block_size) / block_size)
    local random_y = block_size * math.random(0, (max_height - block_size) / block_size)
    --snake_food = {x=random_x, y=random_y}
    -- Inserting this way means we can have multiple snake foods, maybe with different attributes
    table.insert(snake_food, {x=random_x, y=random_y})
    print("Food: " .. snake_food[1]["x"] .. " " .. snake_food[1]["y"])
  end
end
