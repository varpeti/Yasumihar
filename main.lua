math.randomseed(os.time())

kamera = require('kamera')
player = require('player')
kiir = require('kiir')
env = require('env')
kepernyo = require('kepernyo')
require('fa')


function love.load()
	--ablak beállítások
	kepernyo:goFullscreen()
	Asz=love.graphics.getWidth()
	Am=love.graphics.getHeight()
	Aksz=Asz/2 Akm=Am/2
	love.window.setTitle("Yasumihar - Váraljai Péter")
	love.window.setIcon(love.image.newImageData("Data/icon.png"))
	
	--Mobilos változók
	isandroid=love.system.getOS()=="Android"
 	tue = {}
	
	--Sima változók
	kameralock = false
	DEBUG = false


	env:setCallbacks()

	env:newObj({-50,-50,-30,50,40,40})
	env:addObj(1,{200,200,150,170,180,110,135,167,123,110})
	env:getObj(1):getBody():setPosition(200,0)

	env:newObj({-50,-50,-30,50,40,40})
    env:newObj({200,200,150,170,180,110,135,167,123,110})
	
	player.id = facreate(-700,-700) --env:newObj({-10,-10,10,-10,10,10,-10,10})

    env:getObj(player.id):getBody():setAngularVelocity(0.3)

	env:getObj(1):getBody():setAngularVelocity(-0.5)

	love.mouse.setPosition(Aksz,Akm)


	kiir:set(nil,nil,10,true,DEBUG,12)

	kiir:new("Gombok:",30)
	kiir:new("WASD, nyilak, egér - kamera mozgás",31)
	kiir:new("SPACE - kameralock",32)
	kiir:new("F8 - Debug",33)
	kiir:new("Görgö - Zoom",34)
	kiir:new("B - kiirteszt",35)
	kiir:new("R - kameraforgatás (kameralock esetében is!)",36)
	kiir:new("ESC - kilépés",37)

end

function love.update(dt)

	env:update(dt) --ez kell a fizikai világ frissítéshez
	
	player:update(dt)
	
	kiir:update(dt)

end

function love.draw()

	kamera:aPos(player.x,player.y) --kamera beállítása: player közepe - képernyő méret fele * nagyitás
	kamera:aRot(player.r+player.kr)
	kamera:set()
	
	env:draw()
	
	local mx,my = kamera:worldCoords(love.mouse:getX()-Aksz,love.mouse:getY()-Akm)
	love.graphics.rectangle("fill",mx-10,my-10,20,20)
	
	kamera:unset()
	
	love.graphics.setColor(255,255,255,255)
	
	kiir:draw(10,Am-25,nil,DEBUG) --kiirasok

	love.graphics.print(player.x.."       "..player.y.."\n"..mx.."      "..my,10,10)

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


function love.touchmoved(id, x, y, dx, dy)

	if tue[1]~=nil and tue[2]~=nil then
		if tue[1].id==id then 
			if ((tue[2].x-x)^2+(tue[2].y-y)^2)^(1/2)<((tue[2].x-tue[1].x)^2+(tue[2].y-tue[1].y)^2)^(1/2) then
				--kiir:new("1+",0.5)
				kamera:rScale(0.01)
			else
 				--kiir:new("1-",0.5)
 				kamera:rScale(-0.01)
			end
			tue[1].x=x
			tue[1].y=y
		end

		if tue[2].id==id then
			if ((tue[1].x-x)^2+(tue[1].y-y)^2)^(1/2)<((tue[1].x-tue[2].x)^2+(tue[1].y-tue[2].y)^2)^(1/2) then 
				--kiir:new("2+",0.5)
				kamera:rScale(0.01)
			else
				--kiir:new("2-",0.5)
				kamera:rScale(-0.01)
			end
			tue[2].x=x
			tue[2].y=y
		end
	elseif tue[2]==nil then
		player.x = player.x-dx
		player.y = player.y-dy
	end
end

function love.touchpressed(id,x,y)
	t = {}
	t.x=x
	t.y=y
	t.id=id
	table.insert(tue,t)
	--kiir:new(#tue.." p")
	if #tue==3 then love.keypressed("menu") end
end

function love.touchreleased(id,x,y)
	table.remove(tue,#tue)
	--kiir:new((#tue+1).." t")
end