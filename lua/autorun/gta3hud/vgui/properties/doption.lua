
if SERVER then return end

local PANEL = {}

function PANEL:Init()
  local label = vgui.Create('DLabel', self)
  label:SetPos(6, 5)
  label:SetTextColor(self:GetSkin().Colours.Label.Dark)
  self.Label = label

  local combo = vgui.Create('DComboBox', self)
  combo:SetWide(128)
  combo:Dock(RIGHT)
  combo:DockMargin(0, 2, 4, 2)
  combo.OnSelect = function(_, option) self:OnValueChanged(option) end
  self.ComboBox = combo
end

function PANEL:SetParameter(parameter)
  self.Label:SetText(parameter.name)
  self.Label:SizeToContents()
  for _, option in pairs(parameter.options) do
    self.ComboBox:AddChoice(option)
  end
end

function PANEL:SetValue(value) self.ComboBox:SetValue(self.ComboBox:GetOptionText(value)) end

vgui.Register('GTA3HUD_Option', PANEL, 'GTA3HUD_Parameter')
