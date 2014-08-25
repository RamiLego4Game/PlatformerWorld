--Platformer World By RamiLego4Game--
--Imports--
--require "Engine.Monocle"
_LoveBird = require "Engine.lovebird"
--[[Monocle.new({
  isActive=false,          -- Whether the debugger is initially active
})]]--
Loader = require "Engine.Loader"

require "Engine.loveframes"
require "Engine.Class"
require "Engine.TableSerializer"
  
--Classess Importes--
require "Engine.UI"
require "Engine.HUD"
require "Engine.B2Object"
require "Engine.Player"
require "Engine.LevelLoader"
require "Engine.Camera"
require "Modes.Splash"

_Images,_Sounds,_Fonts,_ImageDatas,_rawJData,_rawINIData,_ImageQualities,_TEXTUREQUALITY = {},{},{},{},{},{},{},"High"

_Keys = {}

function love.load()
  --if arg[#arg] == "-debug" then require("mobdebug").start() end
  --require("mobdebug").off()
  _Width, _Height = love.graphics.getWidth(), love.graphics.getHeight()
  --Monocle.watch("FPS",  function() return math.floor(1/love.timer.getDelta()) end)
  UI = UI:new()
  mode = Splash:new()
end

function love.draw()
  if mode.draw then
    switch = mode:draw()
    if switch then mode = switch end
  end
  loveframes.draw()
  if mode.fade then
    switch = mode:fade()
    if switch then mode = switch end
  end
  --Monocle.draw()
end

function love.update(dt)
  --mouseutil:update()
  --[[for Key,Time in pairs(_Keys) do
    if _Keys[Key] ~= nil then
      _Keys[Key] = _Keys[Key] + round(dt,3)
    end
  end]]--
  
	if mode.update then
    switch = mode:update(dt)
    if switch then mode = switch end
  end
  loveframes.update(dt)
  --Monocle.update()
  _LoveBird.update()
end

function love.mousefocus( focus )
  --mouseutil:mousefocus( focus )
  if mode.mousefocus then
    switch = mode:mousefocus( focus )
    if switch then mode = switch end
  end
end

function love.mousepressed( x, y, button )
  --mouseutil:mousepressed( x, y, button )
  if mode.mousepressed then
    switch = mode:mousepressed( x, y, button )
    if switch then mode = switch end
  end
  
  loveframes.mousepressed(x, y, button)
end

function love.mousereleased( x, y, button )
  --mouseutil:mousereleased( x, y, button )
  if mode.mousereleased then
    switch = mode:mousereleased( x, y, button )
    if switch then mode = switch end
  end
  
  loveframes.mousereleased(x, y, button)
end

function love.keypressed(key, isrepeat)
  if _Keys[key] == nil then _Keys[key] = 0 end
  
  if mode.keypressed then
    switch = mode:keypressed(key, isrepeat)
    if switch then mode = switch end
  end
  
  loveframes.keypressed(key, isrepeat)
  
  --Monocle.keypressed(key, isrepeat)
end
 
function love.keyreleased(key)
  _Keys[key] = nil
  
  if mode.keyreleased then
    switch = mode:keyreleased(key)
    if switch then mode = switch end
  end
  
  loveframes.keyreleased(key)
end

function love.textinput(text)
  if mode.textinput then
    switch = mode:textinput(text)
    if switch then mode = switch end
  end
  
  loveframes.textinput(text)
  
  --Monocle.textinput(text)
end

function round(num, idp)
  if idp and idp>0 then
    local mult = 10^idp
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end