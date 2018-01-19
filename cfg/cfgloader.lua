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

function ppcall(fv,error)
    local out
    if not pcall(function() gout = loadstring(load(fv))() end) then error(error) end
    out = gout
    gout=nil
    return out
end

cfg.keys = ppcall('keys',"Failed to load the keys cfg file.")
cfg.cvar = ppcall('cvar',"Failed to load the cvar cfg file.")

return cfg