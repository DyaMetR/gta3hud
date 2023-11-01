
if SERVER then return end

local MAX_HEIGHT = 512
local RAGDOLL_MARGIN = Vector(0, 0, 14)
local MIN_HEIGHT = Vector(0, 0, 96)

local view = { origin = Vector(0, 0, 0), angles = Angle(0, 0, 0) }
local lastAng
local lastPos
local offset = 0

-- [[ Signal animation beginning ]] --
hook.Add('GTA3HUD_PlayerWasted', 'gta3', function()
  lastAng = nil
  lastPos = nil
  offset = 0
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
local rotation = Angle(0, 0, 0)
local trace = {}
function GTA3HUD.GTA3.WastedView(_, origin, angles, fov, znear, zfar)
  if not lastAng then lastAng = angles end
  local pos = LocalPlayer():GetPos()
  local ragdoll = LocalPlayer():GetRagdollEntity()
  if IsValid(ragdoll) and ragdoll:IsRagdoll() then pos = ragdoll:GetPos() + RAGDOLL_MARGIN end
  if not lastPos then lastPos = origin end

  -- check if we have space to play the animation
  trace.start = pos
  trace.endpos = pos + MIN_HEIGHT
  if util.TraceLine(trace).Hit then
    view.origin = origin
    view.angles = angles
    return view
  end

  -- do animation
  local time = GTA3HUD.util.DeathTime()
  offset = Lerp(FrameTime() * 4, offset, time * math.min(time, 2))
  local normal = (pos - lastPos):GetNormalized()
  rotation.y = offset * 30
  normal:Rotate(rotation)

  -- find the optimal place to put the camera
  trace.start = pos
  trace.endpos = pos - normal * 96 * math.max(1 - offset / 4, 0.01)
  trace.endpos.z = lastPos.z + math.min(offset * 56, MAX_HEIGHT)
  local result = util.TraceLine(trace)
  view.origin = result.HitPos + result.HitNormal * 8
  view.angles = (pos - view.origin):Angle()
  return view
end
