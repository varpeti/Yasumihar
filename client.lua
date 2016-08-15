require "enet"

local client = {}

local function explode(d,p)
  local t, ll
  t={}
  ll=0
  if(#p == 1) then return {p} end
    while true do
      l=string.find(p,d,ll,true) -- find the next d in the string
      if l~=nil then -- if "not not" found then..
        table.insert(t, string.sub(p,ll,l-1)) -- Save it in our array.
        ll=l+1 -- save just after where we found it for searching next time.
      else
        table.insert(t, string.sub(p,ll)) -- Save what's left in our array.
        break -- Break at end, as it should be, according to the lua manual.
      end
    end
  return t
end


function client:init()
	--Cliens beállításai
	client.host = enet.host_create()
	local file = io.open("port","r")
	client.server = client.host:connect("localhost:"..file:read("*all"))
	file:close()

	--ablak beállítások
	kepernyo:setmode(1280,720,0,true,2,1)
	love.window.setTitle("Yasumihar - Váraljai Péter")
	love.window.setIcon(love.image.newImageData("Data/icon.png"))
	
	--Sima változók
	kameralock = false
	DEBUG = false
	fullsreen = false
	client.nextdraw = {}

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
			local t = explode("?",event.data)
			if t[1]=="ciet3h4jo" then player.id=tonumber(t[2])
			elseif t[1]=="fruej3f4t" then
				table.insert(client.nextdraw,loadstring(t[2])())
			elseif t[1]=="ciet3h4jo" then
			elseif t[1]=="ciet3h4jo" then
			elseif t[1]=="ciet3h4jo" then
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

	kamera:aPos(player.x,player.y) --kamera beállítása: player közepe - képernyő méret fele * nagyitás
	kamera:set()
		
		if client.nextdraw[1] then
			for b,FF in ipairs(client.nextdraw[1]) do
				for f,t in ipairs(FF) do
					love.graphics.setColor(t[1],t[2],t[3],t[4])
					love.graphics.polygon("fill",t[5])
					love.graphics.setColor(t[6],t[7],t[8],t[9])
					love.graphics.polygon("line",t[5])
					local debug = t[10]
					if DEBUG and debug then
						love.graphics.setColor(255,255,255,255)
						love.graphics.print(debug[1],debug[2],debug[3]) 
						love.graphics.line(debug[4],debug[5],debug[2],debug[3])
						--print(debug[1],debug[2],debug[3],debug[4],debug[5])
					end
				end
			end
			if #client.nextdraw>1 then table.remove(client.nextdraw,1) end
		end
	
		local mx,my = kamera:worldCoords(love.mouse:getX()-(kepernyo.Asz/2),love.mouse:getY()-(kepernyo.Am/2))
		love.graphics.rectangle("fill",mx-10,my-10,20,20)
	
	kamera:unset()
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.setFont(fkicsi);

	if DEBUG then
		love.graphics.print(player.x.."       "..player.y.."\n"..mx.."      "..my.."\n"..player.kijelol.." kijelolve",10,10)
		local text = ""
		for k,v in pairs(_G) do
			if type(v)~="function" then text = text..k..": "..type(v).."\n" end
		end
		love.graphics.print(text,500,10)
	end

	love.graphics.setFont(fkiiras);
	kiir:draw(10,kepernyo.Am-25,true,DEBUG) --kiirasok

	love.graphics.print(#client.nextdraw,100,100)

end

return client
