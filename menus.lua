-- using setFont in draw causes masive cpu and memory usage, fix this.

function draw_main_menu(mouse_y)
  -- Set the font size
--  love.graphics.setFont(32)
  -- For completly centered text
  love.graphics.printf("LOVEly Snake", 0, max_height * 0.05, max_width, 'center')
  
--  love.graphics.setFont(20)
  for i = 1, #main_menu_items do
    if mouse_y >= max_height * (menu_item_loc + (menu_item_space * (i - 1))) and mouse_y < max_height * (menu_item_loc + (menu_item_space * i)) then
      love.graphics.setColor(colors.red)
    else
      love.graphics.setColor(colors.white)
    end
    love.graphics.printf(main_menu_items[i], 0, max_height * (menu_item_loc + (menu_item_space * (i - 1))), max_width, 'center')
  end
end

function draw_options_menu(mouse_x, mouse_y)
--  love.graphics.setFont(32)
  love.graphics.printf("Options", 0, max_height * 0.05, max_width, 'center')
--  love.graphics.setFont(20)
  love.graphics.printf("Difficulty", 0, max_height * 0.30, max_width, 'center')
--  love.graphics.setFont(14)
  
  local str, x_pos, y_pos
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
      end
      if speed == difficulty[key] then
        love.graphics.setColor(colors.red)
      else
        love.graphics.setColor(colors.white)
      end
      love.graphics.printf("\n" .. str, x_pos, y_pos, ui_items.difficulty_buttons.width, 'center')
      love.graphics.rectangle("line", x_pos, y_pos, ui_items.difficulty_buttons.width, ui_items.difficulty_buttons.height)
    end
  end
  love.graphics.setColor(colors.white)
  love.graphics.printf("\nBack", max_width * 0.45, max_height * 0.45, max_width * 0.09, 'center')
  love.graphics.rectangle("line", max_width * 0.45, max_height * 0.45, max_width * 0.09, max_height * 0.05)
end