--[[------------------------------------------------------------------
  Support for nMoney2.
  https://steamcommunity.com/sharedfiles/filedetails/?id=2430255692
]]--------------------------------------------------------------------

if SERVER then return end

if not NMONEY2_MAXVALUE then return end

-- [[ Show nMoney2 wallet money ]] --
hook.Add('GTA3HUD_GetMoney', GTA3HUD.hookname .. '_nmoney2', function()
  return tonumber(LocalPlayer():GetNWString('WalletMoney'))
end)
