--[[------------------------------------------------------------------
  Code taken from Half-Life 2 HUD's server settings.
  https://github.com/DyaMetR/hl2hud/blob/main/lua/autorun/hl2hud/serverside.lua
]]--------------------------------------------------------------------

local NET_DEFAULT   = 'gta3hud_default'
local NET_OVERRIDE  = 'gta3hud_override'

if SERVER then

  local GAMEPATH  = 'DATA'
  local DIR       = 'gta3hud'
  local FILE_DEFAULT  = DIR .. '\\default.dat'
  local FILE_OVERRIDE = DIR .. '\\override.dat'

  -- super admin only console variable
  local superadmin = CreateConVar('gta3hud_superadminonly', 1, { FCVAR_ARCHIVE, FCVAR_NOTIFY }, 'Limits server-wide override changes to super admins only (instead of admins only)')

  -- networking
  util.AddNetworkString(NET_DEFAULT)
  util.AddNetworkString(NET_OVERRIDE)

  -- schemes
  local default = {}
  local override = {}

  -- [[ Load server configuration ]] --
  hook.Add('Initialize', GTA3HUD.hookname, function()
    if game.SinglePlayer() then return end
    if file.Exists(FILE_DEFAULT, GAMEPATH) then default = util.JSONToTable(file.Read(FILE_DEFAULT, GAMEPATH)) end
    if file.Exists(FILE_OVERRIDE, GAMEPATH) then override = util.JSONToTable(file.Read(FILE_OVERRIDE, GAMEPATH)) end
  end)

  -- [[ Submit server information after joining ]] --
  hook.Add('PlayerInitialSpawn', GTA3HUD.hookname, function(_player)
    if game.SinglePlayer() then return end

    -- send relevant settings
    net.Start(NET_OVERRIDE)
    if not table.IsEmpty(override) then
      net.WriteTable(override)
    else
      net.WriteTable(default)
    end
    net.WriteBool(not table.IsEmpty(default))
    net.WriteBool(not table.IsEmpty(override))
    net.Send(_player)
  end)

  -- [[ Receive default scheme submittion ]] --
  net.Receive(NET_DEFAULT, function(_, _player)
    if game.SinglePlayer() then return end
    if not _player:IsAdmin() then return end
    if superadmin:GetBool() and not _player:IsSuperAdmin() then return end
    if not file.Exists(DIR, GAMEPATH) then file.CreateDir(DIR) end
    default = net.ReadTable()
    file.Write(FILE_DEFAULT, util.TableToJSON(default))

    -- resend default settings if on use
    if not table.IsEmpty(override) then return end
    net.Start(NET_OVERRIDE)
    net.WriteTable(default)
    net.WriteBool(not table.IsEmpty(default))
    net.WriteBool(not table.IsEmpty(override))
    net.Broadcast()
  end)

  -- [[ Receive scheme override submittion ]] --
  net.Receive(NET_OVERRIDE, function(_, _player)
    if game.SinglePlayer() then return end
    if not _player:IsAdmin() then return end
    if superadmin:GetBool() and not _player:IsSuperAdmin() then return end
    if not file.Exists(DIR, GAMEPATH) then file.CreateDir(DIR) end
    override = net.ReadTable()
    file.Write(FILE_OVERRIDE, util.TableToJSON(override))

    -- resend override
    net.Start(NET_OVERRIDE)
    net.WriteTable(override)
    net.WriteBool(not table.IsEmpty(default))
    net.WriteBool(not table.IsEmpty(override))
    net.Broadcast()
  end)

end


if CLIENT then

  GTA3HUD.server = {} -- namespace

  -- [[ Receive server override ]] --
  net.Receive(NET_OVERRIDE, function()
    GTA3HUD.settings.server = net.ReadTable()
    GTA3HUD.server.default = net.ReadBool()
    GTA3HUD.server.override = net.ReadBool()
    if GTA3HUD.toolmenu.overrides then GTA3HUD.toolmenu.overrides:Refresh() end
    GTA3HUD.settings.Reload()
  end)

  --[[------------------------------------------------------------------
    Submits the given settings as the server's default.
    @param {table} scheme
  ]]--------------------------------------------------------------------
  function GTA3HUD.server.SubmitDefault(settings)
    net.Start(NET_DEFAULT)
    net.WriteTable(settings)
    net.SendToServer()
  end

  --[[------------------------------------------------------------------
    Submits the removal of the default settings.
  ]]--------------------------------------------------------------------
  function GTA3HUD.server.RemoveDefault()
    GTA3HUD.server.SubmitDefault({})
  end

  --[[------------------------------------------------------------------
    Submits the given settings as a server-wide override.
    @param {table} scheme
  ]]--------------------------------------------------------------------
  function GTA3HUD.server.SubmitOverride(settings)
    net.Start(NET_OVERRIDE)
    net.WriteTable(settings)
    net.SendToServer()
  end

  --[[------------------------------------------------------------------
    Submits the removal of the override.
  ]]--------------------------------------------------------------------
  function GTA3HUD.server.RemoveOverride()
    GTA3HUD.server.SubmitOverride({})
  end

  if game.SinglePlayer() then return end

  -- [[ Submit default scheme console command ]] --
  concommand.Add('gta3hud_submitdefault', function()
    GTA3HUD.server.SubmitDefault(GTA3HUD.settings.Client())
  end)

  -- [[ Submit scheme override console command ]] --
  concommand.Add('gta3hud_submitoverride', function()
    GTA3HUD.server.SubmitOverride(GTA3HUD.settings.Client())
  end)

  -- [[ Console command to reset server overrides ]] --
  concommand.Add('gta3hud_svreset', function()
    GTA3HUD.server.RemoveDefault()
    GTA3HUD.server.RemoveOverride()
  end)

end
