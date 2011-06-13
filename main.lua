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
        * Sound effects?
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
  game_state = "main_menu" -- main_menu, options_menu, running, paused, game_over
  
  x_start = max_width / 2
  y_start = max_height / 2
  
  --snake_loc = {{x_start, y_start}}
  snake_loc = {head={x=x_start, y=y_start},{x=1, y=1}}
  snake_direction = "up"
  snake_food = {}
  
  -- Disable key repeating
  love.keyboard.setKeyRepeat(0, 100)
  
  resolutions = {
    {x=800, y=600},
    {x=1024, y=768},
    {x=1280, y=1024}
  }
  
  colors = {
    red = {200, 0, 70, 255},
    white = {255, 255, 255, 255}
  }
  
  difficulty = {
    very_easy = 400,
    easy = 200,
    normal = 100,
    hard = 50,
    very_hard = 20,
    menu = 0
  }
  
  main_menu_items = {
    "New game",
    "Options",
    "Quit"
  }
  
  block_size = 20 -- Just realized this only works with 10,20,25,50,100 need to think more on collision and resolution
  speed = difficulty.menu -- In milliseconds
  menu_item_loc = 0.30
  menu_item_space = 0.05
end

function love.update(dt)
  love.timer.sleep(speed)
  
  if game_state == "main_menu" then
    main_menu()
    return
  elseif game_state == "options_menu" then
    return
  elseif game_state == "paused" then
    return
  end
  
  generate_food()
  move_snake(dt)
end

function love.draw()
  love.graphics.setColor(colors.white)
  -- Get the current y location of the mouse cursor
  local mouse_y = love.mouse.getY()
  
  if game_state == "main_menu" then
    -- Set the font size
    love.graphics.setFont(32)
    -- For completly centered text
    love.graphics.printf("LOVEly Snake", 0, max_height * 0.05, max_width, 'center')
    
    love.graphics.setFont(20)
    for i = 1, #main_menu_items do
      --print(max_height * (menu_item_loc + (menu_item_space * (i - 1))) .. " " .. max_height * (menu_item_loc + (menu_item_space * i)) .. " " .. mouse_y)
      if mouse_y >= max_height * (menu_item_loc + (menu_item_space * (i - 1))) and mouse_y < max_height * (menu_item_loc + (menu_item_space * i)) then
        love.graphics.setColor(colors.red)
      else
        love.graphics.setColor(colors.white)
      end
      love.graphics.printf(main_menu_items[i], 0, max_height * (menu_item_loc + (menu_item_space * (i - 1))), max_width, 'center')
    end
    --[[
    if mouse_y >= max_height * menu_item_loc and mouse_y < max_height * (menu_item_loc + menu_item_space) then
      love.graphics.setColor(colors.red)
    else
      love.graphics.setColor(colors.white)
    end
    love.graphics.printf("New Game", 0, max_height * menu_item_loc, max_width, 'center')
    
    if mouse_y >= max_height * 0.35 and mouse_y <= max_height * 0.39 then
      love.graphics.setColor(colors.red)
    else
      love.graphics.setColor(colors.white)
    end
    love.graphics.printf("Options", 0, max_height * 0.35, max_width, 'center')
    
    if mouse_y >= max_height * 0.40 and mouse_y <= max_height * 0.44 then
      love.graphics.setColor(colors.red)
    else
      love.graphics.setColor(colors.white)
    end
    love.graphics.printf("Quit", 0, max_height * 0.40, max_width, 'center')]]
    
    --love.graphics.print("Press enter to play...", max_width / 2, max_height / 2)
  elseif game_state == "options_menu" then
    love.graphics.setFont(32)
    love.graphics.printf("Options", 0, max_height * 0.05, max_width, 'center')
    love.graphics.setFont(20)
    love.graphics.printf("Difficulty", 0, max_height * 0.30, max_width, 'center')
    -- draw image buttons here
  elseif game_state == "paused" then
    love.graphics.setColor(colors.white)
    love.graphics.print("PAUSED", max_width / 2, max_height / 2)
  elseif game_state == "game_over" then
    --game over
  elseif game_state == "running" then
    if next(snake_food) ~= nil then
      love.graphics.setColor(colors.red)
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
end

function love.mousepressed(x, y, button)
  if button == 'l' then
    -- button 1 clicked at position x, y
  end
end

function love.mousereleased(x, y, button)
  if button == 'l' then
    if game_state == "main_menu" then
      --print(max_height * 0.30)
      --print("button 1 released at position " ..  x .. ", " .. y)
      if y >= max_height * 0.30 and y <= max_height * 0.34 then
        print("clicked new game")
        game_state = "running"
        speed = difficulty.normal -- temporary
      end
      if y >= max_height * 0.35 and y <= max_height * 0.39 then
        print("clicked options")
        game_state = "options_menu"
      end
      if y >= max_height * 0.40 and y <= max_height * 0.44 then
        print("clicked quit")
      end
    end
  end
end

function love.keypressed(key, unicode)
  if key == 'return' then
    print("The return key was pressed.")
    if game_state ~= "paused" then
      game_state = "paused"
    else
      game_state = "running"
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
  elseif key == 'g' then
    -- testing window resizing
    love.graphics.setMode( 1024, 768, false, true, 0 )
    max_width = 1024
    max_height = 768
    --love.graphics.translate( 200, 200 )
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
    if game_state == "running" then
      game_state = "paused"
    end
  else
    print("GAINED FOCUS")
  end
end

function love.quit()
  print("quit()")
end

--
----- MENU FUNCTIONS -----
--

function main_menu()
end

--
----- SNAKE FUNCTIONS -----
--

function move_snake(dt)
  local old_x = snake_loc["head"]["x"]
  local old_y = snake_loc["head"]["y"]
  local temp
  
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