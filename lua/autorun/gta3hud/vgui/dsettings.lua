
if SERVER then return end

local PANEL = {}

local DEFAULT = 'GTA3HUD_Parameter'
local DATA_TYPES = {
  number = 'GTA3HUD_Number',
  string = 'GTA3HUD_String',
  boolean = 'GTA3HUD_Boolean'
}

--[[------------------------------------------------------------------
  Returns the derma class to instance for this parameter's data type.
  @param {table} parameter
  @return {string} derma panel class
]]--------------------------------------------------------------------
function PANEL:GetParameterDerma(parameter)
  if IsColor(parameter.default) then
    return 'GTA3HUD_Color'
  elseif parameter.options then
    return 'GTA3HUD_Option'
  elseif parameter.min and parameter.max then
    return 'GTA3HUD_Range'
  else
    local class = DATA_TYPES[type(parameter.default)]
    if class then
      return class
    else
      return DEFAULT
    end
  end
end

--[[------------------------------------------------------------------
  Generates the controls to change the HUD (or category) properties.
  @param {table} properties
  @param {table} user settings
]]--------------------------------------------------------------------
function PANEL:Populate(properties, settings)
  local h = 0
  local list = vgui.Create('GTA3HUD_PanelList', self)
  list:SetPaintBackground(false)
  list:Dock(FILL)
  for id, parameter in SortedPairsByMemberValue(properties, 'i') do
    local _, control = list:AddLine(self:GetParameterDerma(parameter))
    control:SetParameter(parameter)
    control:SetValue(settings[id])
    control:Dock(TOP)
    control.OnValueChanged = function(_, value)
      settings[id] = value
    end
    control.OnValueReset = function()
      local default = parameter.default
      if istable(default) then default = table.Copy(default) end
      settings[id] = default
      control:SetValue(default)
    end
    h = h + control:GetTall()
  end
  self:SetTall(h + 2)
end

vgui.Register('GTA3HUD_Settings', PANEL, 'Panel')
