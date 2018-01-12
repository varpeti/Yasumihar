local cfg = {}

local function load(file)
    if not love.filesystem.exists("cfg/"..file..".cfg") then
        error("The " .. file .. " file not exists.")
        return
    end
    local cnt="local "..file.."={}\n"
    for line in io.lines("cfg/"..file..".cfg") do
        if line:sub(1,1)~="-" and line:sub(1,1)~=" " and line:sub(1,1)~="\t" and line:sub(1,1)~=[[
]]      then
            cnt = cnt..file.."."..line.."\n"
        end
    end
    return cnt.."return "..file
end

local function call()
    cfg.keys = loadstring(load('keys'))()
    cfg.cvar = loadstring(load('cvar'))()
end

if not pcall(call) then error("Attempt to load a bad cfg file.") end

return cfg