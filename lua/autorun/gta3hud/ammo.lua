
if SERVER then return end

GTA3HUD.ammo = {} -- namespace

--[[------------------------------------------------------------------
  Fetches the amount shown on the primary ammunition display.
  @return {boolean} is ammunition valid
  @return {number|nil} clip ammunition
  @return {number|nil} reserve ammunition
]]--------------------------------------------------------------------
function GTA3HUD.ammo.Primary()
  -- check whether the current vehicle has a weapon
  if LocalPlayer():InVehicle() and LocalPlayer():GetVehicle().GetAmmo then
    local _, _, ammo = LocalPlayer():GetVehicle():GetAmmo()
    if ammo > -1 then return true, ammo end
  end

  -- check validity of current weapon
  local weapon = LocalPlayer():GetActiveWeapon()
  if not IsValid(weapon) then return false end

  -- check whether it's a SWEP with a custom ammunition display
  if weapon:IsScripted() then
    local ammo = weapon:CustomAmmoDisplay()
    if ammo then
      local clip, reserve = ammo.PrimaryClip, ammo.PrimaryAmmo

      -- if there's no reserve, use the clip ammunition as such
      if not reserve then
        return ammo.Draw, clip
      else
        -- if the clip is -1, ignore it
        if clip <= -1 then
          return ammo.Draw, reserve
        else
          return ammo.Draw, reserve, clip
        end
      end
    end
  end

  -- check if it's using ammunition at all
  local primary, secondary = weapon:GetPrimaryAmmoType(), weapon:GetSecondaryAmmoType()
  if primary <= 0 and secondary <= 0 then return false end

  -- discriminate between clip based weapons, reserve only or even if it's using secondary ammunition instead (like SLAMs)
  if primary <= 0 and secondary > 0 then return true, LocalPlayer():GetAmmoCount(secondary) end
  local clip, reserve = weapon:Clip1(), LocalPlayer():GetAmmoCount(primary)
  if clip <= -1 then
    return true, reserve
  else
    return true, clip, reserve
  end
end

--[[------------------------------------------------------------------
  Fetches the current weapon's secondary ammunition.
  @return {boolean} can secondary ammunition be displayed
  @return {number|nil} secondary ammunition type
  @return {number|nil} secondary reserve ammunition
]]--------------------------------------------------------------------
function GTA3HUD.ammo.Secondary()
  local weapon = LocalPlayer():GetActiveWeapon()

  -- check if our weapon is invalid or if we're in a vehicle
  if not IsValid(weapon) or (LocalPlayer():InVehicle() and not LocalPlayer():GetAllowWeaponsInVehicle()) then return false end

  -- check if primary ammunition displayed has been replaced
  if weapon:GetPrimaryAmmoType() <= 0 then return false end

  -- check if active weapon has secondary ammunition
  local ammo = weapon:GetSecondaryAmmoType()
  if ammo <= 0 then return false end

  return true, LocalPlayer():GetAmmoCount(ammo)
end
