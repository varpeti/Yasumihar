kamera = require('kamera')
require('player')
require('kiir')
require('kornyezet')
require('arena')


function love.load()
  --ablak beállítások
  goFullscreen()
  Asz=love.graphics.getWidth()
  Am=love.graphics.getHeight()
  Aksz=Asz/2 Akm=Am/2
  love.window.setTitle("Yasumihar - Váraljai Péter")
  love.window.setIcon(love.image.newImageData("Data/icon.png"))

  --fizikai beállítások
  love.physics.setMeter(10) --10 pixel = 1 méter
  world = love.physics.newWorld(0, 0, true) --vízszintes:0  függőleges: 0

  --Ütközés lekérdezés
  world:setCallbacks(beginContact, endContact, preSolve, postSolve)

  --Mobilos változók
  isandroid=true--love.system.getOS()=="Android"
  tx1, tx2, ty1, ty2 = 0,0,0,0
  t12x = -1
  t12y = -1

  --Sima változók
  kameralock = false

  math.randomseed(os.time())

   player_init()

   kiir:init()

   arena:init()

end

function love.update(dt)

  world:update(dt) --ez kell a fizikai világ frissítéshez

  player_update(dt)

  arena:update(dt)

  for i,kiir in ipairs(kiirasok) do
    kiir:update(i,dt)
  end

end

function love.draw()

  kamera:aPos(px,py) --kamera beállítása: player közepe - képernyő méret fele * nagyitás
  kamera:aRot(pr)
  kamera:set()

  for i,elem in ipairs(kornyezet) do
    elem:draw()
  end

  --love.graphics.rectangle("fill",-10,-10,20,20)

  --love.graphics.rectangle("fill",kornyezet[player].body:getX()-10,kornyezet[player].body:getY()-10,20,20)

  kamera:unset()

  love.graphics.setColor(255,255,255,255)
  --kiirasok
  for i,kiir in ipairs(kiirasok) do
    kiir:draw(i)
  end

  love.graphics.print(px.."       "..py.."   "..#kornyezet.."     "..player,10,10)

end

-- ütközések lekérdezése

function beginContact(a, b, coll)
  if a:getBody() == kornyezet[player].body then elem:rombol(b)
  elseif b:getBody() == kornyezet[player].body then elem:rombol(a) 
  end
  if a:getBody() == kornyezet[player].body or b:getBody() == kornyezet[player].body then
    local x1, y1, x2, y2 = coll:getPositions()
    if px~=nil then
      spawnkiiras(px-x1.." x")
      spawnkiiras(py-y1.." y",3)
    end
  end
end

function endContact(a, b, coll)
    
end

function preSolve(a, b, coll)
    
end

function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
end

function love.wheelmoved( x, y )
  if y>0 then kamera:rScale(-0.1) end
  if y<0 then kamera:rScale(0.1) end
end

--Input eventek (további a gépes inputok a player.lua-ba vannak)

function love.keypressed(key)
   if key == "escape" then
      love.event.quit()
   end
  if key == "menu" or key=="space" then
    if kameralock then kameralock=false pr=0 else kameralock=true end
  end
end

function love.touchpressed(i,x,y)
  if i==0 then tx1=x ty1=y end
  if i==1 then tx2=x ty2=y t12x=0 t12y=0 end
  spawnkiiras(i,10)
end

function love.touchmoved(i,x,y)
  if t12x==-1 then
    px = px + (tx1-x)*speed
    py = py + (ty1-y)*speed
  end

  if i==0 then tx1=x ty1=y end
  if i==1 then tx2=x ty2=y end

  if t12x~=-1 then
    if ( (math.abs(tx1-tx2)<t12x) or (math.abs(ty1-ty2)<t12y) ) and t12x~=0 and t12y~=0
      then kamera:rScale(-0.01)
      else kamera:rScale(0.01)
    end
    t12x=math.abs(tx1-tx2)
    t12y=math.abs(ty1-ty2)
  end
end

function love.touchreleased(i,x,y)
  if i==1 then t12x=-1 t12y=-1 end
end


-- teljes képernyő

function getMaxResolution()
  local modes = love.window.getFullscreenModes()
  table.sort(modes, function(a, b) return a.width*a.height > b.width*b.height end) -- sort from largest to smallest
  return modes[1]
end

function goFullscreen()
  local maxRes = getMaxResolution()
  love.window.setMode(
    1280,--maxRes.width,
    1024,--maxRes.height,
    {
      --fullscreen = true,
      vsync = true
    }
  )
end