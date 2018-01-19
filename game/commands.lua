local com = {}

local env = require('game/env')

function com.update(dt)
    env:update(dt)
end

function com.draw()
    env:draw()
end

-----------
--Classok--
-----------

function com.newObj(points,color,type,img,usd)
    local color2 = {255,255,255,255} 
    if type==0 then color2={0,255,0,255}
    elseif type==2 then color2={255,0,0,255}
    end

    env:newObj(points,color,color2,img,usd)
end

return com