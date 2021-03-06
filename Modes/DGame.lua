--Author : Ramilego4Game - This File Is Part Of Platformer World--
--Type : Class/Screen--
DGame = class:new()

function DGame:init(Map)
  _Camera = camera:new()
  _HUD = HUD:new()
  
  self.fadeScreen, self.alpha, self.speed = true, 255, 25
  
  love.physics.setMeter(64)
  _World =  love.physics.newWorld(0, 9.81*64, true)
  
  B2Object = B2Object:new(_World)
  
  self:buildWorld()
  
  self.Players = {}
  if Map then
    self.DevMap = Map
  else
    self.DevMap = {}
    
    for x=0,12 do
      self.DevMap[x*70-70] = {}
      self.DevMap[x*70-70][530] = {}
      self.DevMap[x*70-70][530]["Grass"] = {}
    end
  end
  
  self.LevelLoader = LevelLoader:new(_World)
  self.LevelLoader:loadMap(self.DevMap)
  self.LevelLoader:buildMapBatch()
  
  if love.system.getOS() == "Android" or _AndroidDebug then
    self.focusPlayer = 2
    if not self.Players[2] then self.Players[2] = Player:new(500,0,2,4) end
    _HUD:setPlayer(self.focusPlayer)
    _Joy = Joystick:new(25,_Height-86,1)
    _JoyUp = Joystick:new(_Width-85,_Height-85,2)
    _JoyDown = Joystick:new(_Width-155,_Height-85,3)
  end
end

function DGame:update(dt)
  _World:update(dt)
  
  for Num=1,#self.Players do
    if self.Players[Num] ~= nil then self.Players[Num]:update(dt) end
  end
  
  if _Keys["f5"] then
    self.focusPlayer = 1
    if not self.Players[1] then self.Players[1] = Player:new(_Width/2,0,1,2) end
    _HUD:setPlayer(self.focusPlayer)
  end
  
  if _Keys["f6"] then
    self.focusPlayer = 2
    if not self.Players[2] then self.Players[2] = Player:new(_Width/2,0,2,1) end
    _HUD:setPlayer(self.focusPlayer)
  end
  
  if _Keys["f7"] then
    self.focusPlayer = 3
    if not self.Players[3] then self.Players[3] = Player:new(_Width/2,0,3) end
    _HUD:setPlayer(self.focusPlayer)
  end
  
  if self.focusPlayer and self.Players[self.focusPlayer] ~= nil then _Camera:lookAt(self.Players[self.focusPlayer].X,self.Players[self.focusPlayer].Y) end
  
  self.LevelLoader:updateMap(self.Players,dt)
end

function DGame:draw()
  love.graphics.setColor(255,255,255,255)
  UI:DrawBackground("Background")
  _Camera:attach()
  
  self.LevelLoader:drawMap()
  
  for Num=1,#self.Players do
    if self.Players[Num] ~= nil then self.Players[Num]:draw() end
  end
  
  if self.debugWorld then self:debugWorldDraw(_World) end
  _Camera:detach()
  _HUD:draw()
end

function DGame:fade()
  if self.fadeScreen then
    love.graphics.setColor(0,0,0,self.alpha)
    love.graphics.rectangle("fill",0,0,_Width,_Height)
    self.alpha = self.alpha - self.speed
    if self.alpha <= 0 then
      self.fadeScreen = false
      self.alpha = 255
    end
    love.graphics.setColor(255,255,255,255)
  end
  if _Joy then _Joy:draw() end
  if _JoyUp then _JoyUp:draw() end
  if _JoyDown then _JoyDown:draw() end
end

function DGame:touch(touch)
  _Joy:touch(touch)
  _JoyUp:touch(touch)
  _JoyDown:touch(touch)
end

function DGame:buildWorld()
  local Width = _Width-0
  local Height = _Height-0
end

function DGame:keypressed(key, isrepeat)
  if key == "f1" then self.debugWorld = not self.debugWorld end
  if key == "escape" then
    _Camera = nil
    _Joy = nil
    self.LevelLoader:destroyMap()
    return LevelEditor:new(self.DevMap)
  end
end

function DGame:debugWorldDraw(world)
   local bodies = world:getBodyList()
   
   for b=#bodies,1,-1 do
      local body = bodies[b]
      local bx,by = body:getPosition()
      local bodyAngle = body:getAngle()
      love.graphics.push()
      love.graphics.translate(bx,by)
      love.graphics.rotate(bodyAngle)
      
      math.randomseed(1) --for color generation
      
      local fixtures = body:getFixtureList()
      for i=1,#fixtures do
         local fixture = fixtures[i]
         local shape = fixture:getShape()
         local shapeType = shape:getType()
         local isSensor = fixture:isSensor()
         
         if (isSensor) then
            love.graphics.setColor(0,0,255,96)
         else
            love.graphics.setColor(math.random(32,200),math.random(32,200),math.random(32,200),96)
         end
         
         love.graphics.setLineWidth(1)
         if (shapeType == "circle") then
            local x,y = fixture:getMassData()
            local radius = shape:getRadius()
            love.graphics.circle("fill",x,y,radius,15)
            love.graphics.setColor(0,0,0,255)
            love.graphics.circle("line",x,y,radius,15)
            local eyeRadius = radius/4
            love.graphics.setColor(0,0,0,255)
            love.graphics.circle("fill",x+radius-eyeRadius,y,eyeRadius,10)
         elseif (shapeType == "polygon") then
            local points = {shape:getPoints()}
            love.graphics.polygon("fill",points)
            love.graphics.setColor(0,0,0,255)
            love.graphics.polygon("line",points)
         elseif (shapeType == "edge") then
            love.graphics.setColor(0,0,0,255)
            love.graphics.line(shape:getPoints())
         elseif (shapeType == "chain") then
            love.graphics.setColor(0,0,0,255)
            love.graphics.line(shape:getPoints())
         end
      end
      love.graphics.pop()
   end
   
   local joints = world:getJointList()
   for index,joint in pairs(joints) do
      love.graphics.setColor(0,255,0,255)
      local x1,y1,x2,y2 = joint:getAnchors()
      if (x1 and x2) then
         love.graphics.setLineWidth(3)
         love.graphics.line(x1,y1,x2,y2)
      else
         love.graphics.setPointSize(3)
         if (x1) then
            love.graphics.point(x1,y1)
         end
         if (x2) then
            love.graphics.point(x2,y2)
         end
      end
   end
   
   local contacts = world:getContactList()
   for i=1,#contacts do
      love.graphics.setColor(255,0,0,255)
      love.graphics.setPointSize(3)
      local x1,y1,x2,y2 = contacts[i]:getPositions()
      if (x1) then
         love.graphics.point(x1,y1)
      end
      if (x2) then
         love.graphics.point(x2,y2)
      end
   end
   love.graphics.setColor(255,255,255,255)
end