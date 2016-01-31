kamera = {}
kamera.kx = 0
kamera.ky = 0
kamera.sx = 1
kamera.sy = 1
kamera.r = 0


function kamera:set()
  love.graphics.push()
  love.graphics.rotate(-self.r)
  love.graphics.scale(1/self.sx, 1/self.sy)
  love.graphics.translate(-self.kx, -self.ky)
end
 

function kamera:setPosition(x, y)
 self.kx = x 
 self.ky = y
end

function kamera:setScale(sx, sy)
  if sx then self.sx = sx end
  if sy then self.sy = sy end
end

function kamera:setRotation(r)
 self.r = r
end

function kamera:unset()
  love.graphics.pop()
end