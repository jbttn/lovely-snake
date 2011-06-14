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
  
  small_font = love.graphics.newFont(14)
  medium_font = love.graphics.newFont(20)
  large_font = love.graphics.newFont(32)
  
  x_start = max_width / 2
  y_start = max_height / 2
  
  --snake_loc = {{x_start, y_start}}
  snake_loc = {head={x=x_start, y=y_start}}
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
 
  ui = {
    common = {
      y_title_loc = max_height * 0.05, -- Vertical spacing of the title as a percentage from the top
      y_first_loc = 0.30, -- Vertical location of the first menu item
      y_vert_space = 0.06 -- changed from 0.05 to 0.06, test more
    },
    main_menu = {
      title = "LOVEly Snake",
      "New Game",
      "Options",
      "Quit",
    },
    options_menu = {
      title = "Options",
      difficulty_buttons = {
        width = max_width * 0.09,
        height = max_height * 0.05,
        very_easy = {str="V.Easy", x_pos=max_width * 0.25, y_pos=max_height * 0.35}, -- these need to be updated on screen resize
        easy = {str="Easy", x_pos=max_width * 0.35, y_pos=max_height * 0.35},
        normal = {str="Normal", x_pos=max_width * 0.45, y_pos=max_height * 0.35},
        hard = {str="Hard", x_pos=max_width * 0.55, y_pos=max_height * 0.35},
        very_hard = {str="V.Hard", x_pos=max_width * 0.65, y_pos=max_height * 0.35}
      },
      "Difficulty",
      function () display_horizontal_buttons() end, -- function to print difficulty buttons
      "Back"
    }
  }
  
  hovering_over = nil
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
    draw_main_menu(mouse_x, mouse_y)
    
  elseif game_state == "options_menu" then
    draw_options_menu(mouse_x, mouse_y)
    
  elseif game_state == "paused" then
    love.graphics.setColor(colors.white)
    love.graphics.printf("PAUSED", 0, max_height / 2, max_width, 'center')
    
  elseif game_state == "game_over" then
    -- Game over
    
  elseif game_state == "running" then
    -- Draw the snake food
    if next(snake_food) ~= nil then
      love.graphics.setColor(colors.red)
      love.graphics.rectangle("fill", snake_food[1]["x"], snake_food[1]["y"], block_size, block_size)
      love.graphics.setColor(0, 0, 255, 255)
    end
    
    -- Draw the snake body
    for key, value in pairs(snake_loc) do
      love.graphics.rectangle("fill", value.x, value.y, block_size, block_size)
    end
    
  end
end

function love.mousepressed(x, y, button)
  if button == 'l' then
    -- button 1 clicked at position x, y
  end
end

function love.mousereleased(x, y, button) -- needs updated to work with menus, temp solution for now.
  if button == 'l' then
    
    if game_state == "main_menu" then
      if hovering_over == "New Game" then
        print("clicked new game")
        game_state = "running"
        if speed == "menu" then
          speed = difficulty.normal -- should set to options value from file
        end
      end
      if hovering_over == "Options" then
        print("clicked options")
        game_state = "options_menu"
      end
      if hovering_over == "Quit" then
        print("clicked quit")
      end
      
    elseif game_state == "options_menu" then
      for key, value in next, ui.options_menu.difficulty_buttons, nil do
        if key ~= "width" and key ~= "height" then
          --print(key, value)
          if mouse_inside("both", x, y, ui.options_menu.difficulty_buttons[key].x_pos,
                          ui.options_menu.difficulty_buttons[key].y_pos,
                          ui.options_menu.difficulty_buttons.width,
                          ui.options_menu.difficulty_buttons.height) then
            print("Clicked " .. key)
            speed = difficulty[key] -- temporary
          end
        end
      end
      if hovering_over == "Back" then
        print("clicked back")
        game_state = "main_menu"
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
  elseif key == 'm' then
    display_menu_items(ui.main_menu, love.mouse.getX(), love.mouse.getY())
  elseif key == 's' then
    print(love.filesystem.getSaveDirectory())
  elseif key == 'escape' then
    game_state = "main_menu"
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

-- checks to see if the mosue is clicked or hovered inside a rectangle
function mouse_inside(checking, x_mouse, y_mouse, x_pos, y_pos, width, height)
  local valid_x = false
  local valid_y = false

  if x_mouse >= x_pos and x_mouse < x_pos + width then
    valid_x = true
  end
  if y_mouse >= y_pos and y_mouse < y_pos + height then
    valid_y = true
  end
  
  if checking == "x_only" then
    return valid_x
  elseif checking == "y_only" then
    return valid_y
  elseif checking == "both" then
    if valid_x == true and valid_y == true then
      return true
    else
      return false
    end
  end
end

-- string, y position
function print_centered(s, y)
  love.graphics.printf(s, 0, y, max_width, 'center')
end