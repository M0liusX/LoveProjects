local module = {
    _version = "triangle2d.lua v2020.0.1",
    _description = "a simple 2d triangle library for Lua",
}

if triangle2d then return end
local triangle2d = {}
triangle2d.__index = triangle2d

local vector2d = require("vector2d")

local function new(v1, v2, v3)
    local points = {
            v1 or vector2d.new(),
            v2 or vector2d.new(),
            v3 or vector2d.new(),
    }
    table.sort(points, sortVerticesAscendingByY)

    return setmetatable({
            v1 = points[1],
            v2 = points[2],
            v3 = points[3],
            }, triangle2d)
end

function sortVerticesAscendingByY(a, b)
    return a.y < b.y
end

-- pack up and return module
module.new = new
return setmetatable(module, {__call = function(_,...) return new(...) end})