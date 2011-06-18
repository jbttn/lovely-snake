Camera = class('Camera')

function Camera:initialize()
  self.bounds = {north = 0, south = 0, east = 0, west = 0}
end

function Camera:hit_bounds(direction)
  if direction == "north" then
    north = north + 1
  elseif direction == "south" then
    south = south + 1
  elseif direction == "east" then
    east = east + 1
  elseif direction == "west" then
    west = west + 1
  end
end

function Camera:debug_print()
  print("N: " .. self.bounds.north .. " S: " .. self.bounds.south .. " E: " ..  self.bounds.east .. " W: " ..  self.bounds.west)
end