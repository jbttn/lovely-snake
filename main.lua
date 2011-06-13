--[[
      LÖVEly Snake by Joshua Button
      
      TODOS:
        * Add countdown on unpause
        * Better way to handle game states
        * Main menu with options screen for difficulty and other options
        * Option to turn wall collision on or off
        * Option to change game colors?
        * Mouse controls
        * Multiple food items? Powerups?
        * Score board with high scores
        * Clean up code
                                                                              ]]

--
----- LOVE FUNCTIONS -----
--

function love.load()
  math.randomseed(os.time())
  math.random() -- Numbers wont be random on the first call for some reason
  
  max_width = 800
  max_height = 600
  paused = false
  game_state = "start" -- start, paused, gameover
  
  block_size = 10
  speed = 50 -- In milliseconds
  
  x_start = max_width / 2
  y_start = max_height / 2
  
  --snake_loc = {{x_start, y_start}}
  snake_loc = {head={x=x_start, y=y_start},{x=1, y=1}}
  snake_direction = "up"
  snake_food = {}
  
  --key_is_pressed = false
  -- Disable key repeating
  love.keyboard.setKeyRepeat(0, 100)
end

function love.update(dt)
  love.timer.sleep( speed )
  
  if paused == true then
    return
  end
  
  generate_food()
  
  --if love.keyboard.isDown("up") then
    --if key_is_pressed == false then
      --key_is_pressed = true
      --snake_loc["head"]["y"] = (snake_loc["head"]["y"] - ((100 * speed) * dt))
      --print(snake_loc["head"]["y"])
    --end
  --end
  
  move_snake(dt)
end

function love.draw()

  if paused == true then
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print("PAUSED", max_width / 2, max_height / 2)
  end
  
  if next(snake_food) ~= nil then
    love.graphics.setColor(200, 0, 70, 255)
    love.graphics.rectangle("fill", snake_food[1]["x"], snake_food[1]["y"], block_size, block_size)
    love.graphics.setColor(0, 0, 255, 255)
  end
  
  for key, value in pairs(snake_loc) do
    --love.graphics.rectangle("fill", value[1], value[2], block_size, block_size)
    love.graphics.rectangle("fill", value.x, value.y, block_size, block_size)
    --print("x = " .. value.x)
    --print("y = " .. value.y)
  end
end

function love.mousepressed(x, y, button)
  if button == 'l' then
    -- button 1 clicked at position x, y
  end
end

function love.mousereleased(x, y, button)
  if button == 'l' then
    -- button 1 released at position x, y
  end
end

function love.keypressed(key, unicode)
  if key == 'return' then
    print("The return key was pressed.")
    if paused == false then
      paused = true
    else
      paused = false
    end
  elseif key == 'up' then
    snake_direction = "up"
  elseif key == 'down' then
    snake_direction = "down"
  elseif key == 'left' then
    snake_direction = "left"
  elseif key == 'right' then
    snake_direction = "right"
  end
  
  -- Debug
  if key == 'd' then
    table.insert(snake_loc, {x=50, y=1}) --push?
  elseif key == 'r' then
    table.remove(snake_loc) --pop?
  end
end

function love.keyreleased(key, unicode)
  if key == 'b' then
    text = "The B key was released."
  elseif key == 'a' then
    a_down = false
  end
end

function love.focus(f)
  if not f then
    print("LOST FOCUS")
    paused = true;
  else
    print("GAINED FOCUS")
  end
end

function love.quit()
  print("quit()")
end

--
----- SNAKE FUNCTIONS -----
--

function move_snake(dt)
  local old_x = snake_loc["head"]["x"]
  local old_y = snake_loc["head"]["y"]
  local temp
  
  if snake_direction == "up" then
    --snake_loc["head"]["y"] = (snake_loc["head"]["y"] - ((100 * speed) * dt))
    snake_loc["head"]["y"] = snake_loc["head"]["y"] - block_size
  end
  if snake_direction == "down" then
    --snake_loc["head"]["y"] = (snake_loc["head"]["y"] + ((100 * speed) * dt))
    snake_loc["head"]["y"] = snake_loc["head"]["y"] + block_size
  end
  if snake_direction == "left" then
    --snake_loc["head"]["x"] = (snake_loc["head"]["x"] - ((100 * speed) * dt))
    snake_loc["head"]["x"] = snake_loc["head"]["x"] - block_size
  end
  if snake_direction == "right" then
    --snake_loc["head"]["x"] = (snake_loc["head"]["x"] + ((100 * speed) * dt))
    snake_loc["head"]["x"] = snake_loc["head"]["x"] + block_size
  end
  
  check_collision()
  
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
    kill_snake()
  end
  if snake_loc["head"]["x"] > max_width or snake_loc["head"]["x"] < 0 then
    print("Hit x wall")
    kill_snake()
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
end

--
----- FOOD FUNCTIONS -----
--

function generate_food()
  if next(snake_food) == nil then -- Table is empty
    local random_x = block_size * math.random(0, (max_width - block_size) / block_size)
    local random_y = block_size * math.random(0, (max_height - block_size) / block_size)
    --snake_food = {x=random_x, y=random_y}
    table.insert(snake_food, {x=random_x, y=random_y})
    print("Food: " .. snake_food[1]["x"] .. " " .. snake_food[1]["y"])
  end
end