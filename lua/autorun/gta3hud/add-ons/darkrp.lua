--[[------------------------------------------------------------------
  Support for DarkRP.
  https://steamcommunity.com/sharedfiles/filedetails/?id=248302805
]]--------------------------------------------------------------------

local HOOK = GTA3HUD.hookname .. '_darkrp'

-- [[ Load DarkRP components only if we're running the gamemode ]] --
hook.Add('OnGamemodeLoaded', HOOK, function()
  if not DarkRP then return end

  -- [[ Server side console variables ]] --
  local hidejob = CreateConVar('gta3hud_darkrp_hidejob', 0, { FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY }, 'Hides the job/salary component on all players\' screens.')
  local hidehitresult = CreateConVar('gta3hud_darkrp_hidehitresult', 0, { FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY }, 'Does not play the \'Mission passed!\' sequence when completing a hit.')

  if SERVER then
    -- [[ Give one star when wanted ]] --
    hook.Add('playerWanted', HOOK, function(_player) GTA3HUD.wanted.Set(_player, math.pow(10 / 6, 2)) end)

    -- [[ Clear stars when unwanted ]] --
    hook.Add('playerUnWanted', HOOK, function(_player) GTA3HUD.wanted.Set(_player, 0) end)

    -- [[ Apply wanted level for wanted criminals only ]] --
    hook.Add('GTA3HUD_OnWantedLevelAdded', HOOK, function(_player) return _player:isWanted() == true end)

    -- [[ Wanted level does not expire on its own ]] --
    hook.Add('GTA3HUD_GetWantedExpiryTime', HOOK, function(_player) return false end)

    return
  end

  -- [[ Console variables ]] --
  local showjob = CreateClientConVar('gta3hud_darkrp_showjob', 1, true)
  local showhitresult = CreateClientConVar('gta3hud_darkrp_showhitresult', 1, true)

  -- [[ Hide default HUD ]] --
  hook.Add('HUDShouldDraw', HOOK, function(element)
    if not GTA3HUD.Enabled() then return end
    if element == 'DarkRP_LocalPlayerHUD' then return false end
  end)

  -- [[ Wallet ]] --
  hook.Add('GTA3HUD_GetMoney', HOOK, function()
    return LocalPlayer():getDarkRPVar('money')
  end)

  -- [[ Hit accepted ]] --
  hook.Add('onHitAccepted', HOOK, function(hitman, target)
    if hitman ~= LocalPlayer() then return end
    GTA3HUD.taskmessage.Submit({language.GetPhrase('gta3hud.darkrp.hit_accepted.1'), Color(150, 0, 0),  target:Name(), NULL, language.GetPhrase('gta3hud.darkrp.hit_accepted.2')})
  end)

  -- [[ Hit completed ]] --
  hook.Add('onHitCompleted', HOOK, function(hitman)
    if hitman ~= LocalPlayer() then return end
    if not showhitresult:GetBool() or hidehitresult:GetBool() then return end
    GTA3HUD.taskresult.Submit({ language.GetPhrase('gta3hud.darkrp.hit_completed'), string.format('$%s', LocalPlayer():getDarkRPVar('hitPrice') or GAMEMODE.Config.minHitPrice) })
  end)

  -- [[ Hit failed ]] --
  hook.Add('onHitFailed', HOOK, function(hitman, _, reason)
    if hitman ~= LocalPlayer() then return end
    GTA3HUD.taskmessage.Submit({ true, reason })
    if not showhitresult:GetBool() or hidehitresult:GetBool() then return end
    GTA3HUD.taskresult.Submit({ language.GetPhrase('gta3hud.darkrp.hit_failed') }, nil, GTA3HUD.taskresult.RESULT_FAILURE)
  end)

  -- [[ Job and salary ]] --
  local job = GTA3HUD.stats.CreateTextStat()
  local salary = GTA3HUD.stats.CreateTextStat()
  hook.Add('GTA3HUD_GetStats', HOOK, function(stats)
    if not showjob:GetBool() or hidejob:GetBool() then return end

    -- job name
    job.value = team.GetName(LocalPlayer():Team())
    table.insert(stats, job)

    -- salary (money coloured!)
    local settings = GTA3HUD.settings.Get()
    salary.value = string.format('$%s', LocalPlayer():getDarkRPVar('salary'))
    if settings and settings.properties.money then salary.colour = settings.properties.money.colour end
    table.insert(stats, salary)
  end)

  -- [[ Show agenda members on the radar ]] --
  hook.Add('GTA3HUD_IsTeamMember', HOOK, function(_player)
    local agenda = LocalPlayer():getAgendaTable()
    return agenda ~= nil and agenda == _player:getAgendaTable()
  end)
end)
