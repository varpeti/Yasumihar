arena = {}
fa = {}

function arena:init()

 	local coords = {}
 	local a, b = -50, 0
 	local sz = (3.141592653589793238462643383279/180) * (90+45)
 	local p = math.random(3,8)
 	for i=1,p*2,2 do 
		coords[i]=math.cos(sz)*20+a
		coords[i+1]=math.sin(sz)*20+b
		sz=sz+ (3.141592653589793238462643383279*2/p) --+ math.random(-0.5000,0.5000)
	end
	elem:uj(coords,true,190, 110, 010, 122, 13)

	--facreate(-500,-500)
end

function arena:update(dt)

end

function facreate(x,y)
	fraktal(0,0,math.random(0,4)*90*(3.141592653589793238462643383279/180),20*(3.141592653589793238462643383279/180),8,math.random(-100.000,100.000),0)
	local ved
	for j,f in ipairs(fa) do
		local coords = {}
 		local a, b = x+f.x, y+f.y
 		local sz = (3.141592653589793238462643383279/180) * (90+45)
 		local p = math.random(3,8)
 		for i=1,p*2,2 do 
			coords[i]=math.cos(sz)*20+a
			coords[i+1]=math.sin(sz)*20+b
			sz=sz+ (3.141592653589793238462643383279*2/p) + math.random(-0.5000,0.5000)
		end
		if j>1 then
			if     f.l==7 then elem:plus(coords,ved,0,255,0,100,7) 	
			elseif f.l==6 then elem:plus(coords,ved,0,0,255,100,6) 	
			elseif f.l==5 then elem:plus(coords,ved,255,255,0,122,5) 	
			elseif f.l==4 then elem:plus(coords,ved,255,150,000,122,4) 	
			elseif f.l==3 then elem:plus(coords,ved,100,200,200,100,3)
			elseif f.l==2 then elem:plus(coords,ved,000, 200, 000, 122,2) 	
			elseif f.l==1 then elem:plus(coords,ved,255, 255, 255, 100,1)
			end
		else
			elem:uj(coords,true,255,0,0,100,8)
			ved=kornyezet[#kornyezet]
		end
	end
	while 1<=#fa do
		table.remove(fa,1)
	end
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


