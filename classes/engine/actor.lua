Actor = class('Actor')

function Actor:initialize()
  self.position = {x = 0, y = 0} -- position of the actor in game world coordinates
end

function Actor:update_position(x, y) -- TEST THIS
  --level:get_coords("world", snake_loc["head"]["x"], snake_loc["head"]["y"])
  --self.position.x = x
  --self.position.y = y
  local coords = level:get_coords("world", x, y)
  
  self.position.x = coords.x
  self.position.y = coords.y
  
  return coords
end