local kamera = require('lib/kamera')
cfg = require('cfg/cfgloader')
local player = require('game/player') --cfg kell neki

DEBUG = true

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
end

function love.update(dt)
    player.update(dt)
end

function love.keypressed(key)
    player.keypressed(key)
end

function love.keyreleased(key)
    player.keyreleased(key)
end

function love.draw()
    kamera:aPos(player.x,player.y)
    kamera:aRot(player.r)
    kamera:aScale(player.s,player.s)
    kamera:set()
        --Background
        --Front
        love.graphics.print("A",0,0)
    kamera:unset()
        --HUD
end