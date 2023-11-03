
GTA3HUD.include('settings.lua')
GTA3HUD.include('override.lua')
GTA3HUD.include('serverside.lua')
GTA3HUD.include('draw.lua')
GTA3HUD.include('map.lua')
GTA3HUD.include('weapons.lua')
GTA3HUD.include('hud.lua')
GTA3HUD.include('blink.lua')
GTA3HUD.include('fonts.lua')
GTA3HUD.include('ammo.lua')
GTA3HUD.include('util.lua')
GTA3HUD.include('money.lua')
GTA3HUD.include('wanted.lua')
GTA3HUD.include('radar.lua')
GTA3HUD.include('stats.lua')
GTA3HUD.include('taskresult.lua')
GTA3HUD.include('taskmessage.lua')

GTA3HUD.include('vgui/about.lua')
GTA3HUD.include('vgui/dframe.lua')
GTA3HUD.include('vgui/dline.lua')
GTA3HUD.include('vgui/dlist.lua')
GTA3HUD.include('vgui/dcolorcombo.lua')
GTA3HUD.include('vgui/dcolormixerbutton.lua')
GTA3HUD.include('vgui/dlabel.lua')

GTA3HUD.include('vgui/properties/dparameter.lua')
GTA3HUD.include('vgui/properties/dboolean.lua')
GTA3HUD.include('vgui/properties/dnumber.lua')
GTA3HUD.include('vgui/properties/drange.lua')
GTA3HUD.include('vgui/properties/doption.lua')
GTA3HUD.include('vgui/properties/dcolor.lua')
GTA3HUD.include('vgui/properties/dstring.lua')

GTA3HUD.include('vgui/dsettings.lua')
GTA3HUD.include('vgui/delement.lua')

GTA3HUD.include('qmenu/menu.lua')
GTA3HUD.include('qmenu/toolmenu.lua')

GTA3HUD.include('hud/gta3/init.lua')
GTA3HUD.include('hud/vc/init.lua')
GTA3HUD.include('hud/sa/init.lua')
GTA3HUD.include('hud/lcs/init.lua')
GTA3HUD.include('hud/vcs/init.lua')

if CLIENT then

  -- [[ Main settings ]] --
  local convar_enabled = CreateClientConVar('gta3hud_enabled', 1, true)
  local convar_filter = CreateClientConVar('gta3hud_filter', 1, true)
  local convar_scale = CreateClientConVar('gta3hud_scale', 1, true)
  cvars.AddChangeCallback(convar_scale:GetName(), function(_, _, value) GTA3HUD.fonts.Generate(value) end)

  -- [[ Returns whether the HUD is enabled. ]] --
  function GTA3HUD.Enabled()
    local enabled = hook.Run('GTA3HUD_ShouldDraw')
    if enabled == nil then enabled = convar_enabled:GetBool() end
    return enabled
  end

  -- [[ Returns whether the texture filtering is enabled. ]] --
  function GTA3HUD.TextureFiltering() return convar_filter:GetBool() end

  -- [[ Returns the HUD scale. ]] --
  function GTA3HUD.Scale() return convar_scale:GetFloat() end

  -- [[ Initialization ]] --
  GTA3HUD.settings.Init()
  local settings = GTA3HUD.settings.Get()
  GTA3HUD.fonts.Generate(convar_scale:GetFloat())

  -- [[ Draw HUD ]] --
  hook.Add('HUDPaint', GTA3HUD.hookname, function()
    if not GTA3HUD.Enabled() then return end

    if GTA3HUD.TextureFiltering() then
      render.PushFilterMag(TEXFILTER.ANISOTROPIC)
      render.PushFilterMin(TEXFILTER.ANISOTROPIC)
    end

    GTA3HUD.hud.Get(settings.name):Draw(settings.properties, GTA3HUD.Scale())

    if GTA3HUD.TextureFiltering() then
      render.PopFilterMag()
      render.PopFilterMin()
    end
  end)

  -- [[ Override view ]] --
  hook.Add('CalcView', GTA3HUD.hookname, function(_player, origin, angles, fov, znear, zfar)
    if not GTA3HUD.Enabled() then return end
    return GTA3HUD.hud.Get(settings.name):CalcView(settings.properties, _player, origin, angles, fov, znear, zfar)
  end)

  -- [[ Hide CHud elements ]] --
  hook.Add('HUDShouldDraw', GTA3HUD.hookname, function(element)
    if not GTA3HUD.Enabled() then return end
    return GTA3HUD.hud.Get(settings.name):HUDShouldDraw(settings.properties, element)
  end)

  -- [[ Move death notice out of the way ]] --
  hook.Add('DrawDeathNotice', GTA3HUD.hookname, function(x, y)
  	if not GTA3HUD.Enabled() then return end
  	GAMEMODE:DrawDeathNotice(.15, y)
  	return true
  end)

  -- [[ Reset convars and configuration ]] --
  concommand.Add('gta3hud_reset', function()
    RunConsoleCommand(convar_filter:GetName(), convar_filter:GetDefault())
    RunConsoleCommand(convar_scale:GetName(), convar_scale:GetDefault())
    GTA3HUD.settings.Reset()
  end)

end

-- [[ Load third party add-ons ]] --
hook.Add('PostGamemodeLoaded', GTA3HUD.hookname, function()
  local PATH_THIRDPARTY = 'autorun/gta3hud/add-ons/'
  local files, directories = file.Find(PATH_THIRDPARTY .. '*.lua', 'LUA')
  for _, file in pairs(files) do
    GTA3HUD.include(PATH_THIRDPARTY .. file)
  end
end)
