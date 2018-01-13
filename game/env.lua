local env = {}

love.physics.setMeter(10) --10 pixel = 1 méter

env.world = love.physics.newWorld(0, 0, true) -- világ létrehozása 0, 0 gravitációval
env.world:setCallbacks(beginContact, endContact, preSolve, postSolve)

--------
--Local
--------

local function createshape(x,y,coords)
    for i=1,#coords,2 do
        coords[i]=coords[i]-x
        coords[i+1]=coords[i+1]-y
    end
    return love.physics.newPolygonShape(unpack(coords))
end

local function CoM(coords)
    local maxx = 0
    local maxy = 0
    local i = 1
    while i<=#coords do
        maxx=maxx+coords[i]
        maxy=maxy+coords[i+1]
        i=i+2
    end
    local o = #coords/2
    return maxx/o, maxy/o -- A tömeg középpont
end

local function DatA(fixture,szin1,szin2,img,usd)
    local DATA = {}
        DATA.szin1 = {}
        if szin1 ~= nil then
            DATA.szin1.rr = szin1[1]
            DATA.szin1.gg = szin1[2]
            DATA.szin1.bb = szin1[3]
            DATA.szin1.aa = szin1[4]
        else
            DATA.szin1.rr = math.random(128,255)
            DATA.szin1.gg = math.random(128,255)
            DATA.szin1.bb = math.random(128,255)
            DATA.szin1.aa = 128
        end
        DATA.szin2 = {}
        if szin2 ~= nil then
            DATA.szin2.rr = szin2[1]
            DATA.szin2.gg = szin2[2]
            DATA.szin2.bb = szin2[3]
            DATA.szin2.aa = szin2[4]
        else
            DATA.szin2.rr = 255
            DATA.szin2.gg = 255
            DATA.szin2.bb = 255
            DATA.szin2.aa = 128
        end

        DATA.img = img
        DATA.usd = usd

    fixture:setUserData(DATA) -- az objektumban elhelyezi az adatokat
end

---------
--Global
---------

--set

function env:newObj(coords,szin1,szin2,img,usd)

    if #coords<(2*3) or #coords>(2*8) then return nil end

    local x,y = CoM(coords)

    local body = love.physics.newBody(self.world, x, y, "dynamic") -- test
    local shape = createshape(x,y,coords)-- shape: a coords (0;0) pontja az x,y-on van
    local fixture = love.physics.newFixture(body,shape) -- shape testhezkapcsolás
    --body:setAngularDamping(1) -- Forgás lassulása
    --body:setLinearDamping(0.1) -- Lassulás
    DatA(fixture,szin1,szin2,img,usd)

    return fixture
end

function env:addObj(parent,coords,szin1,szin2)

    if #coords<(2*3) or #coords>(2*8) then return nil end

    local x,y = CoM(coords)
    local body = parent:getBody()
    local shape = love.physics.newPolygonShape(unpack(coords)) 
    local fixture = love.physics.newFixture(body,shape) -- shape testhezkapcsolás
    DatA(fixture,szin1,szin2,img,usd)
    return fixture
end

--func

function env:removeObj(fixture)
    if fixture~=nil then
        local body = fixture:getBody()
        if #body:getFixtureList()==1 then
            body:destroy()
        else
            fixture:destroy()
        end
    end
end

function env:click(x,y)

    Fixture:testPoint( x, y )
end


-- draw, update

function env:draw()
    for b,body in ipairs(env.world:getBodyList()) do
        for f,fixture in ipairs(body:getFixtureList()) do
            local shape = fixture:getShape()
            local shapeType = shape:getType()
            local DATA = fixture:getUserData()
    
            if (shapeType == "circle") then
                local x,y = body:getWorldPoint(shape:getPoint())
                local radius = shape:getRadius()
                love.graphics.setColor(DATA.szin1.rr,DATA.szin1.gg,DATA.szin1.bb,DATA.szin1.aa)
                love.graphics.circle("fill",x,y,radius,15)
                love.graphics.setColor(DATA.szin2.rr,DATA.szin2.gg,DATA.szin2.bb,DATA.szin2.aa)
                love.graphics.circle("line",x,y,radius,15)
            elseif (shapeType == "polygon") then
                local points = {body:getWorldPoints(shape:getPoints())}
                love.graphics.setColor(DATA.szin1.rr,DATA.szin1.gg,DATA.szin1.bb,DATA.szin1.aa)
                love.graphics.polygon("fill",points)
                love.graphics.setColor(DATA.szin2.rr,DATA.szin2.gg,DATA.szin2.bb,DATA.szin2.aa)
                love.graphics.polygon("line",points)
            elseif (shapeType == "edge") then
                love.graphics.setColor(DATA.szin1.rr,DATA.szin1.gg,DATA.szin1.bb,DATA.szin1.aa)
                love.graphics.line(body:getWorldPoint(shape:getPoint()))
            elseif (shapeType == "chain") then
                love.graphics.setColor(DATA.szin1.rr,DATA.szin1.gg,DATA.szin1.bb,DATA.szin1.aa)
                love.graphics.line(body:getWorldPoint(shape:getPoint()))
            end

        end

        if cfg.cvar.debug2 then
            love.graphics.setColor(255,255,255,255)
            local x,y = body:getPosition()
            love.graphics.circle("fill",x,y,5,15)
        end
    end 
end

function env:update(dt)
    self.world:update(dt)
end


--Ütközések

function beginContact(a, b, coll)
    if cfg.cvar.debug2 then kiir.add("Ütközés: A: "..table.concat({a:getBody():getPosition()}," ").."       B: "..table.concat({b:getBody():getPosition()},"    "),10) end
    local aUserData = a:getUserData()
    local bUserData = b:getUserData()
end

function endContact(a, b, coll)
    
end

function preSolve(a, b, coll)
    
end

function postSolve(a, b, coll, normalimpulse, tangentimpulse)
    
end

--------
--Vége--
--------

return env