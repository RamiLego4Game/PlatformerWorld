--Author : Ramilego4Game - This File Is Part Of Platformer World--
--Type : Class/Tile--
Tile = class:new()

function Tile:init()
	self.name = "Snow"
  self.category = "Ground"
	self.thumbnail = nil
	self.hover = "snow"
	self.snap = 70
end

function Tile:create(marker,map)
  self.object = B2Object:newTile(marker.x,marker.y,70,70)
end

function Tile:destroy()
  self.object.body:destroy()
  self.object = nil
end

function Tile:draw(marker,map)
  if self.thumbnail then self.Image = self.thumbnail else self.Image = self.hover end
  self.State = ""
  local X,Y
  if self.object then X,Y = self.object.body:getPosition() else X,Y = marker.x,marker.y end
  
  if map[marker.x-self.snap] ~= nil and map[marker.x-self.snap][marker.y] ~= nil then
    self.State = "Right"
  end
  
  if map[marker.x+self.snap] ~= nil and map[marker.x+self.snap][marker.y] ~= nil then
    if self.State == "Right" then
      self.State = "Mid"
    else
      self.State = "Left"
    end
  end
  
  if map[marker.x] ~= nil and map[marker.x][marker.y-self.snap] ~= nil then
    self.State = "Center"
  elseif map[marker.x] ~= nil and map[marker.x][marker.y+self.snap] ~= nil then
    self.State = "Mid"
  end
  
  love.graphics.setColor(marker.color or {255,255,255,255})
  UI:Draw(self.Image..self.State,X,Y,70,70)
end