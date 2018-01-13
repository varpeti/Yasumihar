local hud = {}
hud.wids = {}
hud.font = love.graphics.newFont(12) love.graphics.setFont(hud.font)

function hud.draw()
	love.graphics.setColor(255,255,255,255)
	for id,wid in ipairs(hud.wids) do
		wid.draw(0,0)
	end
end

function hud.update(dt)
	for id,wid in ipairs(hud.wids) do
		wid.update(dt)
	end
end

-- Láthatatlan ablak osztály
function hud.new(x,y) 
	local wid = {}
	wid.x=x
	wid.y=y
	wid.wids={}
	wid.draw=function(px,py) for id,cid in ipairs(wid.wids) do cid.draw(px+x,py+y) end end -- Meghívja a gyerekei fügvényeit is.
	wid.update=function(dt) for id,cid in ipairs(wid.wids) do cid.update(dt) end end
	return wid
end

-- Szöveg osztály
function hud.new_szoveg(x,y,szoveg,szin)
	local wid = hud.new(x,y) -- öröklés
	wid.szin = szin or {255,255,255} -- fehér alapértelmezetten
	wid.szoveg = szoveg
	wid.wids = nil -- nem lehet bele rakni elemet.
	wid.draw = function(px,py) love.graphics.print({szin,szoveg},px+x,py+y) end
	wid.update=function(dt) end 
	return wid
end

-- Eltünő szöveg osztály (a szülőnek kell eltüntetni)
function hud.new_eltuno_szoveg(x,y,szoveg,ido,szin)
	local wid = hud.new_szoveg(x,y,szoveg,szin) -- öröklés
	wid.ido = ido or 10 -- 10s az alapértelmezett
	wid.draw = function(px,py) love.graphics.print({wid.szin,wid.szoveg},px+x,py+y) end
	wid.update=function(dt) wid.ido=wid.ido-dt end
	return wid
end

-- Szöveg doboz osztály
function hud.new_szoveg_doboz(x,y)
	local wid = hud.new(x,y) -- öröklés
	wid.draw = function(px,py) love.graphics.print({szin,szoveg},px+x,py+y) end
	wid.add = function(szoveg,ido,szin) table.insert(wid.wids,hud.new_eltuno_szoveg(0,0,szoveg,ido,szin)) if cfg.cvar.debug1 then print(szoveg) end end
	wid.update=function(dt) 
			for id,cid in ipairs(wid.wids) do 
				cid.update(dt) 
				if cid.ido<0 then cid=nil table.remove(wid.wids,id) end 
			end
		end
	wid.draw=function(px,py) 
			for id,cid in ipairs(wid.wids) do 
				cid.draw(x+px,y+py+(id-1)*(hud.font:getHeight()+2))
			end
		end
	return wid
end

return hud