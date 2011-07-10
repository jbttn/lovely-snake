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

  game_state = "main_menu" -- main_menu, options_menu, difficulty_menu, resolutions_menu, running, paused, game_over
  
  small_font = love.graphics.newFont(14)
  medium_font = love.graphics.newFont(20)
  large_font = love.graphics.newFont(32)
  
  x_start = 32 * 12 --hardcoded, this should be set depending on resolution
  y_start = 32 * 8
  
  -- Disable key repeating
  love.keyboard.setKeyRepeat(0, 100)
  
  colors = {
    red = {200, 0, 70, 255},
    white = {255, 255, 255, 255},
    black = {0, 0, 0, 255}
  }

  ui = {
    main_menu = {
      title = "LOVEly Snake",
      "New Game",
      "Options",
      "Quit"
    },
    options_menu = {
      title = "Options",
      "Difficulty",
      "Resolutions",
      "Back"
    },
    difficulty_menu = {
      title = "Difficulty",
      {label = "Very Easy", option = 0.20},
      {label = "Easy", option = 0.15},
      {label = "Normal", option = 0.10},
      {label = "Hard", option = 0.04},
      {label = "Very Hard", option = 0.02},
      "Back"
    },
    resolutions_menu = {
      title = "Resolutions",
      {label = "800 x 600", width = 800, height = 600},
      {label = "1024 x 768", width = 1024, height = 768},
      {label = "1920 x 1080", width = 1920, height = 1080},
      "Back"
    },
    game_over_menu = {
      title = "Game Over",
      "Try Again",
      "Main Menu"
    }
  }
  
  load_files()
  
  hovering_over = nil
  block_size = 32
  update_key = true -- only update the snakes direction after the update and draw functions are finished
  time_stamp = os.clock()
  
  level = Level:new()
  level:load_level('/resources/levels/snake_1.lua', 32, 32)
  camera = Camera:new()
  snake = Snake:new()
  food = Food:new()
  main_menu = Menu:new(ui.main_menu)
  options_menu = Menu:new(ui.options_menu)
  difficulty_menu = Menu:new(ui.difficulty_menu)
  resolutions_menu = Menu:new(ui.resolutions_menu)
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
    options_menu:update(mouse_x, mouse_y)
    return
  elseif game_state == "difficulty_menu" then
    difficulty_menu:update(mouse_x, mouse_y)
    return
  elseif game_state == "resolutions_menu" then
    resolutions_menu:update(mouse_x, mouse_y)
    return
  elseif game_state == "game_over" then
    game_over_menu:update(mouse_x, mouse_y)
    if(score >= high_score) then
      update_high_score_file()
      high_score = score
    end
    score = 0
    return
  elseif game_state == "paused" then
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
  love.graphics.setColor(colors.white)
  -- Get the current x,y locations of the mouse cursor
  local mouse_x = love.mouse.getX()
  local mouse_y = love.mouse.getY()
  
  if game_state == "main_menu" then
    main_menu:draw(mouse_x, mouse_y)
    
  elseif game_state == "options_menu" then
    options_menu:draw(mouse_x, mouse_y)

  elseif game_state == "difficulty_menu" then
    difficulty_menu:draw(mouse_x, mouse_y)

  elseif game_state == "resolutions_menu" then
    resolutions_menu:draw(mouse_x, mouse_y)
    
  elseif game_state == "game_over" then
    love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 20)
    love.graphics.print("HIGH SCORE: " .. high_score, 10, 50)
    love.graphics.print("SCORE: " .. score, 10, 80)
    game_over_menu:draw(mouse_x, mouse_y)

  elseif game_state == "paused" then
    love.graphics.setColor(colors.white)
    love.graphics.printf("PAUSED", 0, max_height / 2, max_width, 'center')
    
  elseif game_state == "running" then
    -- no native support for z-ordering, whatever is drawn first is on the bottom it seems like.
    level:draw_level()

    love.graphics.setColor({30, 40, 80, 255})
    love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 20)
    love.graphics.print("HIGH SCORE: " .. high_score, 10, 50)
    love.graphics.print("SCORE: " .. score, 10, 80)
    love.graphics.setColor(colors.white)

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
    elseif game_state == "game_over" then
      game_over_menu:clicked(x, y)
    elseif game_state == "options_menu" then
      options_menu:clicked(x, y)
    elseif game_state == "difficulty_menu" then
      difficulty_menu:clicked(x, y)
    elseif game_state == "resolutions_menu" then
      resolutions_menu:clicked(x, y)
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
  elseif key == 'up' and snake.direction ~= 'down' and update_key == true then
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
    --
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