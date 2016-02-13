kiir = {}
kiir.__index = kiir

function kiir.create(mit,ido)
	local self = {}
	setmetatable(self,kiir)
	self.mit=mit
	self.ido=ido
	return self
end

function kiir:init()
	kiirasok = {}
	spawnkiiras(love.mouse.getX().." "..love.mouse.getY(),90)
	spawnkiiras(Aksz.." "..Akm,90)
end

function kiir:update(i,dt)
	if self.ido>0 then self.ido=self.ido-1*dt
	else 
      	table.remove(kiirasok,i)
    end
end

function kiir:draw(i)
		love.graphics.print(self.mit,10,Am-Am/20-20*i)
		--print(self.mit)
end

function spawnkiiras(mit,ido)
	table.insert(kiirasok,kiir.create(mit,(ido or 3)))
end