-- soon to be implemented...once i figure out the level stuff

Snake = class('Snake', Actor)
--AgedPerson.ADULT_AGE = 18 --this is a class variable
function Snake:initialize(foo)
  Actor.initialize(self, foo) -- call the parent's constructor on self
  self.body = {head={x=x_start, y=y_start}}
  self.direction = "up"
  --snake_food = {} --food class?
end

function Snake:foo()
  Actor.foo(self)
end