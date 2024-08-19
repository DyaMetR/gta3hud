--[[------------------------------------------------------------------
  Support for Goldsrc Counter-Strike Buymenu.
  https://steamcommunity.com/sharedfiles/filedetails/?id=3311934020
]]--------------------------------------------------------------------

hook.Add('GTA3HUD_GetMoney', 'cstrikebuymenu', function()
  local money = LocalPlayer():GetNW2Int('cstrike_money', -1)
  if money == -1 then return end
  return money
end)

hook.Add('CStrike_MoneyHUD', 'gta3hud', function()
  if not GTA3HUD.Enabled() then return end
  return true
end)