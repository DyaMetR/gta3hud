
if SERVER then return end

local PANEL = {}

function PANEL:Init()
  local label = vgui.Create('DLabel', self)
  label:SetPos(6, 5)
  label:SetTextColor(self:GetSkin().Colours.Label.Dark)
  self.Label = label

  local colour = vgui.Create('DColorMixerButton', self)
  colour:SetWide(128)
  colour:Dock(RIGHT)
  colour:DockMargin(0, 2, 4, 2)
  colour.OnValueChanged = function(_, value) self:OnValueChanged(value) end
  self.ColorMixer = colour
end

function PANEL:SetParameter(parameter)
  self.Label:SetText(parameter.name)
  self.Label:SizeToContents()
end

function PANEL:SetValue(value) self.ColorMixer:SetValue(value) end

vgui.Register('GTA3HUD_Color', PANEL, 'GTA3HUD_Parameter')
