--[[
      LÖVEly Snake by Joshua Button
      
      TODOS:
        * Add countdown on unpause
        * Better way to handle game states
        * Main menu with options screen for difficulty and other options
        * Option to turn wall collision on or off
        * Option to change game colors?
        * Mouse controls (snake travels twords cursor position)
        * Multiple food items? Powerups?
        * Score board with high scores
        * Sound effects?
        * Clean up code
                                                                              ]]

love.filesystem.load("menus.lua")()
love.filesystem.load("snake.lua")()

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
  -- need to figure out a way to get rid of difficulty_str as it is redundant yet some menus depend on it
  ui_items = {
    difficulty_str = {
      "V.Easy",
      "Easy",
      "Normal",
      "Hard",
      "V.Hard"
    },
    difficulty_buttons = {
      width = max_width * 0.09,
      height = max_height * 0.05,
      very_easy = {str="V.Easy", x_pos=max_width * 0.25, y_pos=max_height * 0.35},
      easy = {str="Easy", x_pos=max_width * 0.35, y_pos=max_height * 0.35},
      normal = {str="Normal", x_pos=max_width * 0.45, y_pos=max_height * 0.35},
      hard = {str="Hard", x_pos=max_width * 0.55, y_pos=max_height * 0.35},
      very_hard = {str="V.Hard", x_pos=max_width * 0.65, y_pos=max_height * 0.35}
    }
  }
  
  block_size = 20 -- Just realized this only works with 10,20,25,50,100 need to think more on collision and resolution
  speed = difficulty.menu -- In milliseconds
  menu_item_loc = 0.30
  menu_item_space = 0.05
end

function love.update(dt)
  love.timer.sleep(speed)
  
  if game_state == "main_menu" then
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
  -- Get the current x,y locations of the mouse cursor
  local mouse_x = love.mouse.getX()
  local mouse_y = love.mouse.getY()
  
  if game_state == "main_menu" then
    draw_main_menu(mouse_y)
  elseif game_state == "options_menu" then
    draw_options_menu(mouse_x, mouse_y)
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
    elseif game_state == "options_menu" then
      for key, value in next, ui_items.difficulty_buttons, nil do
        if key ~= "width" and key ~= "height" then
          --print(key, value)
          if click_inside(x, y, ui_items.difficulty_buttons[key].x_pos, ui_items.difficulty_buttons[key].y_pos, ui_items.difficulty_buttons.width, ui_items.difficulty_buttons.height) then
            print("Clicked " .. key)
            speed = difficulty[key] -- temporary
          end
          --for key1, value1 in next, ui_items.difficulty_buttons[key], nil do
            --print(key1, value1)
            --if click_inside(x, y, ui_items.difficulty_buttons["very_easy"].x_pos, ui_items.difficulty_buttons["very_easy"].y_pos, ui_items.difficulty_buttons.width, ui_items.difficulty_buttons.height) then
            --end
          --end
        end
      end
--      if click_inside(x, y, ui_items.difficulty_buttons["very_easy"].x_pos, ui_items.difficulty_buttons["very_easy"].y_pos, ui_items.difficulty_buttons.width, ui_items.difficulty_buttons.height) then
--        print("Clicked very easy")
--      end
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
----- OTHER FUNCS -----
--

-- checks to see if the click is inside a rectangle
function click_inside(x_click, y_click, x_pos, y_pos, width, height)
  local valid_x = false
  local valid_y = false
  
  if x_click >= x_pos and x_click < x_pos + width then
    valid_x = true
  end
  if y_click >= y_pos and y_click < y_pos + height then
    valid_y = true
  end
  
  if valid_x == true and valid_y == true then
    return true
  else
    return false
  end
end