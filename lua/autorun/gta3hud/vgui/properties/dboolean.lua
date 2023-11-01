
if SERVER then return end

local PANEL = {}

function PANEL:Init()
  local check = vgui.Create('DCheckBoxLabel', self)
  check:SetPos(5, 5)
  check:SetTextColor(self:GetSkin().Colours.Label.Dark)
  check.OnChange = function(_, value) self:OnValueChanged(value) end
  self.Check = check
end

function PANEL:SetParameter(parameter)
  self.Check:SetText(parameter.name)
  self.Check:SizeToContents()
end

function PANEL:SetValue(value) self.Check:SetChecked(value) end

vgui.Register('GTA3HUD_Boolean', PANEL, 'GTA3HUD_Parameter')
