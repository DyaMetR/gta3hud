
if SERVER then return end

local PANEL = {}

local URL_STEAM   = 'https://steamcommunity.com/id/dyametr/myworkshopfiles/'
local URL_GITHUB  = 'https://github.com/DyaMetR/gta3hud'

-- version font
surface.CreateFont('gta3hud_about_version', {
  font = 'Pricedown Theft Auto',
  size = 52,
  shadow = true
})

--[[------------------------------------------------------------------
  Populate the about page.
]]--------------------------------------------------------------------
function PANEL:Init()
  local background = vgui.Create('DImage', self)
  background:Dock(FILL)
  background:SetImage('gta3hud/background.png')
  background:SetKeepAspect(true)
  background:SetMouseInputEnabled(true)
  background:SetImageColor(Color(166, 166, 166))

  local logo = vgui.Create('DImage', background)
  logo:SetX(40)
  logo:SetSize(430, 430)
  logo:SetImage('gta3hud/about.png')

    local version = vgui.Create('DLabel', logo)
    version:SetText(GTA3HUD.version)
    version:SetFont('gta3hud_about_version')
    version:SizeToContents()
    version:Dock(BOTTOM)
    version:DockMargin(0, 0, 0, 24)
    version:SetContentAlignment(3)

  local footer = vgui.Create('Panel', background)
  footer:DockPadding(8, 0, 8, 0)
  footer:Dock(BOTTOM)

    local author = vgui.Create('DLabel', footer)
    author:SetText(string.format(language.GetPhrase('gta3hud.about.author'), 'DyaMetR'))
    author:SizeToContents()
    author:Dock(LEFT)

    local buttons = vgui.Create('Panel', footer)
    buttons:Dock(LEFT)
    buttons:SetWide(36)
    buttons:DockMargin(4, 4, 0, 0)

      local steam = vgui.Create('DImageButton', buttons)
      steam:SetTooltip('#gta3hud.about.workshop')
      steam:SetSize(16, 16)
      steam:SetImage('gta3hud/steam16.png')
      steam.DoClick = function() gui.OpenURL(URL_STEAM) end

      local github = vgui.Create('DImageButton', buttons)
      github:SetTooltip('#gta3hud.about.github')
      github:SetX(20)
      github:SetSize(16, 16)
      github:SetImage('gta3hud/github16.png')
      github.DoClick = function() gui.OpenURL(URL_GITHUB) end

    local date = vgui.Create('DLabel', footer)
    date:SetText(GTA3HUD.date)
    date:SizeToContents()
    date:Dock(RIGHT)

  local copyright = vgui.Create('DLabel', background)
  copyright:SetText('#gta3hud.about.copyright')
  copyright:SizeToContents()
  copyright:SetContentAlignment(2)
  copyright:Dock(BOTTOM)
  copyright:DockMargin(0, 0, 0, 26)

  local thanks = vgui.Create('DLabel', background)
  thanks:SetFont('DermaDefaultBold')
  thanks:SetText(string.format(language.GetPhrase('gta3hud.about.thanks'), GTA3HUD.name))
  thanks:SizeToContents()
  thanks:SetContentAlignment(2)
  thanks:Dock(BOTTOM)
  thanks:DockMargin(0, 0, 0, 8)

  self:SetSize(512, 558)
  self:SetDraggable(false)
  self:SetBackgroundBlur(true)
  self:MakePopup()
  self:DoModal()
end

vgui.Register('GTA3HUD_About', PANEL, 'DFrame')
