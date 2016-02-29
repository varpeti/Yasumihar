fa = {}

function facreate(x,y)
	fraktal(0,0,-90*(3.141592653589793238462643383279/180),20*(3.141592653589793238462643383279/180),8,math.random(-100.000,100.000),0)
	local ID
	for j,f in ipairs(fa) do
		local coords = {}
 		local a, b = f.x, f.y
 		local sz = (3.141592653589793238462643383279/180) * (90+45)
 		local p = math.random(3,8)
 		for i=1,p*2,2 do 
			coords[i]=math.cos(sz)*20+a
			coords[i+1]=math.sin(sz)*20+b
			sz=sz+ (3.141592653589793238462643383279*2/p) + math.random(-0.5000,0.5000)
		end
		if j>1 then
			if     f.l==7 then env:addObj(ID,coords,{rr=000,gg=255,bb=000},{rr=255,gg=255,bb=255})--{rr=255,gg=000,bb=255}) 	
			elseif f.l==6 then env:addObj(ID,coords,{rr=000,gg=000,bb=255},{rr=255,gg=255,bb=255})--{rr=255,gg=255,bb=000}) 	
			elseif f.l==5 then env:addObj(ID,coords,{rr=255,gg=255,bb=000},{rr=255,gg=255,bb=255})--{rr=000,gg=000,bb=255}) 	
			elseif f.l==4 then env:addObj(ID,coords,{rr=255,gg=150,bb=000},{rr=255,gg=255,bb=255})--{rr=000,gg=105,bb=255}) 	
			elseif f.l==3 then env:addObj(ID,coords,{rr=100,gg=200,bb=200},{rr=255,gg=255,bb=255})--{rr=155,gg=055,bb=055})
			elseif f.l==2 then env:addObj(ID,coords,{rr=000,gg=200,bb=000},{rr=255,gg=255,bb=255})--{rr=255,gg=055,bb=255}) 	
			elseif f.l==1 then env:addObj(ID,coords,{rr=000,gg=000,bb=000},{rr=255,gg=255,bb=255})--{rr=255,gg=255,bb=255})
			end
		else
			ID = env:ujObj(coords,{rr=255,gg=0,bb=0},{rr=255,gg=255,bb=255},true)--{rr=0,gg=0,bb=255})
		end
	end
	while 1<=#fa do
		table.remove(fa,1)
	end
	env:getObj(ID):getBody():setPosition(x,y)
	return ID
end

function fraktal(x,y,d1,d2,l,t)
	local f = {}
	f.x = x*75
	f.y = y*75
	f.l = l
	if l>0 then
 		local x2 = x + (math.cos(d1) * math.sqrt(l) * 1.00001);
 		local y2 = y + (math.sin(d1) * math.sqrt(l) * 1.00001);
 		fa[#fa+1]=f
 		d2 = math.sin(d2*10)*math.cos(d2*5)*t+math.sin(10*d2+10)*math.cos(20*d2+20)
 		fraktal(x2, y2, d1 - d2, d2, l-1,t);
 		fraktal(x2, y2, d1 + d2, d2, l-1,t);
	end
end


