Camera = class('Camera')

function Camera:initialize()
  self.bounds = {north = 0, south = 0, east = 0, west = 0}
end

function Camera:reset_bounds()
  self.bounds.north = 0
  self.bounds.south = 0
  self.bounds.east = 0
  self.bounds.west = 0
end

-- called when the camera bumps into the level boundry
function Camera:hit_bounds(direction)
  if direction == "north" then
    self.bounds.north = self.bounds.north + 1
  elseif direction == "south" then
    self.bounds.south = self.bounds.south + 1
  elseif direction == "east" then
    self.bounds.east = self.bounds.east + 1
  elseif direction == "west" then
    self.bounds.west = self.bounds.west + 1
  end
end

function Camera:debug_print()
  print("N: " .. self.bounds.north .. " S: " .. self.bounds.south .. " E: " ..  self.bounds.east .. " W: " ..  self.bounds.west)
end