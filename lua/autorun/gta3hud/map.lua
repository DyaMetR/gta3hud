
if SERVER then return end

local allow = CreateClientConVar('gta3hud_minimap', 1, true)

GTA3HUD.map = {} -- namespace

local ASPECT_RATIO = 4 / 3
local CAMERA_RANGE = 2048
local CAMERA_HEIGHT = Vector(0, 0, 4096)

local MAX_ZOOM = 1.5
local ZOOM_VELOCITY_THRESHOLD = math.pow(500, 2)
local ZOOM_MAX_VELOCITY = math.pow(1000, 2)

local CIRCLE_STEP_SIZE = 32

local TEXTURE_SIZE = 256
local RENDER_TARGET = GetRenderTarget('gta3hud_minimap_rendertarget', TEXTURE_SIZE, TEXTURE_SIZE)
local TEXTURE = CreateMaterial('gta3hud/minimap_buffer', 'UnlitGeneric', { ['$basetexture'] = RENDER_TARGET:GetName() })

local PREVIEW = Material('gta3hud/minimap_preview.png')

local DRAW_HOOKS_OVERRIDE = {
  'PreDrawEffects',
  'PreDrawHalos',
  'PreDrawHUD',
  'PreDrawPlayerHands',
  'PreDrawSkyBox',
  'PreDrawViewModel',
  'PrePlayerDraw',
  'PreDrawOpaqueRenderables',
  'PreDrawTranslucentRenderables'
}

local shouldRenderNextFrame, isMapDrawCall = false, false
local circle, lastMapSize = {}, { x = -1, y = -1, w = -1, h = -1 }
local camData = {
  w = TEXTURE_SIZE,
  h = TEXTURE_SIZE,
  angles = Angle(90, 0, 0),
  aspect = ASPECT_RATIO,
  drawhud = false,
  drawmonitors = false,
  drawviewmodel = false,
  ortho = {
    left = -CAMERA_RANGE * ASPECT_RATIO,
    right = CAMERA_RANGE * ASPECT_RATIO,
    top = -CAMERA_RANGE * ASPECT_RATIO,
    bottom = CAMERA_RANGE * ASPECT_RATIO
  },
  viewid = 9
}
local trace = { mask = MASK_NPCWORLDSTATIC }

--[[------------------------------------------------------------------
	Calculates the polygon data for a circle.
  @param {number} x
  @param {number} y
  @param {number} width
  @param {number} height
]]--------------------------------------------------------------------
local function generateCircle(x, y, w, h)
  w = w / 2
  h = h / 2
  table.Empty(circle)
  local count = 0
  for i=0, 2 * math.pi, (2 * math.pi) / CIRCLE_STEP_SIZE do
    count = count + 1
    circle[CIRCLE_STEP_SIZE - count] = {x = math.sin(i) * w + x + w, y = math.cos(i) * h + y + h}
  end
end

--[[------------------------------------------------------------------
	Renders the map from above ortographically.
  @param {number} x
  @param {number} y
  @param {number} width
  @param {number} height
  @param {number} zoom level
]]--------------------------------------------------------------------
function GTA3HUD.map.Draw(x, y, w, h)
  if not allow:GetBool() then return end
  shouldRenderNextFrame = true

  -- generate circle
  if lastMapSize.x ~= x or lastMapSize.y ~= y or lastMapSize.w ~= w or lastMapSize.h ~= h then
    lastMapSize.x = x
    lastMapSize.y = y
    lastMapSize.w = w
    lastMapSize.h = h
    generateCircle(x, y, w, h)
  end

  -- setup stencil
  render.SetStencilWriteMask( 0xFF )
  render.SetStencilTestMask( 0xFF )
  render.SetStencilReferenceValue( 0 )
  render.SetStencilPassOperation( STENCIL_KEEP )
  render.SetStencilZFailOperation( STENCIL_KEEP )
  render.ClearStencil()
  render.SetStencilEnable( true )
  render.SetStencilReferenceValue( 1 )
  render.SetStencilCompareFunction( STENCIL_NEVER )
  render.SetStencilFailOperation( STENCIL_REPLACE )
  draw.NoTexture()
  surface.SetDrawColor(color_white)
  surface.DrawPoly(circle) -- draw circle to use as shape
  render.SetStencilCompareFunction( STENCIL_EQUAL )
  render.SetStencilFailOperation( STENCIL_KEEP )

  -- draw render target
  surface.SetMaterial(TEXTURE)
  surface.DrawTexturedRect(x, y, w, h)

  -- clear stencil
  render.ClearStencil()
  render.SetStencilEnable( false )
end

--[[------------------------------------------------------------------
	Returns the map zoom.
  @return {number} zoom
]]--------------------------------------------------------------------
function GTA3HUD.map.GetZoom()
  return 1 + (MAX_ZOOM - 1) * math.min(math.max(GTA3HUD.util.GetVelocity():LengthSqr() - ZOOM_VELOCITY_THRESHOLD, 0) / ZOOM_MAX_VELOCITY, 1)
end

--[[------------------------------------------------------------------
	Returns how far is the map currently rendering.
  @return {number} distance
  @deprecated
]]--------------------------------------------------------------------
function GTA3HUD.map.GetRange()
  return ASPECT_RATIO * CAMERA_RANGE * GTA3HUD.map.GetZoom()
end

--[[------------------------------------------------------------------
	Draws the minimap preview.
  @param {number} x
  @param {number} y
  @param {number} radius
]]--------------------------------------------------------------------
function GTA3HUD.map.DrawPreview(x, y, radius)
  surface.SetMaterial(PREVIEW)
  surface.SetDrawColor(color_white)
  surface.DrawTexturedRect(x, y, radius, radius)
end

--[[------------------------------------------------------------------
	Renders a frame of the minimap and stores it on the render target.
]]--------------------------------------------------------------------
local function renderMap()
  if not allow:GetBool() then return end
  if not shouldRenderNextFrame then return end
  if not LocalPlayer or not IsValid(LocalPlayer()) then return end

  -- configure trace
  trace.start = LocalPlayer():GetPos()
  trace.endpos = trace.start + CAMERA_HEIGHT

  -- configure camera data
  local ortho = GTA3HUD.map.GetRange()
  camData.origin = util.TraceLine(trace).HitPos
  camData.angles.y = render.GetViewSetup().angles.y
  camData.ortho.left = -ortho
  camData.ortho.right = ortho
  camData.ortho.top = -ortho
  camData.ortho.bottom = ortho

  -- render map frame
  render.PushRenderTarget(RENDER_TARGET)
  render.Clear(0, 0, 0, 0)
  cam.Start2D()
    isMapDrawCall = true
    render.RenderView(camData)
    isMapDrawCall = false
  cam.End2D()
  render.PopRenderTarget()
  shouldRenderNextFrame = false
end

--[[------------------------------------------------------------------
	Render the minimap outside of HUD calls to avoid artifacts.
]]--------------------------------------------------------------------
hook.Add('PreRender', GTA3HUD.hookname .. '_minimap_render', renderMap)

--[[------------------------------------------------------------------
	Override drawing calls if we're rendering the map.
]]--------------------------------------------------------------------
local preDraw = function() if isMapDrawCall then return true end end
for _, hookName in pairs(DRAW_HOOKS_OVERRIDE) do hook.Add(hookName, GTA3HUD.hookname .. '_minimap_override', preDraw) end
