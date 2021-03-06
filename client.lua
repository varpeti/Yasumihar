require "enet"
kamera = require('kamera')
kiir = require('kiir')
kepernyo = require('kepernyo')
player = require('player') -- sűrgősen javítani kell, az egész input rendszert!!!!

local client = {}
client.objs = {}

local function szetvalaszt(mit,mibe)
	local hol = mibe:find(mit)
	return {mibe:sub(0,hol-1),mibe:sub(hol+1)}
end

local function getElmozdulas(regipontok,ujpontok) -- elmozdulást számolja
	local elmozd = {}
	for i,rp in ipairs(regipontok) do
		table.insert(elmozd,ujpontok[i]-rp)
	end
	return elmozd
end

local function setElmozdulas(pontok,elmozd) -- elmozdulást számolja
	if elmozd==nil then return pontok end
	local ujpontok = {}
	for i,p in ipairs(pontok) do
		table.insert(ujpontok,p+elmozd[i]/2)
	end
	return ujpontok
end


function client:init()
	--Cliens beállításai
	client.host = enet.host_create()
	local file = "port"
	if not love.filesystem.exists(file) then error([[Hiányzik a "]]..file..[[" file]]) end
	client.server = client.host:connect("localhost:"..love.filesystem.read(file))

	--ablak beállítások
	kepernyo:setmode(1280,720,0,true,2,1)
	love.window.setTitle("Yasumihar - Váraljai Péter")
	love.window.setIcon(love.image.newImageData("Data/icon.png"))
	
	--Sima változók
	kameralock = false
	DEBUG = false
	fullsreen = false

	--kiírási beállítások
	fmenu = love.graphics.newFont(48)
	fkiiras = love.graphics.newFont(16)
	fkicsi = love.graphics.newFont(10)
	kiir:set(nil,nil,10,true,DEBUG,12)

	--egér középre
	love.mouse.setPosition(kepernyo.Asz/2,kepernyo.Am/2)

	--Random seed
	math.randomseed(os.time())

	--infók
	kiir:new("",46)
	kiir:new("Gombok:",30)
	kiir:new("WASD, egér - kamera mozgás",31)
	kiir:new("SPACE - kameralock",32)
	kiir:new("F8 - Debug",33)
	kiir:new("Görgö - Zoom",34)
	kiir:new("B - kiirteszt",35)
	kiir:new("R - kameraforgatás",36)
	kiir:new("F11 - teljesképernyö",37)
	kiir:new("Kattintás - objektum ID",38)
	kiir:new("",39)
	kiir:new("Android:",40)
	kiir:new("Húzás - kameramozgatás",41)
	kiir:new("2 új - zoom",42)
	kiir:new("3 új - kameralock",43)
	kiir:new("ESC - vissza, kilépés",44)
	kiir:new("",45)
	kiir:new([[Balra fel van a "hajó"]],20)

end
	
function client:update(dt)
	local event = client.host:service(0)
	if event then
		if event.type == "receive" then
			--kiir:new("Got message: "..event.data.." "..event.peer:connect_id())
			local t = szetvalaszt("?",event.data)
			if t[1]=="ciet3h4jo" then player.id=tonumber(t[2])
			elseif t[1]=="fruej3f4t" then -- szervertől kapott új blokkok | ha nem kapja meg bugolni fog :/

				local objs = loadstring(t[2])() --objs = objektumok
				for o,obj in ipairs(objs) do
					client.objs[obj[2].ID] = {points=obj[1],DATA=obj[2],teamcolor=obj[3],time=255,elmozdulas=nil} -- obj[1]=pontok | obj[2]=DATA | obj[3]=csapat szin
					--print(obj[2].ID)
				end

			elseif t[1]=="akh8734tg" then -- a szervertől kapott elmozdulások.

				local objs = loadstring(t[2])()
				for o,obj in ipairs(objs) do
					--local points,ID,time = obj[1], obj[2], obj[3]
					client.objs[obj[2]].elmozdulas = getElmozdulas(client.objs[obj[2]].points,obj[1])
					--eseményen kívül számolunk client.objs[obj[2]].points = obj[1] -- pozíciót adja át
					client.objs[obj[2]].time = obj[3] -- a látszódási időt / átlátszóságot adja át
					if obj[3]==0 then client.objs[obj[2]]=nil end -- lejárt idejűek törlése
				end

			--elseif t[1]=="ciet3h4jo" then
			--elseif t[1]=="ciet3h4jo" then
			end
		elseif event.type == "connect" then
			kiir:new("Connected")
		elseif event.type == "disconnect" then
			kiir:new(event.peer:connect_id() .. " disconnected.")
		end
		event.peer:send("zt4e2r3st?")
	end

	player:update(dt) --ez kell az irányításhoz

	kiir:update(dt) -- kiírások
end

function client:draw()
	kamera:aPos(player.x,player.y) --kamera beállítása
	kamera:set()

	--env:draw()
		
		for o,obj in pairs(client.objs) do
			obj.points = setElmozdulas(obj.points,obj.elmozdulas)
			love.graphics.setColor(obj.DATA.szin.rr,obj.DATA.szin.gg,obj.DATA.szin.bb,math.floor(obj.time/2))
			love.graphics.polygon("fill",obj.points)
			love.graphics.setColor(obj.teamcolor.rr,obj.teamcolor.gg,obj.teamcolor.bb,obj.time)
			love.graphics.polygon("line",obj.points)
		end
	
		local mx,my = kamera:worldCoords(love.mouse:getX()-(kepernyo.Asz/2),love.mouse:getY()-(kepernyo.Am/2))
		love.graphics.rectangle("fill",mx-10,my-10,20,20)
	
	kamera:unset()
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.setFont(fkicsi)

	if DEBUG then
		love.graphics.print(player.x.."       "..player.y.."\n"..mx.."      "..my.."\n"..player.kijelol.." kijelolve",10,10)
		local text = "" --Kiírja a globális változókat és típúsaikat (az alapértelmezetekket leszámítva)
		local ignore = {"coroutine","io","arg","love","jit","bit","package","debug","table","_VERSION","math","text","os","_G","string"}
		for k,v in pairs(_G) do
			if type(v)~="function" then 
				local b = true
				for a,s in ipairs(ignore) do
					if s==k then b = false end 
				end
				if b then text = text..k..": "..type(v).."\n" end
			end
		end
		love.graphics.print(text,500,10)
	end

	love.graphics.setFont(fkiiras);
	kiir:draw(10,kepernyo.Am-25,true,DEBUG) --kiirasok

end

return client
