Button = class('Button')

function Button:initialize(centered, l, p)
  self.label = l or ""
  self.position = p or {x = 0, y = 0}
  self.size = {w = medium_font:getWidth(self.label), h = medium_font:getHeight()}

  if centered then
    self:center()
  end
end

function Button:set_position(pos)
  self.position.x = pos.x or self.position.x
  self.position.y = pos.y or self.position.y
end

function Button:set_size(w, h)
  self.size.w = w
  self.size.h = h
end

function Button:set_label(str)
  self.label = str

  self.size.w = medium_font:getWidth(str)
  self.size.h = medium_font:getHeight()
end

function Button:center()
  self.position.x = (max_width / 2) - (self.size.w / 2)
  return self.position.x -- centered x position
end

function Button:hovered(mouse_x, mouse_y)
  if mouse_inside("both", mouse_x, mouse_y, self.position.x, self.position.y, self.size.w, self.size.h) then
    --print("Hovering over ", self.label)
    return true
  else
    --print("Not hovering")
    return false
  end
end

function Button:selected()
  -- Highlight selected options
  if game_state == "difficulty_menu" then
    for key, value in next, ui.difficulty_menu, nil do
      if current_difficulty == value.option then
        return value
      end
    end
  end

  if game_state == "resolutions_menu" then
    for key, value in next, ui.resolutions_menu, nil do
      if max_width == value.width and max_height == value.height then
        return value
      end
    end
  end

end

function Button:clicked(func)
  print("clicked ", self.label)
  click_event(self.label)
  --func()
end

function Button:update(mouse_x, mouse_y)
  if self:hovered(mouse_x, mouse_y) then
    --hovering_over = self.label -- temp solution...
  else
    --hovering_over = ""
  end
end

function Button:draw(mouse_x, mouse_y)
  local selected = self:selected() or {} -- to highlight the selected menu options

  if self:hovered(mouse_x, mouse_y) then
    love.graphics.setColor(colors.red)
  end
  if selected.label == self.label then
    love.graphics.setColor(colors.red)
  end
  love.graphics.setFont(medium_font)
  love.graphics.print(self.label, self.position.x, self.position.y)
  love.graphics.setColor(colors.white)
end