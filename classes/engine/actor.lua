Actor = class('Actor')

function Actor:initialize(foo)
  self.foo = foo
end

function Actor:foobar()
  print(self.foo)
end