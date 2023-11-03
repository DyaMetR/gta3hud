--[[------------------------------------------------------------------
  Support for H.E.V Mk V Auxiliary Power
  https://steamcommunity.com/sharedfiles/filedetails/?id=1758584347
]]--------------------------------------------------------------------

if SERVER then return end

if not AUXPOW then return end

local hookname = GTA3HUD.hookname .. '_auxpow'

-- only first letter is upper case
local LABEL_FLASHLIGHT = language.GetPhrase('Valve_Hud_FLASHLIGHT')
LABEL_FLASHLIGHT = utf8.sub(LABEL_FLASHLIGHT, 1, 1) .. string.lower(utf8.sub(LABEL_FLASHLIGHT, 2))

-- [[ Hide main HUD ]] --
hook.Add('AuxPowerHUDPaint', hookname, function()
  if GTA3HUD.Enabled() then
    local settings = GTA3HUD.settings.Get()
    if settings == GTA3HUD.SA.ID then
      if settings.properties.auxpow.visible then return true end
    else
      if settings.properties.stats.visible then return true end
    end
  end
end)

-- [[ Hide flashlight HUD ]] --
hook.Add('EP2FlashlightHUDPaint', hookname, function()
  if GTA3HUD.Enabled() then return true end
end)

-- [[ Replace auxiliary power value ]] --
hook.Add('GTA3HUD_GetSuitPower', hookname, function()
  if not AUXPOW:IsEnabled() then return end
  return AUXPOW:GetPower()
end)

-- [[ Add flashlight battery ]] --
local flashlight = GTA3HUD.stats.CreateProgressBar(LABEL_FLASHLIGHT, 1, true)
hook.Add('GTA3HUD_GetStats', hookname, function(stats)
  if not AUXPOW:IsEnabled() or not AUXPOW:IsEP2HUDEnabled() then return end
  flashlight.value = AUXPOW:GetFlashlight()
  if flashlight.value >= 1 then return end
  table.insert(stats, flashlight)
end)
