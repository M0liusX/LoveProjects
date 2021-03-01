local module = {
    _version = "vector2d.lua v2020.0.1",
    _description = "a simple 2d vector library for Lua",
}

if vector2d then return end
local vector2d = {}
vector2d.__index = vector2d

local function new(x, y)
    return setmetatable({x = x or 0, y = y or 0}, vector2d)
end

function vector2d:yx()
    return new(self.y, self.x)
end

-- pack up and return module
module.new = new
return setmetatable(module, {__call = function(_,...) return new(...) end})