--[[------------------------------------------------------------------
  Support for Trouble in Terrorist Town.
]]--------------------------------------------------------------------

if SERVER then return end

if engine.ActiveGamemode() ~= 'terrortown' then return end

local HOOK = GTA3HUD.hookname .. '_ttt'

local ROLE_COLOURS = {
  none      = Color(140, 138, 134),
  traitor   = Color(200, 33, 33),
  innocent  = Color(33, 200, 33),
  detective = Color(33, 33, 200)
}

local ROUND_STATE = { 'round_wait', 'round_prep', 'round_active', 'round_post' }

-- [[ Returns the actual time of the round ]] --
local function getTime()
  local endtime = math.max(GetGlobalFloat('ttt_round_end', 0) - CurTime(), 0)
  local minutes = math.floor(endtime / 60)
  return minutes, math.floor(endtime - minutes * 60)
end

-- [[ Hide default HUD ]] --
hook.Add('HUDShouldDraw', HOOK, function(element)
  if not GTA3HUD.Enabled() then return end
  if element == 'TTTInfoPanel' then return false end
end)

-- [[ Hide out HUD when spectating ]] --
hook.Add('GTA3HUD_ShouldDraw', HOOK, function()
  if not LocalPlayer().Team then return end
  if LocalPlayer():Team() == TEAM_SPEC then return false end
end)

-- [[ Get time ]] --
hook.Add('GTA3HUD_GetTime', HOOK, function()
  if HasteMode() and GAMEMODE.round_state == ROUND_ACTIVE then
    local haste = math.max(GetGlobalFloat('ttt_haste_end', 0) - CurTime(), 0)
    local minutes = math.floor(haste / 60)
    return minutes, math.floor(haste - minutes * 60)
  else
    return getTime()
  end
end)

-- [[ Get money ]] --
hook.Add('GTA3HUD_GetMoney', HOOK, function()
  return LocalPlayer():GetBaseKarma()
end)

-- [[ Disable wanted system entirely ]] --
hook.Add('GTA3HUD_OnWantedLevelSet', HOOK, function() return false end)

-- [[ Add statistics ]] --
local role = GTA3HUD.stats.CreateTextStat(nil, 'unknown')
local haste = GTA3HUD.stats.CreateTextStat(nil, '00:00')
local HASTE_FORMAT = '%02d:%02d'
hook.Add('GTA3HUD_GetStats', HOOK, function(stats)
  if not LANG then return end -- do nothing if not initialized
  local langTable = LANG.GetUnsafeLanguageTable()

  -- get role name
  local roundState = GAMEMODE.round_state
  local name = ''
  if roundState == ROUND_ACTIVE then
    name = langTable[LocalPlayer():GetRoleStringRaw()]
  else
    name = langTable[ROUND_STATE[roundState]]
  end

  -- get role colour
  local colour = ROLE_COLOURS.innocent
  if roundState ~= ROUND_ACTIVE then
    colour = ROLE_COLOURS.none
  elseif LocalPlayer():GetTraitor() then
    colour = ROLE_COLOURS.traitor
  elseif LocalPlayer():GetDetective() then
    colour = ROLE_COLOURS.detective
  end

  -- add role
  role.value = name
  role.colour = colour
  table.insert(stats, role)

  -- add haste timer (if traitor)
  if not LocalPlayer():IsActiveTraitor() or not HasteMode() or roundState ~= ROUND_ACTIVE then return end
  haste.value = string.format(HASTE_FORMAT, getTime())
  table.insert(stats, haste)
end)

-- [[ Show fellow traitors on the radar ]] --
hook.Add('GTA3HUD_IsTeamMember', HOOK, function(_player)
  return LocalPlayer():IsActiveTraitor() and _player:IsActiveTraitor()
end)
