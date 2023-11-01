--[[------------------------------------------------------------------
  HUD variant API

  Yes, we're creating 5 entirely different HUDs.
  Yes, at this point I've pretty much lost it.
]]--------------------------------------------------------------------

if SERVER then return end

GTA3HUD.hud = {} -- namespace

local variants = {} -- registered HUD variants

local HUD = { properties = {} }
local CATEGORY = { _category = true, properties = {} }

--[[------------------------------------------------------------------
  Adds a parameter to the given destination table.
  @param {table} destination table
  @param {string} internal name
  @param {string} name
  @param {any} default value
  @return {table} generated parameter
]]--------------------------------------------------------------------
local function parameter(destination, id, name, default)
  local parameter = { name = name, default = default }
  destination.properties[id] = parameter
  parameter.i = table.Count(destination.properties)
  return parameter
end

--[[------------------------------------------------------------------
  Adds an option parameter to the given destination table.
  @param {table} destination table
  @param {string} internal name
  @param {string} name
  @param {table} options
  @param {number} default option
  @return {table} generated parameter
]]--------------------------------------------------------------------
local function option(destination, id, name, options, default)
  local parameter = parameter(destination, id, name, default)
  parameter.options = options
  return parameter
end

--[[------------------------------------------------------------------
  Adds a ranged numeric parameter to the given destination table.
  @param {table} destination table
  @param {string} internal name
  @param {string} name
  @param {number} default value
  @param {number} minimum value
  @param {number} maximum value
  @param {boolean} should decimals be shown
  @return {table} generated parameter
]]--------------------------------------------------------------------
local function range(destination, id, name, default, min, max, decimals)
  local parameter = parameter(destination, id, name, default)
  parameter.min = min or -9999
  parameter.max = max or 9999
  parameter.decimals = decimals
  return parameter
end

--[[------------------------------------------------------------------
  Adds a parameter to the category.
  @param {string} internal name
  @param {string} name
  @param {any} default value
  @return {table} generated property
]]--------------------------------------------------------------------
function CATEGORY:Parameter(id, name, default)
  return parameter(self, id, name, default)
end

--[[------------------------------------------------------------------
  Adds an option parameter to the category.
  @param {string} internal name
  @param {string} name
  @param {table} options
  @param {number} default option
  @return {table} generated property
]]--------------------------------------------------------------------
function CATEGORY:Option(id, name, options, default)
  return option(self, id, name, options, default)
end

--[[------------------------------------------------------------------
  Adds a ranged numeric parameter to the category.
  @param {string} internal name
  @param {string} name
  @param {number} default value
  @param {number} minimum value
  @param {number} maximum value
  @param {boolean} should decimals be shown
  @return {table} generated property
]]--------------------------------------------------------------------
function CATEGORY:Range(id, name, default, min, max, decimals)
  return range(self, id, name, default, min, max, decimals)
end

--[[------------------------------------------------------------------
  (Optional implementation)
  Displays a preview of what the category affects.
  @param {number} frame width
  @param {number} frame height
  @param {table} settings
]]--------------------------------------------------------------------
-- function CATEGORY:Preview(w, h, settings) end

--[[------------------------------------------------------------------
  Creates a properties category.
  @param {string} internal name
  @param {string} name
  @param {string|nil} derma panel class used in menu
  @return {table} created category
]]--------------------------------------------------------------------
function HUD:Category(id, name, derma)
  local category = table.Copy(CATEGORY)
  category.name = name
  category.derma = derma or 'GTA3HUD_Settings'
  self.properties[id] = category
  category.i = table.Count(self.properties)
  return category
end

--[[------------------------------------------------------------------
  Creates a properties category template for HUD elements.
  @param {string} internal name
  @param {string} name
  @param {Color} colour
  @param {number} x
  @param {number} y
  @param {string|nil} derma panel class used in menu
  @return {table} element category
]]--------------------------------------------------------------------
function HUD:Element(id, name, colour, x, y, derma)
  local category = self:Category(id, name, derma or 'GTA3HUD_Element')
  category:Parameter('colour', '#gta3hud.menu.common.colour', colour)
  category:Parameter('visible', '#gta3hud.menu.common.visible', true)
  category:Parameter('x', '#gta3hud.menu.common.x', x or 0)
  category:Parameter('y', '#gta3hud.menu.common.y', y or 0)
  return category
end

--[[------------------------------------------------------------------
  Adds an uncategorized parameter.
  @param {string} internal name
  @param {string} name
  @param {any} default value
  @return {table} generated property
]]--------------------------------------------------------------------
function HUD:Parameter(id, name, default)
  return parameter(self, id, name, default)
end

--[[------------------------------------------------------------------
  Adds an uncategorized option parameter.
  @param {string} internal name
  @param {string} name
  @param {table} options
  @param {number} default option
  @return {table} generated property
]]--------------------------------------------------------------------
function HUD:Option(id, name, options, default)
  return option(self, id, name, options, default)
end

--[[------------------------------------------------------------------
  Adds an uncategorized ranged numeric parameter.
  @param {string} internal name
  @param {string} name
  @param {number} default value
  @param {number} minimum value
  @param {number} maximum value
  @return {table} generated property
]]--------------------------------------------------------------------
function HUD:Range(id, name, default, min, max)
  return range(self, id, name, default, min, max)
end

--[[------------------------------------------------------------------
  Draws the variant with the given settings.
  @param {table} settings
  @param {number} global size scale configuration
]]--------------------------------------------------------------------
function HUD:Draw(settings, scale) end

--[[------------------------------------------------------------------
  HUDShouldDraw hook proxy for this variant.
  @param {table} settings
  @param {string} CHud element name
  @return {boolean} should it be drawn
]]--------------------------------------------------------------------
function HUD:HUDShouldDraw(settings, element) end

--[[------------------------------------------------------------------
  Overrides the default view when using this HUD.
  @param {table} settings
  @param {Player} player
  @param {Vector} view origin
  @param {Vector} view angles
  @param {number} degrees of field of view
  @param {number} z near component
  @param {number} z far component
  @return {table|nil} view override
]]--------------------------------------------------------------------
function HUD:CalcView(settings, _player, origin, angles, fov, znear, zfar) end

--[[------------------------------------------------------------------
  Creates a table containing the default settings.
  @return {table} settings
]]--------------------------------------------------------------------
function HUD:CopySettings()
  local settings = {}
  for name, property in pairs(self.properties) do
    if property._category then
      local category = {}
      for name, property in pairs(property.properties) do
        local default = property.default
        if istable(default) then default = table.Copy(default) end
        category[name] = default
      end
      settings[name] = category
    else
      local default = property.default
      if istable(default) then default = table.Copy(default) end
      settings[name] = default
    end
  end
  return settings
end

--[[------------------------------------------------------------------
  Creates a blank HUD variant.
  @return {table} variant data
]]--------------------------------------------------------------------
function GTA3HUD.hud.Create()
  return table.Copy(HUD)
end

--[[------------------------------------------------------------------
  Returns a previously registered HUD variant.
  @param {string} name
  @return {table} variant data
]]--------------------------------------------------------------------
function GTA3HUD.hud.Get(name)
  return variants[name]
end

--[[------------------------------------------------------------------
  Returns all registered HUD variants.
  @return {table} variants
]]--------------------------------------------------------------------
function GTA3HUD.hud.All()
  return variants
end

--[[------------------------------------------------------------------
  Returns the default HUD variant.
  @return {table} default variant data
]]--------------------------------------------------------------------
function GTA3HUD.hud.Default()
  return variants[GTA3HUD.hud.default]
end

--[[------------------------------------------------------------------
  Registers the given HUD variant.
  @param {string} name
  @param {table} HUD data
  @return {string} name
]]--------------------------------------------------------------------
function GTA3HUD.hud.Register(name, data)
  if data.default then GTA3HUD.hud.default = name end
  variants[name] = data
  data.i = table.Count(variants)
  return name
end
