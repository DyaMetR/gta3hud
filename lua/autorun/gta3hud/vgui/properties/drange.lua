
if SERVER then return end

local PANEL = {}

function PANEL:Init()
  local slider = vgui.Create('DNumSlider', self)
  slider:SetDark(true)
  slider:Dock(FILL)
  slider:DockMargin(7, 0, 0, 0)
  slider:SetDecimals(0)
  slider.OnValueChanged = function(_, value) self:OnValueChanged(value) end
  self.Slider = slider
end

function PANEL:SetParameter(parameter)
  self.Slider:SetText(parameter.name)
  self.Slider:SetMinMax(parameter.min, parameter.max)
  if parameter.decimals then self.Slider:SetDecimals(1) end
end

function PANEL:SetValue(value) self.Slider:SetValue(value) end

vgui.Register('GTA3HUD_Range', PANEL, 'GTA3HUD_Parameter')
