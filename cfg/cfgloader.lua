local cfg = {}

local function load(file)
	if not love.filesystem.exists("cfg/"..file..".cfg") then
		print("Could not load file .. " .. file)
		return
	end
	local cnt="local "..file.."={}\n"
	for line in io.lines("cfg/"..file..".cfg") do 
    	cnt = cnt..file.."."..line.."\n"
  	end
	return cnt.."return "..file
end

cfg.keys = loadstring(load('keys'))()
cfg.cvar = loadstring(load('cvar'))()

return cfg