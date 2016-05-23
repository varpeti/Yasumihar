local kiir = {}
kiir.kiik = {}
kiir.alap = {}
kiir.aktiv = 0

-- létrehozás, törlés | new, del

function kiir:new(szoveg,ido) -- string, time
	if not szoveg then return nil end
	ido = ido or kiir.alap.ido
	table.insert(kiir.kiik,{szoveg=szoveg,ido=ido})
	return #kiir
end

function kiir:del()
	kiir.kiik={}
end


-- frissítés, kiírás | update, draw

function kiir:update(dt)
	kiir.aktiv=0
	for id,kii in ipairs(kiir.kiik) do
		if kii.ido>0 then 
			kii.ido = kii.ido-dt
			kiir.aktiv=kiir.aktiv+1
		end
		if kii.ido<0 then 
			kii.ido = 0 
			kiir.aktiv=kiir.aktiv-1
		end
	end
end

function kiir:draw(x,y,felvagyle,osszes,helyköz) -- x,y,upordown,all,linespace
	x = x or kiir.alap.x
	y = y or kiir.alap.y
	helyköz = helyköz or love.graphics.getFont():getHeight()

	local pos
	if osszes then 
		pos = #kiir.kiik
	else
		pos = kiir.aktiv
	end

	for id,kii in ipairs(kiir.kiik) do
		if osszes or kii.ido>0 then
			if felvagyle 
			then
				love.graphics.print(kii.szoveg,x,y-(pos*helyköz))
			else
				love.graphics.print(kii.szoveg,x,y+(pos*helyköz))
			end
			pos=pos-1
		end
	end
end

-- beállítás | setting

function kiir:set(x,y,ido,felvagyle,osszes,helyköz)
	kiir.alap.x = x or 0
	kiir.alap.y = y or 0
	kiir.alap.ido = ido or 5 -- time (sec)
	kiir.alap.felvagyle = felvagyle or false -- up or down (false=down)
	kiir.alap.osszes = osszes or false -- all (false= only the actives)
	kiir.alap.helyköz = helyköz or nil -- line space (pixel) (nil = get currently size)
end

kiir:set() -- alap beállítások

return kiir