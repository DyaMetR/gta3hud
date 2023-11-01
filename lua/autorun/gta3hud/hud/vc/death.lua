
if SERVER then return end

local MAX_HEIGHT = 256
local SPEED_SCALE = 1.5
local MIN_HEIGHT = Vector(0, 0, 8)

local view = { origin = Vector(0, 0, 0), angles = Angle(0, 0, 0) }
local lastAng

-- [[ Signal animation beginning ]] --
hook.Add('GTA3HUD_PlayerWasted', 'vc', function()
  lastAng = nil
end)

--[[------------------------------------------------------------------
  Returns a view with the wasted animation running.
  @param {Player} player
  @param {Vector} view origin
  @param {Vector} view angles
  @param {number} degrees of field of view
  @param {number} z near component
  @param {number} z far component
  @return {table|nil} view override
]]--------------------------------------------------------------------
local trace = {}
function GTA3HUD.VC.WastedView(_, origin, angles, fov, znear, zfar)
  if not lastAng then lastAng = angles end
  local pos = LocalPlayer():GetPos()
  local ragdoll = LocalPlayer():GetRagdollEntity()
  if IsValid(ragdoll) and ragdoll:IsRagdoll() then pos = ragdoll:GetPos() end
  local time = GTA3HUD.util.DeathTime()

  -- check if we have space to play the animation
  trace.start = pos
  trace.endpos = pos + MIN_HEIGHT
  if util.TraceLine(trace).Hit then
    view.origin = origin
    view.angles = angles
    return view
  end

  -- look down
  angles.p = 90
  angles.y = lastAng.y
  angles.r = lastAng.r

  -- sway camera
  trace.start = pos
  origin:Set(pos)
  origin.z = math.min(origin.z + 32 + time * 32, origin.z + MAX_HEIGHT)
  trace.endpos = origin - angles:Right() * 64 * math.cos((time * SPEED_SCALE) - (math.pi / 2))
  angles = angles + Angle(8 * math.cos(time * SPEED_SCALE), 90, 90)

  -- apply parameters
  local result = util.TraceLine(trace)
  view.angles = angles
  view.origin = result.HitPos + result.HitNormal * 8
  return view
end
