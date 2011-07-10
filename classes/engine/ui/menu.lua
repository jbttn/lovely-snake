Menu = class('Menu')

-- b should be a table of strings
function Menu:initialize(b)
  self.title = b.title
  self.title_loc = max_height * 0.05
  self.buttons = {}
  self.button_loc = 0.25 -- location of the first button
  self.button_space = 0.05 -- verticle spacing of buttons

  for key, value in ipairs(b) do
    if type(value) == "string" then
      table.insert(self.buttons, Button:new(true, value))
    elseif type(value) == "table" then
      table.insert(self.buttons, Button:new(true, value.label))
    end
  end

  for key, value in ipairs(self.buttons) do
    value:set_position({y = self:get_loc(key)})
  end
end

function Menu:update(mouse_x, mouse_y)
  for key, value in ipairs(self.buttons) do
    value:center()
    value:update(mouse_x, mouse_y)
  end
end

function Menu:draw(mouse_x, mouse_y)
  love.graphics.setFont(large_font)
  print_centered(self.title, self.title_loc)
  for key, value in next, self.buttons, nil do
    if type(key) == "number" then
      value:draw(mouse_x, mouse_y)
    end
  end
end

function Menu:clicked(x, y)
  for key, value in ipairs(self.buttons) do
    if value:hovered(x, y) then
      value:clicked()
    end
  end
end

function Menu:get_loc(line_num)
  return (self.button_loc + (line_num * self.button_space)) * max_height
end