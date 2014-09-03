path  = "/entity/"
math.randomseed(os.time())
local methods = {"GET", "GET", "GET", "POST"}

request = function()
  return wrk.format(methods[math.random(1, 4)], path)
end
