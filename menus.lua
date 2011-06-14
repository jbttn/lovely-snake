function draw_main_menu(mouse_x, mouse_y)
  love.graphics.setFont(medium_font)
  display_menu_items(ui.main_menu, mouse_x, mouse_y)
end

function draw_options_menu(mouse_x, mouse_y)
  display_menu_items(ui.options_menu, mouse_x, mouse_y)
end

function display_menu_items(t, mouse_x, mouse_y)
  -- take in table and iterate through it displaying each item on a new line
  for key, value in next, t, nil do
    if key == "title" then
      love.graphics.setFont(large_font)
      print_centered(value, ui.common.y_title_loc)
    end
    if type(key) == "number" then
      if type(value) == "string" then
        love.graphics.setFont(medium_font)
        if mouse_inside("y_only", mouse_x, mouse_y, 0, max_height * (ui.common.y_first_loc + ((key - 1) * ui.common.y_vert_space)), max_width, max_height * ui.common.y_vert_space) then
          love.graphics.setColor(colors.red)
          hovering_over = value -- temp solution...
        else
          love.graphics.setColor(colors.white)
        end
        print_centered(value, max_height * (ui.common.y_first_loc + ((key - 1) * ui.common.y_vert_space)))
        love.graphics.setColor(colors.white)
      elseif type(value) == "function" then
        --call the function
        value()
      end
    end
    --print(key, value, type(value))
  end
end

function display_horizontal_buttons()
  local str, x_pos, y_pos
  
  love.graphics.setFont(small_font)
  for key, value in next, ui.options_menu.difficulty_buttons, nil do
    if key ~= "width" and key ~= "height" then
      --print(key, value)
      for key1, value1 in next, ui.options_menu.difficulty_buttons[key], nil do
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
      love.graphics.printf(str, x_pos, y_pos + 7, ui.options_menu.difficulty_buttons.width, 'center')
      --love.graphics.rectangle("line", x_pos, y_pos, ui.options_menu.difficulty_buttons.width, ui.options_menu.difficulty_buttons.height)
    end
  end
  love.graphics.setColor(colors.white)
end