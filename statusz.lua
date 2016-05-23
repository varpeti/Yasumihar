local statusz = {}
statusz.j = ""
statusz.b = ""
statusz.zoomenabled = false

--[[
	statusz.j =
		fomenu
			menu
				single
					game
				multi
					create
						@game
					join
						@game
			beallitasok
			info
			credit
			exit
]]

function statusz:set(jid)

	env:removeObj()
	player.x,player.y = 0,0
	player.r = 0
	kamera:aScale(1,1)

	if jid=="fomenu" then

		local x,y = kepernyo.Asz/2, kepernyo.Am/2
		local i = -2
		env:newObj("Menu",{-x/4,-y/8+(y/3)*i,-x/4,y/8+(y/3)*i,x/4,y/8+(y/3)*i,x/4,-y/8+(y/3)*i},nil,"Új játék") i=i+1
		env:newObj("Menu",{-x/4,-y/8+(y/3)*i,-x/4,y/8+(y/3)*i,x/4,y/8+(y/3)*i,x/4,-y/8+(y/3)*i},nil,"Beállítások") i=i+1
		env:newObj("Menu",{-x/4,-y/8+(y/3)*i,-x/4,y/8+(y/3)*i,x/4,y/8+(y/3)*i,x/4,-y/8+(y/3)*i},nil,"Információk") i=i+1
		env:newObj("Menu",{-x/4,-y/8+(y/3)*i,-x/4,y/8+(y/3)*i,x/4,y/8+(y/3)*i,x/4,-y/8+(y/3)*i},nil,"Credit") i=i+1
		env:newObj("Menu",{-x/4,-y/8+(y/3)*i,-x/4,y/8+(y/3)*i,x/4,y/8+(y/3)*i,x/4,-y/8+(y/3)*i},nil,"Kilépés")

		statusz.zoomenabled = false

	elseif jid=="menu" then 

	elseif jid=="game" then 
		env:setCallbacks()

		env:newPlayer("Gaia",{rr=000,gg=200,bb=200})
	
		env:newObj("Gaia",{-50,-50,-30,50,40,40})
		env:addObj("Gaia",1,{200,200,150,170,180,110,135,167,123,110})
		env:getObj(1):getBody():setPosition(200,0)
	
		env:newObj("Gaia",{-50,-50,-30,50,40,40})
    	env:newObj("Gaia",{200,200,150,170,180,110,135,167,123,110})
		
		env:newPlayer("Player001",{rr=255,gg=255,bb=255})
		player.id = facreate("Player001",-700,-700)
	
    	env:getObj(player.id):getBody():setAngularVelocity(0.3)
	
		env:getObj(1):getBody():setAngularVelocity(-0.1)
	
		love.mouse.setPosition(love.graphics.getWidth()/2,love.graphics.getHeight()/2)
	
		kiir:new([[Balra fel van a "hajó"]],20)
		
		statusz.zoomenabled=true

	elseif jid=="single" then

	elseif jid=="multi" then

	elseif jid=="create" then

	elseif jid=="join" then

	elseif jid=="beallitasok" then

		kiir:new("",60)
		kiir:new("Még nem elérhető",60)

		local x,y = kepernyo.Asz/2, kepernyo.Am/2
		local i = 0
		env:newObj("Menu",{-x/4,-y/8+(y/3)*i,-x/4,y/8+(y/3)*i,x/4,y/8+(y/3)*i,x/4,-y/8+(y/3)*i},nil,"Vissza")

	elseif jid=="info" then
		
		kiir:new("",46)
		kiir:new("Gombok:",30)
		kiir:new("WASD, egér - kamera mozgás",31)
		kiir:new("SPACE - kameralock",32)
		kiir:new("F8 - Debug",33)
		kiir:new("Görgö - Zoom",34)
		kiir:new("B - kiirteszt",35)
		kiir:new("R - kameraforgatás",36)
		kiir:new("F11 - teljesképernyö",37)
		kiir:new("Kattintás - objektum törlés",38)
		kiir:new("",39)
		kiir:new("Android:",40)
		kiir:new("Húzás - kameramozgatás",41)
		kiir:new("2 új - zoom",42)
		kiir:new("3 új - kameralock",43)
		kiir:new("ESC - vissza, kilépés",44)
		kiir:new("",45)

		local x,y = kepernyo.Asz/2, kepernyo.Am/2
		local i = 0
		env:newObj("Menu",{-x/4,-y/8+(y/3)*i,-x/4,y/8+(y/3)*i,x/4,y/8+(y/3)*i,x/4,-y/8+(y/3)*i},nil,"Vissza")

	elseif jid=="credit" then

		kiir:new("",60)
		kiir:new("Programozó, ötletgazda, zeneszerzö,",60)
		kiir:new("animátor, designer, isten,",60)
		kiir:new("készítö, alkotó, algoritmizáló:",60)
		kiir:new("Váraljai Péter",60)

		local x,y = kepernyo.Asz/2, kepernyo.Am/2
		local i = 0
		env:newObj("Menu",{-x/4,-y/8+(y/3)*i,-x/4,y/8+(y/3)*i,x/4,y/8+(y/3)*i,x/4,-y/8+(y/3)*i},nil,"Vissza")

	end
	statusz.b=statusz.j
	statusz.j=jid
end

function statusz:update(dt)
	if statusz.j=="fomenu" then
		--statusz:set("game")

	elseif statusz.j=="menu" then 

	elseif statusz.j=="game" then 

		env:update(dt) --ez kell a fizikai világ frissítéshez
		player:update(dt) --ez kell az irányításhoz

	elseif statusz.j=="single" then

	elseif statusz.j=="multi" then

	elseif statusz.j=="create" then

	elseif statusz.j=="join" then

	elseif statusz.j=="beallitasok" then

	elseif statusz.j=="info" then

	elseif statusz.j=="credit" then

	else
		statusz:set("fomenu")
	end
end

function statusz:exit()
	if statusz.j=="fomenu" then
		love.event.quit()

	elseif statusz.j=="menu" then 

	elseif statusz.j=="game" then 
		statusz:set("fomenu")

	elseif statusz.j=="single" then

	elseif statusz.j=="multi" then

	elseif statusz.j=="create" then

	elseif statusz.j=="join" then

	elseif statusz.j=="beallitasok" then
		statusz:set("fomenu")

	elseif statusz.j=="info" then
		statusz:set("fomenu")

	elseif statusz.j=="credit" then
		statusz:set("fomenu")
		
	end
end

function statusz:kijelol(ID)
	if statusz.j=="fomenu" then
		if ID==1 then
			statusz:set("game")
		elseif ID==2 then
			statusz:set("beallitasok")
		elseif ID==3 then
			statusz:set("info")
		elseif ID==4 then
			statusz:set("credit")
		elseif ID==5 then
			love.event.quit()
		end


	elseif statusz.j=="menu" then 

	elseif statusz.j=="game" then 

	elseif statusz.j=="single" then

	elseif statusz.j=="multi" then

	elseif statusz.j=="create" then

	elseif statusz.j=="join" then

	elseif statusz.j=="beallitasok" then
		if ID==1 then
			statusz:set("fomenu")
		end

	elseif statusz.j=="info" then
		if ID==1 then
			statusz:set("fomenu")
		end

	elseif statusz.j=="credit" then
		if ID==1 then
			statusz:set("fomenu")
		end

	end
end


return statusz

--[[
	if statusz.j=="fomenu" then

	elseif statusz.j=="menu" then 

	elseif statusz.j=="game" then 

	elseif statusz.j=="single" then

	elseif statusz.j=="multi" then

	elseif statusz.j=="create" then

	elseif statusz.j=="join" then

	elseif statusz.j=="beallitasok" then

	elseif statusz.j=="info" then

	elseif statusz.j=="credit" then

	end

]]