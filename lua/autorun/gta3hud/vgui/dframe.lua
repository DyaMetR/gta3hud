
if SERVER then return end

local PANEL = {}

local BUTTON_WIDTH  = 75
local BUTTON_HEIGHT = 23
local BUTTON_MARGIN = 3

--[[------------------------------------------------------------------
  Creates a button from the bottom options.
  @param {Panel} parent panel
  @param {string} text
  @return {DButton} button
]]--------------------------------------------------------------------
local function OptionButton(parent, text)
  local button = vgui.Create('DButton', parent)
  button:SetSize(BUTTON_WIDTH, BUTTON_HEIGHT)
  button:Dock(RIGHT)
  button:DockMargin(0, 0, BUTTON_MARGIN, 0)
  button:SetText(text)
  return button
end

--[[------------------------------------------------------------------
  Initialize property sheet, buttons and menu bar.
]]--------------------------------------------------------------------
function PANEL:Init()
  -- menu bar
  local menu = vgui.Create('DMenuBar', self)
  menu:Dock(TOP)
  menu:DockMargin(0, 0, 0, BUTTON_MARGIN)
  self.MenuBar = menu

  -- scheme options
  local options = vgui.Create('Panel', self)
  options:Dock(BOTTOM)
  options:DockMargin(0, BUTTON_MARGIN, 0, 0)

    -- apply settings
    local apply = OptionButton(options, '#gta3hud.menu.apply')
    apply.DoClick = function() self:Apply() end

    -- cancel
    local cancel = OptionButton(options, '#gta3hud.menu.cancel')
    cancel.DoClick = function() self:Close() end

    -- apply and close
    local ok = OptionButton(options, '#gta3hud.menu.accept')
    ok.DoClick = function()
      self:Apply()
      self:Close()
    end
end

--[[------------------------------------------------------------------
  Adds a menu to the menu bar.
  @param {string} label
  @return {DMenu} created menu
]]--------------------------------------------------------------------
function PANEL:AddMenu(menu)
  return self.MenuBar:AddMenu(menu)
end

--[[------------------------------------------------------------------
  Called to apply the currently cached settings.
]]--------------------------------------------------------------------
function PANEL:Apply() end

vgui.Register('GTA3HUD_Frame', PANEL, 'DFrame')
