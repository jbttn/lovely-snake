-- using setFont in draw causes masive cpu and memory usage, fix this.

function draw_main_menu(mouse_x, mouse_y)
  -- Set the font size
--  love.graphics.setFont(32)
  print_centered(ui.main_menu.title, ui.common.y_title_loc)
  
--  love.graphics.setFont(20)
  display_menu_items(ui.main_menu, mouse_x, mouse_y)
end

function draw_options_menu(mouse_x, mouse_y)
--  love.graphics.setFont(32)
  print_centered(ui.options_menu.title, ui.common.y_title_loc)
--  love.graphics.setFont(20)
  love.graphics.printf("Difficulty", 0, max_height * 0.30, max_width, 'center')
--  love.graphics.setFont(14)
  
  local str, x_pos, y_pos
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
      love.graphics.printf("\n" .. str, x_pos, y_pos, ui.options_menu.difficulty_buttons.width, 'center')
      love.graphics.rectangle("line", x_pos, y_pos, ui.options_menu.difficulty_buttons.width, ui.options_menu.difficulty_buttons.height)
    end
  end
  love.graphics.setColor(colors.white)
  love.graphics.printf("\nBack", max_width * 0.45, max_height * 0.45, max_width * 0.09, 'center')
  love.graphics.rectangle("line", max_width * 0.45, max_height * 0.45, max_width * 0.09, max_height * 0.05)
end

function display_menu_items(t, mouse_x, mouse_y)
  -- take in table and iterate through it displaying each item on a new line
  for key, value in next, t, nil do
    if key == "title" then
      print_centered(value, ui.common.y_title_loc)
    end
    if type(key) == "number" then
      if type(value) == "string" then
        --print text
        --print(small_font:getWidth(value))
        --mouse_inside(checking, x_mouse, y_mouse, x_pos, y_pos, width, height)
        if mouse_inside("y_only", mouse_x, mouse_y, 0, max_height * (ui.common.y_first_loc + ((key - 1) * ui.common.y_vert_space)), max_width, max_height * ui.common.y_vert_space) then
          love.graphics.setColor(colors.red)
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