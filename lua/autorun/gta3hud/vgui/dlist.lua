
if SERVER then return end

local PANEL = {}

--[[------------------------------------------------------------------
  Creates the scroll panel.
]]--------------------------------------------------------------------
function PANEL:Init()
  local scroll = vgui.Create('DScrollPanel', self)
  scroll:Dock(FILL)
  scroll:DockMargin(1, 1, 1, 1)
  self.ScrollPanel = scroll
  self.PaintBackground = true
end

--[[------------------------------------------------------------------
  Adds a panel to the list.
  @param {string} panel class
  @return {HL2HUD_PanelList_Line} created line
  @return {Panel} created panel
]]--------------------------------------------------------------------
function PANEL:AddLine(class)
  local skin = self:GetSkin()
  local line = vgui.Create('GTA3HUD_PanelList_Line', self.ScrollPanel)
  line:Dock(TOP)
  line.m_bAlt = self.ScrollPanel:GetChild(0):ChildCount() % 2 ~= 0

    local panel = vgui.Create(class, line)

  return line, panel
end

--[[------------------------------------------------------------------
  Clears the scroll panel.
]]--------------------------------------------------------------------
function PANEL:Clear()
  self.ScrollPanel:Clear()
end

--[[------------------------------------------------------------------
  Sets whether the background should be painted.
  @param {boolean} paint background
]]--------------------------------------------------------------------
function PANEL:SetPaintBackground(paint)
  self.PaintBackground = paint
end

--[[------------------------------------------------------------------
  Paints the background like a DListView.
]]--------------------------------------------------------------------
function PANEL:Paint()
  if not self.PaintBackground then return end
  self:GetSkin().tex.Input.ListBox.Background(0, 0, self:GetWide(), self:GetTall())
end

vgui.Register('GTA3HUD_PanelList', PANEL, 'Panel')
