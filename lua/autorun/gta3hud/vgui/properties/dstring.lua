
if SERVER then return end

local PANEL = {}

function PANEL:Init()
  local entry = vgui.Create('DTextEntry', self)
  entry:Dock(FILL)
  entry:DockMargin(2, 2, 2, 2)
  entry.OnValueChange = function(_, value) self:OnValueChanged(value) end
  self.TextEntry = entry
end

function PANEL:SetParameter(parameter)
  self.TextEntry:SetPlaceholderText(parameter.name)
end

function PANEL:SetValue(value) self.TextEntry:SetValue(value) end

vgui.Register('GTA3HUD_String', PANEL, 'GTA3HUD_Parameter')
