-- using setFont in draw causes masive cpu and memory usage, fix this.

function draw_main_menu(mouse_y)
  -- Set the font size
--  love.graphics.setFont(32)
  -- For completly centered text
  love.graphics.printf("LOVEly Snake", 0, max_height * 0.05, max_width, 'center')
  
--  love.graphics.setFont(20)
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
end

function draw_options_menu(mouse_x, mouse_y)
  local x_button_pos = 0.25
  
--  love.graphics.setFont(32)
  love.graphics.printf("Options", 0, max_height * 0.05, max_width, 'center')
--  love.graphics.setFont(20)
  love.graphics.printf("Difficulty", 0, max_height * 0.30, max_width, 'center')
  -- draw image buttons here
--  love.graphics.setFont(14)
  --[[
  love.graphics.setColor(colors.red)
  love.graphics.printf("V.Easy", max_width * 0.25, max_height * 0.36, max_width * 0.09, 'center')
  love.graphics.setColor(colors.white)
  love.graphics.rectangle( "line", max_width * 0.25, max_height * 0.35, max_width * 0.09, max_height * 0.05 )
  love.graphics.rectangle( "line", max_width * 0.35, max_height * 0.35, max_width * 0.09, max_height * 0.05 )
  love.graphics.rectangle( "line", max_width * 0.45, max_height * 0.35, max_width * 0.09, max_height * 0.05 )
  love.graphics.rectangle( "line", max_width * 0.55, max_height * 0.35, max_width * 0.09, max_height * 0.05 )
  love.graphics.rectangle( "line", max_width * 0.65, max_height * 0.35, max_width * 0.09, max_height * 0.05 )]]
--[[  
  for i = 1, #ui_items.difficulty_str do
    love.graphics.printf(ui_items.difficulty_str[i], max_width * (0.25 + (0.10 * (i - 1))), max_height * 0.36, max_width * 0.09, 'center')
    love.graphics.rectangle( "line", max_width * (0.25 + (0.10 * (i - 1))), max_height * 0.35, max_width * 0.09, max_height * 0.05 )
--    if #ui_items.difficulty_buttons < #ui_items.difficulty_str then
--      table.insert(ui_items.difficulty_buttons, {x_pos=max_width * (0.25 + (0.10 * (i - 1))), y_pos=(max_height * 0.35), width=(max_width * 0.09), height=(max_height * 0.05)})
      --print(ui_items.difficulty_buttons[i].x_pos)
--    end
  end]]
  
  local str, x_pos, y_pos, width, height
  for key, value in next, ui_items.difficulty_buttons, nil do
    if key ~= "width" and key ~= "height" then
      --print(key, value)
      for key1, value1 in next, ui_items.difficulty_buttons[key], nil do
        if key1 == "str" then
          str = value1
        elseif key1 == "x_pos" then
          x_pos = value1
        elseif key1 == "y_pos" then
          y_pos = value1
        end
        --love.graphics.printf(ui_items.difficulty_str[i], max_width * (0.25 + (0.10 * (i - 1))), max_height * 0.36, max_width * 0.09, 'center')
        --love.graphics.rectangle( "line", max_width * (0.25 + (0.10 * (i - 1))), max_height * 0.35, max_width * 0.09, max_height * 0.05 )
      end
    end
    --print(str, x_pos, y_pos * 1.01, max_height * 0.36)
    if speed == difficulty[key] then
      love.graphics.setColor(colors.red)
    else
      love.graphics.setColor(colors.white)
    end
    love.graphics.printf("\n" .. str, x_pos, y_pos, ui_items.difficulty_buttons.width, 'center') -- weird bug displaying hard and very_hard
    --love.graphics.rectangle("line", x_pos, y_pos, ui_items.difficulty_buttons.width, ui_items.difficulty_buttons.height)
  end
end