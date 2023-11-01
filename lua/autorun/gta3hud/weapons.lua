
if SERVER then return end

GTA3HUD.weapons = {} -- namespace

local WEAPONS = { database = { textures = {}, classes = {}, worldmodels = {} } }

--[[------------------------------------------------------------------
  Creates a new weapon icons table and returns it.
  @return {table} weapon icons table
]]--------------------------------------------------------------------
function GTA3HUD.weapons.Create()
  return table.Copy(WEAPONS)
end

--[[------------------------------------------------------------------
  Adds an icon texture to use.
  @param {string} name
  @param {Material} texture
  @return {string} name provided
  @return {Material} texture provided
]]--------------------------------------------------------------------
function WEAPONS:Register(name, texture)
  self.database.textures[name] = texture
  return name, texture
end

--[[------------------------------------------------------------------
  Assigns an icon to a weapon class.
  @param {string} weapon class
  @param {string} registered icon name
]]--------------------------------------------------------------------
function WEAPONS:AddClass(class, icon)
  self.database.classes[class] = icon
end

--[[------------------------------------------------------------------
  Assigns an icon to a world model.
  @param {string} world model
  @param {string} registered icon name
]]--------------------------------------------------------------------
function WEAPONS:AddWorldModel(worldmodel, icon)
  self.database.worldmodels[worldmodel] = icon
end

--[[------------------------------------------------------------------
  Returns the texture of the given registered icon.
  @param {string} registered icon name
  @return {Material} registered icon texture
]]--------------------------------------------------------------------
function WEAPONS:Get(name)
  return self.database.textures[name]
end

--[[------------------------------------------------------------------
  Returns the icon assigned to the given weapon class.
  @param {string} weapon class
  @return {string} registered icon name
]]--------------------------------------------------------------------
function WEAPONS:FromClass(class)
  return self.database.classes[class]
end

--[[------------------------------------------------------------------
  Returns the icon assigned to the given world model.
  @param {string} world model
  @return {string} registered icon name
]]--------------------------------------------------------------------
function WEAPONS:FromWorldModel(worldmodel)
  return self.database.worldmodels[worldmodel]
end

--[[------------------------------------------------------------------
  Returns the most adequate registered icon texture for this weapon.
  @param {Weapon} weapon
  @return {Material} registered icon texture
]]--------------------------------------------------------------------
function WEAPONS:FindWeaponIcon(weapon)
  if not IsValid(weapon) then return self:FromClass(NULL) end
  return self:FromClass(weapon:GetClass()) or self:FromWorldModel(string.lower(weapon:GetModel()))
end

--[[------------------------------------------------------------------
  Draws an icon for the given weapon.
  @param {Weapon} weapon
  @param {number} x
  @param {number} y
  @param {number} width
  @param {number} height
  @param {Color} colour
]]--------------------------------------------------------------------
function WEAPONS:DrawWeaponIcon(weapon, x, y, w, h, colour)
  local icon = self:FindWeaponIcon(weapon)
  if icon then
    surface.SetMaterial(self:Get(icon))
    surface.SetDrawColor(colour)
    surface.DrawTexturedRect(x, y, w, h)
  else
    GTA3HUD.draw.WeaponIcon(weapon, x + w * .5, y + h * .5, w)
  end
end
