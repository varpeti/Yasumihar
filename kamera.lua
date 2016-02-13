local kamera = {}
kamera.kx = 0
kamera.ky = 0
kamera.sx = 1
kamera.sy = 1
kamera.r = 0


-- set,unset
function kamera:set()
    love.graphics.push()
    love.graphics.scale(1/self.sx,1/self.sy)
    love.graphics.translate(love.graphics.getWidth()/(2/self.sx), love.graphics.getHeight()/(2/self.sy))
    love.graphics.rotate(-self.r)
    love.graphics.translate(-self.kx, -self.ky)
end

function kamera:unset()
    love.graphics.pop()
end
 
--move,pos

function kamera:Move(x,y) --relat
    self.kx = self.kx+x
    self.ky = self.ky+y 
end

function kamera:MoveTo(x, y) --abs
    self.kx = x 
    self.ky = y 
end

-- zoom

function kamera:setScale(sx,sy) --relat
	self.sx = self.sx+self.sx*sx
	self.sy = self.sy+self.sy*sy
end

function kamera:setScaleTo(sx,sy) --abs -- original: 0,0
    self.sx = sx
    self.sy = sy
end

-- rotation 

function kamera:setRotation(r) --relat
	self.r = self.r+self.r*r
end

function kamera:setRotationTo(r) --relat
    self.r = r
end

return kamera