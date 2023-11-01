
if SERVER then return end

GTA3HUD.util = {} -- namespace

local DEATH_THRESHOLD, DEATH_MAXSPEED = 1, math.pow(32, 2)

local wasAlive, deathTime = false, 0
local lastPos, lastAng = Vector(0, 0, 0), Angle(0, 0, 0)

--[[------------------------------------------------------------------
  Returns the hour and minutes of the current system time.
  @return {number} hour
  @return {number} minutes
]]--------------------------------------------------------------------
function GTA3HUD.util.OSTime()
  local time = os.time()
  return tonumber(os.date('%H', time)), tonumber(os.date('%M', time))
end

--[[------------------------------------------------------------------
  Returns how long has the game session been going for.
  @return {number} minutes
  @return {number} seconds
]]--------------------------------------------------------------------
function GTA3HUD.util.GameSession()
  local time = CurTime()
  local minutes = math.floor(time / 60)
  return minutes, time - minutes * 60
end

--[[------------------------------------------------------------------
  Fail-safe function that returns whether the player is alive.
  @return {boolean} is player alive
]]--------------------------------------------------------------------
function GTA3HUD.util.IsAlive()
  return LocalPlayer and LocalPlayer().Alive and LocalPlayer():Alive()
end

--[[------------------------------------------------------------------
  Returns how long has the player been dead for.
  @return {number} dead time
]]--------------------------------------------------------------------
function GTA3HUD.util.DeathTime()
  if wasAlive then return 0 end
  return CurTime() - deathTime
end

--[[------------------------------------------------------------------
  Whether the wasted label should be shown.
  @return {boolean} is the player wasted
]]--------------------------------------------------------------------
function GTA3HUD.util.IsWasted()
  return not wasAlive
end

--[[------------------------------------------------------------------
  Returns the current player velocity or their vehicle's.
  @return {Vector} velocity
]]--------------------------------------------------------------------
function GTA3HUD.util.GetVelocity()
  if LocalPlayer():InVehicle() then
    if IsValid(LocalPlayer():GetVehicle():GetMoveParent()) then
      return LocalPlayer():GetVehicle():GetMoveParent():GetVelocity()
    else
      return LocalPlayer():GetVehicle():GetVelocity()
    end
  end
  return LocalPlayer():GetVelocity()
end

--[[------------------------------------------------------------------
  Marks the time the player died for animations.
]]--------------------------------------------------------------------
hook.Add('Think', GTA3HUD.hookname .. '_util', function()
  if not GTA3HUD.Enabled() then return end
  if not LocalPlayer or not LocalPlayer().Alive then return end
  if not LocalPlayer():Alive() then
    if wasAlive then
      if deathTime > CurTime() then return end -- give it some time to reposition
      local origin = LocalPlayer()
      local ragdoll = LocalPlayer():GetRagdollEntity()
      if not IsValid(ragdoll) then return end
      local physobj = ragdoll:GetPhysicsObject()
      if IsValid(physobj) then
        if physobj:GetVelocity():LengthSqr() > DEATH_MAXSPEED then return end
        origin = physobj
      end
      wasAlive = false
      deathTime = CurTime()
      hook.Run('GTA3HUD_PlayerWasted', origin)
    end
    return
  end
  wasAlive = true
  deathTime = CurTime() + DEATH_THRESHOLD
end)
