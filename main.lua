math.randomseed(os.time())

kamera = require('kamera')
player = require('player')
kiir = require('kiir')
require('debug')
env = require('env')
require('fa')


function love.load()
	--ablak beállítások
	goFullscreen()
	Asz=love.graphics.getWidth()
	Am=love.graphics.getHeight()
	Aksz=Asz/2 Akm=Am/2
	love.window.setTitle("Yasumihar - Váraljai Péter")
	love.window.setIcon(love.image.newImageData("Data/icon.png"))
	
	--Mobilos változók
	isandroid=true--love.system.getOS()=="Android"
	tx1, tx2, ty1, ty2 = 0,0,0,0
	t12x = -1
	t12y = -1
	
	--Sima változók
	kameralock = false
	
	player.id = facreate(0,0) --env:ujObj({-10,-10,10,-10,10,10,-10,10})
	
	--env:addObj(player.id,{-50,-50,-30,-50,-40,-40})

    env:getObj(player.id):getBody():setAngularVelocity(0.3)

	--env:ujObj({200,200,150,170,180,110,135,167,123,110})

	--env:getObj(2):getBody():setAngularVelocity(1)

	love.mouse.setPosition(Aksz,Akm)

	DEBUG = false

	kiir:set(nil,nil,10,true,DEBUG,12)

	kiir:new("Gombok:",30)
	kiir:new("WASD, nyilak, egér - kamera mozgás",31)
	kiir:new("SPACE - kameralock",32)
	kiir:new("F8 - Debug",33)
	kiir:new("Görgö - Zoom",34)
	kiir:new("B - kiirteszt",35)
	kiir:new("ESC - kilépés",36)


end

function love.update(dt)

	env:update(dt) --ez kell a fizikai világ frissítéshez
	
	player:update(dt)
	
	kiir:update(dt)

end

function love.draw()

	kamera:aPos(player.x,player.y) --kamera beállítása: player közepe - képernyő méret fele * nagyitás
	kamera:aRot(player.r)
	kamera:set()
	
	env:draw()
	
	local mx,my = kamera:worldCoords(love.mouse:getX()-Aksz,love.mouse:getY()-Akm)
	love.graphics.rectangle("fill",mx-10,my-10,20,20)
	
	kamera:unset()
	
	love.graphics.setColor(255,255,255,255)
	
	kiir:draw(10,Am-25,nil,DEBUG) --kiirasok

	love.graphics.print(player.x.."       "..player.y,10,10)

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
		if kameralock then kameralock=false player.r=0 else kameralock=true end
	end
	if key == "f8" then
		DEBUG = not DEBUG
	end
	if key == "b" then
		kiir:new("Ido: "..os.time())
	end
end

function love.touchpressed(i,x,y)
	if i==0 then tx1=x ty1=y end
	if i==1 then tx2=x ty2=y t12x=0 t12y=0 end
end

function love.touchmoved(i,x,y)
	if t12x==-1 then
		player.x = player.x + (tx1-x)*player.speed
		player.y = pplayer.y + (ty1-y)*player.speed
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