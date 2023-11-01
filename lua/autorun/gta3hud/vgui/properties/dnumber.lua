
if SERVER then return end

local PANEL = {}

function PANEL:Init()
  local label = vgui.Create('DLabel', self)
  label:SetPos(6, 5)
  label:SetTextColor(self:GetSkin().Colours.Label.Dark)
  self.Label = label

  local number = vgui.Create('DNumberWang', self)
  number:SetWide(128)
  number:Dock(RIGHT)
  number:DockMargin(0, 2, 4, 2)
  number:SetMinMax(-9999, 9999)
  number.OnValueChanged = function(_, value) self:OnValueChanged(value) end
  self.NumberWang = number
end

function PANEL:SetParameter(parameter)
  self.Label:SetText(parameter.name)
  self.Label:SizeToContents()
end

function PANEL:SetValue(value) self.NumberWang:SetValue(value) end

vgui.Register('GTA3HUD_Number', PANEL, 'GTA3HUD_Parameter')
