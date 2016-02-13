function player_init()
	local p, sz = 4, 0
	local a, b = 100, 100
	local coords = {}
	for i=1,p*2,2 do 
		coords[i]=math.cos(sz)*20+a
		coords[i+1]=math.sin(sz)*20+b
		sz=sz+ (3.141592653589793238462643383279*2/p) --+ math.random(-0.5000,0.5000)
	end
	rr,gg,bb,aa =  000, 255, 255, 122 --math.random(0,255),math.random(0,255),math.random(0,255),math.random(0,255)
	elem:uj(coords,true,rr,gg,bb,aa,0)
	player=#kornyezet

	--facreate(0,0)
	player=1

	speed = 1000
	px = 0
	py = 0
	pr = 0

	kornyezet[player].body:applyAngularImpulse(5e4)
end

function player_update(dt)

	speed = 1000

	if love.keyboard.isDown("d") or (love.mouse.getX()>=Asz*0.95 and not isandroid) then
		--kornyezet[player].body:applyLinearImpulse(dt*speed,0,px,py)
		px=px+dt*speed
	end
	if love.keyboard.isDown("a") or (love.mouse.getX()<=Asz*0.05 and not isandroid) then
		--kornyezet[player].body:applyLinearImpulse(-1*dt*speed,0,px,py)
		px=px-dt*speed
	end
	if love.keyboard.isDown("s") or (love.mouse.getY()>=Am*0.95 and not isandroid) then
	   	--kornyezet[player].body:applyLinearImpulse(0,dt*speed,px,py)
	   	py=py+dt*speed
	end
	if love.keyboard.isDown("w") or (love.mouse.getY()<=Am*0.05 and not isandroid) then
	   	--kornyezet[player].body:applyLinearImpulse(0,-1*dt*speed,px,py)
	   	py=py-dt*speed
	end
	if love.keyboard.isDown("r")  then
    	pr=pr-0.01
  	end
	if kameralock then
		px = kornyezet[player].body:getX()
    	py = kornyezet[player].body:getY()
    	pr = kornyezet[player].body:getAngle()
    end
end
