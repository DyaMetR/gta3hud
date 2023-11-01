
if SERVER then return end

local MAX_HEIGHT = 256

local _player
local view = { origin = Vector(0, 0, 0), angles = Angle(0, 0, 0) }
local lastAng

-- [[ Signal animation beginning ]] --
hook.Add('GTA3HUD_PlayerWasted', 'lcs', function(ent)
  _player = ent
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
function GTA3HUD.LCS.WastedView(_, origin, angles, fov, znear, zfar)
  if not lastAng then lastAng = angles end
  local ent = _player
  if not ent or not IsValid(ent) then ent = LocalPlayer() end
  local pos = ent:GetPos()
  local time = GTA3HUD.util.DeathTime()

  -- rotate camera
  angles.p = 90
  angles.y = lastAng.y + 48 * time
  angles.r = lastAng.r

  -- move camera upwards
  origin:Set(pos)
  origin.z = math.min(origin.z + 64 + time * 32, origin.z + MAX_HEIGHT)
  trace.start = pos
  trace.endpos = origin

  -- return trace result
  view.angles = angles
  view.origin = util.TraceLine(trace).HitPos
  return view
end
