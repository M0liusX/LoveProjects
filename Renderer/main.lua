if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

local triangle2d = require("triangle2d")
local vector2d = require("vector2d")
local math = require("math")
require("mathr")

function love.load()
    -- Initialize framebuffers
    fb = {
            love.graphics.newCanvas(920, 540),
    }
    index = 1

    -- Set window size
    success = love.window.setMode(920, 540, {
            resizable=false, vsync=false, minwidth=300, minheight=400
    })

    -- Set default font
    love.graphics.setNewFont(24)
end

function love.draw()
    -- direct drawing operations to canvas
    love.graphics.setCanvas(fb[index])
    love.graphics.clear()

    -- draw text to canvas
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Hello World", 75, 75)
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
   
    -- draw line to canvas
    local p1 = vector2d(150, 150)
    local p2 = vector2d(250, 250)
    love.drawLine(p1, p2)

    local a = vector2d(300, 200)
    local b = vector2d(300, 300)
    local c = vector2d(250, 300)
    love.drawTriangle(triangle2d(a, b, c))
   
    a = vector2d(500, 400)
    b = vector2d(500, 500)
    c = vector2d(450, 400)
    love.drawTriangle(triangle2d(a, b, c))

    -- re-enable drawing to the main screen
    love.graphics.setCanvas()
    love.graphics.setBlendMode("alpha")
    love.graphics.draw(fb[index])
    love.swap() -- swap to other framebuffer
end

function love.swap()
    index = (index % #fb) + 1
end

function love.drawLine(p1, p2)
    if math.abs(p1.x - p2.x) > math.abs(p1.y - p2.y) then
        local draw = function(x, y) love.graphics.points(x, y) end
        love.drawLineH(p1, p2, draw)
    else
        local draw = function(x, y) love.graphics.points(y, x) end
        love.drawLineH(p1:yx(), p2:yx(), draw)
    end
end

function love.drawLineH(p1, p2, draw)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y
    local derr = math.abs(dy / dx)
    local error = 0.0
    local dir = sign(p2.x - p1.x)
    local y = p1.y
    for i = 0, math.abs(p2.x - p1.x) do
        error = error + derr
        local x = p1.x + dir * i
        if error >= 0.5 then
            y = y + dir
            error = error - 1
        end
        -- local y = p1.y + dy * (x - p1.x) / dx
        draw(x, y)
    end
end
  
function love.drawTriangle(t)
    if t.v2.y == t.v3.y then
        love.drawBottomFlatTriangle(t)
    elseif t.v1.y == t.v2.y then
        love.drawTopFlatTriangle(t)
    end
end

function love.drawBottomFlatTriangle(t)
    local invslope1 = (t.v2.x - t.v1.x) / (t.v2.y - t.v1.y);
    local invslope2 = (t.v3.x - t.v1.x) / (t.v3.y - t.v1.y);
  
    local curx1 = t.v1.x;
    local curx2 = t.v1.x;
  
    for scanlineY = t.v1.y, t.v2.y do
        love.drawLine(vector2d(math.floor(curx1), scanlineY),
                vector2d(math.floor(curx2), scanlineY));
        curx1 = curx1 + invslope1;
        curx2 = curx2 + invslope2;
    end
end

function love.drawTopFlatTriangle(t)
    local invslope1 = (t.v3.x - t.v1.x) / (t.v3.y - t.v1.y);
    local invslope2 = (t.v3.x - t.v2.x) / (t.v3.y - t.v2.y);
  
    local curx1 = t.v3.x;
    local curx2 = t.v3.x;
  
    for scanlineY = t.v3.y, t.v1.y, -1 do
        love.drawLine(vector2d(math.floor(curx1), scanlineY),
                vector2d(math.floor(curx2), scanlineY));
        curx1 = curx1 - invslope1;
        curx2 = curx2 - invslope2;
    end
end
