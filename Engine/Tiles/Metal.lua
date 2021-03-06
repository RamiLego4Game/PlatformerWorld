--Author : Ramilego4Game - This File Is Part Of Platformer World--
--Type : Class/Tile--
--local Tile = TileBase:new("Grass","grass",thumbnail)
Tile = class:new()

function Tile:init()
	self.name = "Metal"
  self.category = "Ground"
	self.thumbnail = nil
	self.hover = "metal"
	self.snap = 70
end

function Tile:create(marker,map)
  self.object = B2Object:newTile(marker.x,marker.y,70,70)
end

function Tile:destroy()
  if self.object then
    self.object.body:destroy()
    self.object = nil
  end
end

function Tile:buildbatch(marker,map,spritebatch,spritemap,mapsize)
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
  local frame = spritemap[self.Image..self.State..".png"]
  local Quad = love.graphics.newQuad(frame.x,frame.y,frame.w,frame.h,mapsize.width,mapsize.height)
  spritebatch:add(Quad,X,Y)
  --UI:Draw("sign"..self.State..self.hover,X,Y,70,70)
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