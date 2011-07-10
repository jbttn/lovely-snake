--[[
      LÖVEly Snake by Joshua Button
                                                                              ]]

love.filesystem.load("lib/middleclass.lua")()

love.filesystem.load("classes/engine/ui/menu.lua")()
love.filesystem.load("classes/engine/ui/button.lua")()
love.filesystem.load("classes/engine/actor.lua")()
love.filesystem.load("classes/engine/level.lua")()
love.filesystem.load("classes/engine/camera.lua")()
love.filesystem.load("classes/snake/snake.lua")()
love.filesystem.load("classes/snake/food.lua")()

love.filesystem.load("engine.lua")()
love.filesystem.load("menus.lua")()

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
  
  x_start = 32 * 12 --hardcoded, this should be set depending on resolution
  y_start = 32 * 8
  
  -- Disable key repeating
  love.keyboard.setKeyRepeat(0, 100)
  
  resolutions = {
    {current=true, x=800, y=600},
    {current=false, x=1440, y=700}
  }
  
  colors = {
    red = {200, 0, 70, 255},
    white = {255, 255, 255, 255},
    black = {0, 0, 0, 255}
  }

  difficulty = {
    very_easy = 0.20,
    easy = 0.15,
    normal = 0.10,
    hard = 0.04,
    very_hard = 0.02,
    menu = 0
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
      "Quit"
    },
    game_over_menu = {
      title = "Game Over",
      "Try Again",
      "Main Menu"
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
      function() display_horizontal_buttons() end, -- function to print difficulty buttons
      "Back"
    }
  }
  
  if love.filesystem.exists("options.cfg") then
    love.filesystem.load("options.cfg")()
  else
    current_difficulty = difficulty.normal
    update_options_file()
  end
  
  score = 0
  if love.filesystem.exists("high_score.cfg") then
    love.filesystem.load("high_score.cfg")()
  else
    high_score = 0
    update_high_score_file()
  end
  
  hovering_over = nil
  block_size = 32 -- Just realized this only works with 10,20,25,50,100 need to think more on collision and resolution
  speed = difficulty.menu -- In milliseconds
  menu_item_loc = 0.30
  menu_item_space = 0.05
  update_key = true -- only update the snakes direction after the update and draw functions are finished
  time_stamp = os.clock()
  
  level = Level:new()
  level:load_level('/resources/levels/snake_1.lua', 32, 32)
  camera = Camera:new()
  snake = Snake:new()
  food = Food:new()
  main_menu = Menu:new(ui.main_menu)
  options_menu = Menu:new(ui.options_menu)
  game_over_menu = Menu:new(ui.game_over_menu)
  bttn = Button:new(true, "WTF")
end

function love.update(dt)
  local mouse_x = love.mouse.getX()
  local mouse_y = love.mouse.getY()

  if game_state == "main_menu" then
    main_menu:update(mouse_x, mouse_y)
    return
  elseif game_state == "options_menu" then
    return
  elseif game_state == "paused" then
    return
  elseif game_state == "game_over" then
    if(score > high_score) then
      update_high_score_file()
      high_score = score
    end
    score = 0
    return
  end
  
  speed = current_difficulty
  
  local new_time_stamp = os.clock()
  if (new_time_stamp - time_stamp) < speed then
    return
  else
    time_stamp = new_time_stamp
  end
  
  if score > high_score then
    high_score = score
  end
  
  level:update_level(dt)
  food:generate()
  snake:move(dt)
  
  update_key = true
end

function love.draw()
  love.graphics.setColor({30, 40, 80, 255})
  love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 20)
  love.graphics.print("HIGH SCORE: " .. high_score, 10, 50)
  love.graphics.print("SCORE: " .. score, 10, 80)
  
  love.graphics.setColor(colors.white)
  -- Get the current x,y locations of the mouse cursor
  local mouse_x = love.mouse.getX()
  local mouse_y = love.mouse.getY()
  
  if game_state == "main_menu" then
    main_menu:draw(mouse_x, mouse_y)
    --draw_main_menu(mouse_x, mouse_y)
    
  elseif game_state == "options_menu" then
    options_menu:draw(mouse_x, mouse_y)
    --draw_options_menu(mouse_x, mouse_y)
    
  elseif game_state == "paused" then
    love.graphics.setColor(colors.white)
    love.graphics.printf("PAUSED", 0, max_height / 2, max_width, 'center')
    
  elseif game_state == "game_over" then
    game_over_menu:draw(mouse_x, mouse_y)
    --draw_game_over_menu(mouse_x, mouse_y)
    
  elseif game_state == "running" then
    level:draw_level()
    --[[ -- drawing in level for now
    -- Draw the snake food
    if next(snake_food) ~= nil then
      love.graphics.setColor(colors.red)
      love.graphics.rectangle("fill", snake_food[1]["x"], snake_food[1]["y"], block_size, block_size)
    end]]

    -- Draw the snake body
    for key, value in pairs(snake.body) do
      love.graphics.setColor(75, 50, 175, 255)
--love.graphics.print(key, 400, 200)
--love.graphics.print(value.x, 400, 250)
--love.graphics.print(value.y, 400, 300)
      --love.graphics.rectangle("fill", value.x, value.y, block_size, block_size - 10)
    end
    
    love.graphics.setColor(colors.white)
    
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
      main_menu:clicked(x, y)
      --[[
      if hovering_over == "New Game" then
        print("clicked new game")
        game_state = "running"
        snake:init() -- need to reset camera position...might need the idea of a spawn point on levels
        if speed == "menu" then
          speed = current_difficulty -- should set to options value from file
        end
      end
      if hovering_over == "Options" then
        print("clicked options")
        game_state = "options_menu"
      end
      if hovering_over == "Quit" then
        print("clicked quit")
        love.event.push('q')
      end
      ]]
    elseif game_state == "game_over" then
      game_over_menu:clicked(x, y)
      --[[
      if hovering_over == "Try Again" then
        print("clicked Try Again")
        game_state = "running"
        snake:init() -- need to reset camera position...might need the idea of a spawn point on levels
      end
      if hovering_over == "Main Menu" then
        print("clicked main menu")
        game_state = "main_menu"
      end
      ]]
    elseif game_state == "options_menu" then
      options_menu:clicked(x, y)
      --[[
      for key, value in next, ui.options_menu.difficulty_buttons, nil do
        if key ~= "width" and key ~= "height" then
          --print(key, value)
          if mouse_inside("both", x, y, ui.options_menu.difficulty_buttons[key].x_pos,
                          ui.options_menu.difficulty_buttons[key].y_pos,
                          ui.options_menu.difficulty_buttons.width,
                          ui.options_menu.difficulty_buttons.height) then
            print("Clicked " .. key)
            current_difficulty = difficulty[key]
            update_options_file()
          end
        end
      end
      if hovering_over == "Back" then
        print("clicked back")
        game_state = "main_menu"
      end
      ]]
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
  elseif key == 'up' and snake.direction ~= 'down' and update_key == true then -- random key spam can kill snake
    snake.direction = "up"
    update_key = false
  elseif key == 'down' and snake.direction ~= 'up' and update_key == true then
    snake.direction = "down"
    update_key = false
  elseif key == 'left' and snake.direction ~= 'right' and update_key == true then
    snake.direction = "left"
    update_key = false
  elseif key == 'right' and snake.direction ~= 'left' and update_key == true then
    snake.direction = "right"
    update_key = false
  end
  
  -- Debug
  if key == 'i' then
    local tmp = level:get_coords("world", snake.body["head"]["x"], snake.body["head"]["y"])
    table.insert(snake.body, {x=tmp.x * 32, y=tmp.y * 32}) --push?
    print("Inserted body at coords x: " .. tmp.x * 32 .. " y: " .. tmp.y * 32)
  elseif key == 'r' then
    table.remove(snake.body) --pop?
  elseif key == 'g' then
    -- testing window resizing
    for i = 1, #resolutions do
      if resolutions[i].current == true and i ~= #resolutions then
        resolutions[i].current = false
        resolutions[i+1].current = true
        love.graphics.setMode(resolutions[i+1].x, resolutions[i+1].y, false, true, 0)
        max_width = resolutions[i+1].x
        max_height = resolutions[i+1].y
        break -- eww, might rewrite
      elseif resolutions[i].current == true and i == #resolutions then
        resolutions[i].current = false
        resolutions[1].current = true
        love.graphics.setMode(resolutions[1].x, resolutions[1].y, false, true, 0)
        max_width = resolutions[1].x
        max_height = resolutions[1].y
        break
      end
    end
    --love.graphics.translate( 200, 200 )
  elseif key == 'f' then
    love.graphics.toggleFullscreen( )
  elseif key == 'm' then
    display_menu_items(ui.main_menu, love.mouse.getX(), love.mouse.getY())
  elseif key == 'escape' then
    game_state = "main_menu"
  elseif key == 'n' then
    cam = Camera:new()
    cam:debug_print()
    cam.bounds.north = 4
    cam.bounds.east = 1
    --cb = cam:get_bounds()
    --print(cb.north, cb.south, cb.east, cb.west)
    --cb.north = 5
    --cb.east = 3
    --cam:set_bounds(cb)
    --print(cb.north, cb.south, cb.east, cb.west)
    cam:debug_print()
    
    sn = Snake:new()
    sn:debug_print()
    sn.position.x = 99 -- works
    print(sn.position.x)
    sn:debug_print()
    --Actor.update_position(sn, 0, 0) -- works
    sn:update_position(0, 0) -- works
    sn:debug_print()
  elseif key == 'd' then
    --act = Actor:new("testing")
    --act:foobar()
  elseif key == 'p' then
    bttn:set_position({x = 100, y = 100})
    bttn:set_label("Hello World!")
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
