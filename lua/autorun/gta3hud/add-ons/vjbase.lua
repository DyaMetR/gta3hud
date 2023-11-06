--[[------------------------------------------------------------------
  Support for VJ Base NPCs.
  https://steamcommunity.com/sharedfiles/filedetails/?id=131759821
]]--------------------------------------------------------------------

if CLIENT then return end

if not VJ then return end

local varCPly = 'CLASS_PLAYER_ALLY'
local varCCom = 'CLASS_COMBINE'

-- [[ Look for the base of the NPC to apply an adequate penalty ]] --
hook.Add('GTA3HUD_GetAttackWantedLevel', GTA3HUD.hookname .. '_vjbase', function(victim)
  if not victim.IsVJBaseSNPC or not victim.VJ_NPC_Class then return end
  for _, class in pairs(victim.VJ_NPC_Class) do
    if class == varCCom then return GTA3HUD.wanted.PENALTY_AUTHORITY end
    if class == varCPly then return GTA3HUD.wanted.PENALTY_HUMAN end
  end
end)
