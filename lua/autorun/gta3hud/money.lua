
if SERVER then return end

GTA3HUD.money = {} -- namespace

-- display modes
GTA3HUD.money.MODES = {
  '#gta3hud.menu.common.money.mode.1',
  '#gta3hud.menu.common.money.mode.2',
  '#gta3hud.menu.common.money.mode.3',
  '#gta3hud.menu.common.money.mode.4',
  '#gta3hud.menu.common.money.mode.5',
  '#gta3hud.menu.common.money.mode.6',
  '#gta3hud.menu.common.money.mode.7'
}
local MONEY_INPUT   = 1
local MONEY_SCORE   = 2
local MONEY_DEATHS  = 3
local MONEY_PING    = 4
local MONEY_HU      = 5
local MONEY_KMH     = 6
local MONEY_MPH     = 7

local money = 0
local lastMoney, targetMoney = 0, 0
local moneyTimeLen, moneyTime = 0, 0

--[[------------------------------------------------------------------
  Returns the animated money value while triggering its animation.
  @param {number} money value override
  @param {boolean} return value without animating
  @return {number} money
]]--------------------------------------------------------------------
function GTA3HUD.money.GetMoney(override, suppressAnimation)
  override = math.floor(hook.Run('GTA3HUD_GetMoney') or override or 0)
  if suppressAnimation then return override end
  if targetMoney ~= override then
    local diff = math.abs(override - money)
    moneyTimeLen = .5
    if diff > 0 then moneyTimeLen = moneyTimeLen + math.floor(math.floor(math.log10(diff)) / 4) end
    moneyTime = CurTime() + moneyTimeLen
    lastMoney = money
    targetMoney = override
  end
  return math.Round(money)
end

--[[------------------------------------------------------------------
  Returns the default raw money value.
  @return {number} money
]]--------------------------------------------------------------------
function GTA3HUD.money.FetchValue()
  return hook.Run('GTA3HUD_GetMoney') or 0
end

--[[------------------------------------------------------------------
  Returns the custom money value depending on the user configuration.
  @param {number} mode
  @param {number|string} custom input
  @return {number} money
]]--------------------------------------------------------------------
function GTA3HUD.money.UserValue(mode, input)
  if mode == MONEY_SCORE then
    return LocalPlayer():Frags()
  elseif mode == MONEY_DEATHS then
    return LocalPlayer():Deaths()
  elseif mode == MONEY_PING then
    return LocalPlayer():Ping()
  elseif mode == MONEY_HU then
    return math.floor(GTA3HUD.util.GetVelocity():Length())
  elseif mode == MONEY_KMH then
    return math.floor(GTA3HUD.util.GetVelocity():Length() * 1.0973)
  elseif mode == MONEY_MPH then
    return math.floor(GTA3HUD.util.GetVelocity():Length() * 0.6818)
  elseif mode == MONEY_INPUT then
    return input
  end
  return 0
end

--[[------------------------------------------------------------------
  Plays the money adjusting animation.
]]--------------------------------------------------------------------
hook.Add('Think', GTA3HUD.hookname .. '_money', function()
  if not GTA3HUD.Enabled() then return end
  money = math.floor(lastMoney + (targetMoney - lastMoney) * (1 - math.pow(math.max((moneyTime - CurTime()) / moneyTimeLen, 0), 3)))
end)
