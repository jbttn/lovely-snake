Food = class('Food', Actor)

function Food:initialize(foo)
  Actor.initialize(self) -- call the parent's constructor on self
  self.list = {}
end

function Food:generate()
  local level_size = level:get_level_size()
  if next(self.list) == nil then -- Table is empty
    local random_x = block_size * math.random(0, (level_size.width - block_size) / block_size)
    local random_y = block_size * math.random(0, (level_size.height - block_size) / block_size)
    --self.list = {x=random_x, y=random_y}
    -- Inserting this way means we can have multiple snake foods, maybe with different attributes
    table.insert(self.list, {x = random_x, y = random_y})
    print("Food inserted at: " .. self.list[1]["x"] .. " " .. self.list[1]["y"])
  end
end