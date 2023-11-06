--[[------------------------------------------------------------------
  Support for Background NPCs.
  https://steamcommunity.com/sharedfiles/filedetails/?id=2341497926
]]--------------------------------------------------------------------

if not bgNPC then return end

local hookname = GTA3HUD.hookname .. '_bgNPC'

if SERVER then

  -- [[ Disable wanted level if Background NPCs' wanted system is enabled ]] --
  hook.Add('GTA3HUD_OnWantedLevelSet', hookname, function()
    if GetConVar('bgn_enable'):GetBool() and GetConVar('bgn_wanted_level'):GetBool() then return false end
  end)

  return
end

local wantedModule = bgNPC:GetModule('wanted')

-- [[ Replace wanted level with Background NPCs' ]] --
hook.Add('GTA3HUD_GetWantedLevel', hookname, function()
  if not GetConVar('bgn_enable'):GetBool() then return end
  if not GetConVar('bgn_wanted_level'):GetBool() then return end
  local WantedClass = wantedModule:GetWanted(LocalPlayer())
  if not WantedClass then return 0 end
  return WantedClass.level
end)

-- [[ Hide default wanted HUD ]] --
local drawfunc = hook.GetTable().HUDPaint.BGN_DrawWantedText
hook.Add('HUDPaint', 'BGN_DrawWantedText', function()
  if GTA3HUD.Enabled() then return end
  drawfunc()
end)
