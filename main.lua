cfg          = require('cfg/cfgloader')
hud          = require('lib/hud') kiir = hud.new_szoveg_doboz(10,10) table.insert(hud.wids,kiir)
local kamera = require('lib/kamera')

local player = require('game/player') 
local server = require('game/server')
local client = require('game/client')

function love.load()
    love.window.setMode(cfg.cvar.XX,cfg.cvar.YY,{
        fullscreen=cfg.cvar.fullscreen,
        fullscreentype=cfg.cvar.fullscreentype,
        vsync=cfg.cvar.vsync,
        msaa=cfg.cvar.msaa,
        resizable=cfg.cvar.resizable,
        borderless=cfg.cvar.borderless,
        centered=cfg.cvar.centered,
        display=cfg.cvar.display,
        minwidth=cfg.cvar.minwidth,
        minheight=cfg.cvar.minheight,
        highdpi=cfg.cvar.highdpi
    })
    love.window.setTitle("Yasumihar - Váraljai Péter")
    kiir.add("main",3)
end

function love.update(dt)
    player.update(dt)
    if cfg.cvar.server then server.update(dt) end
    if cfg.cvar.client then client.update(dt) end
end

function love.keypressed(key)
    player.keypressed(key)
end

function love.keyreleased(key)
    player.keyreleased(key)
end

function love.mousepressed(x, y, button, istouch)
    player.mousepressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
    player.mousereleased(x, y, button, istouch)
end

function love.wheelmoved(x, y)
    player.wheelmoved(y)
end

function love.draw()
    kamera:aPos(player.x,player.y)
    kamera:aRot(player.r)
    kamera:aScale(player.s,player.s)
    kamera:set()
        -- World
        if cfg.cvar.client then client.draw() end
    kamera:unset()
        -- HUD
        if cfg.cvar.client then client.HUD()  end
end