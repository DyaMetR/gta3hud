
if SERVER then return end

local PANEL = {}

--[[------------------------------------------------------------------
	Creates the label pair.
]]--------------------------------------------------------------------
function PANEL:Init()
  local skin = self:GetSkin()
  local label = vgui.Create('DLabel', self)
  label:SetTextColor(skin.Colours.Label.Dark)
  self.Label = label
  local help = vgui.Create('DLabel', self)
  help:SetPos(14, 13)
  help:SetTextColor(Color(47, 149, 241))
  self.Help = help
end

--[[------------------------------------------------------------------
	Sets the text of the main label.
  @param {string} label text
]]--------------------------------------------------------------------
function PANEL:SetText(text)
  self.Label:SetText(text)
  self.Label:SizeToContents()
  self:SizeToContents()
end

--[[------------------------------------------------------------------
	Sets the text of the help sub-label.
  @param {string} help label text
]]--------------------------------------------------------------------
function PANEL:SetHelpText(help)
  self.Help:SetText(help)
  self.Help:SizeToContents()
  self:SizeToContents()
	self:SetTall(28)
end

vgui.Register('GTA3HUD_Label', PANEL, 'Panel')
