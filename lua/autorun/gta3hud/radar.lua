
local showplayersonradar = CreateConVar('gta3hud_showplayersonradar', 1, { FCVAR_ARCHIVE, FCVAR_REPLICATED }, 'Allows players to see other nearby players on the radar.')
local showteamplayersonradar = CreateConVar('gta3hud_showteamplayersonradar', 0, { FCVAR_ARCHIVE, FCVAR_REPLICATED }, 'Allows players to always see where players on the same team are.')
local shownpcsonradar = CreateConVar('gta3hud_shownpcsonradar', 1, { FCVAR_ARCHIVE, FCVAR_REPLICATED }, 'Allows players to see nearby NPCs on the radar.')

if SERVER then return end

GTA3HUD.radar = {} -- namespace

local BLIP_HEIGHT_MARGIN = 256 -- at which height difference does a blip change to a triangle
local BLIP_MAX_DISTANCE = 4096 -- at which distance does a textured blip start becoming transparent
local BLIP_MAX_TRANSPARENCY = .5

local ICON_SIZE = 16
local BLIP_SIZE = 12
local FRAME_THICKNESS = 5 / 128

local NORTH_TEXTURE = Material('gta3hud/gta3/radar_north.png')
local CENTER_TEXTURE = Material('gta3hud/gta3/radar_centre.png')
local FRAME_TEXTURE = Material('gta3hud/gta3/radardisc.png')

local blips = {}

--[[------------------------------------------------------------------
	Adds either a static blip or a one tied to an entity.
  @param {string} unique identifier
  @param {Vector|Entity} blip origin
  @param {boolean} is it always present or only when nearby
  @param {Material|nil} icon to display instead of the generic option
]]--------------------------------------------------------------------
function GTA3HUD.radar.AddBlip(id, origin, always, icon)
  blips[id] = { origin = origin, always = always, icon = icon }
end

--[[------------------------------------------------------------------
	Removes the given blip.
  @param {string} unique identifier
]]--------------------------------------------------------------------
function GTA3HUD.radar.RemoveBlip(id)
  blips[id] = nil
end

--[[------------------------------------------------------------------
	Returns a blip's information.
  @param {string} unique identifier
  @return {table} blip data
]]--------------------------------------------------------------------
function GTA3HUD.radar.GetBlip(id)
  return blips[id]
end

--[[------------------------------------------------------------------
	Returns all active blips.
  @return {table} blips
]]--------------------------------------------------------------------
function GTA3HUD.radar.GetBlips()
  return blips
end

--[[------------------------------------------------------------------
	Draws a generic radar blip.
  @param {number} x
  @param {number} y
  @param {Color} blip colour
  @param {number} height difference
  @param {number} size scale
]]--------------------------------------------------------------------
function GTA3HUD.radar.DrawBlip(x, y, colour, heightDiff, scale)
  local size = BLIP_SIZE * scale
  x = x - size * .5
  y = y - size * .5
  if math.abs(heightDiff) > BLIP_HEIGHT_MARGIN then
		GTA3HUD.draw.TriangleOutline(x, y, size, size, scale * 2, heightDiff < 0)
    GTA3HUD.draw.Triangle(x + scale, y + scale, size - scale * 2, size - scale * 2, colour, heightDiff < 0)
  else
    draw.RoundedBox(0, x, y, size, size, color_black)
    draw.RoundedBox(0, x + scale, y + scale, size - scale * 2, size - scale * 2, colour)
  end
end

--[[------------------------------------------------------------------
	Draws a textured radar blip.
  @param {number} x
  @param {number} y
  @param {Material} texture
  @param {number} blip opacity
  @param {number} size scale
]]--------------------------------------------------------------------
function GTA3HUD.radar.DrawIconBlip(x, y, texture, opacity, scale)
  local size = ICON_SIZE * scale
  surface.SetAlphaMultiplier(opacity)
  surface.SetDrawColor(color_white)
  surface.SetMaterial(texture)
  surface.DrawTexturedRect(x - size * .5, y - size * .5, size, size)
  surface.SetAlphaMultiplier(1)
end

--[[------------------------------------------------------------------
  Returns the blip relative position on the screen.
  @param {number} x
	@param {number} y
	@param {number} radar radius
	@param {number} radar range
	@param {Vector} position in the world
	@param {number} radar angle
	@param {number} scale
]]--------------------------------------------------------------------
function GTA3HUD.radar.GetBlipScreenPos(x, y, radius, range, pos, angle, scale)
	local limit = radius * .5 - radius * FRAME_THICKNESS
	pos = pos / range
	angle = math.rad(angle)
	local xpos = ((math.cos(angle) * pos.x * limit) + (math.sin(angle) * pos.y * limit))
	local ypos = ((math.cos(angle) * pos.y * limit) - (math.sin(angle) * pos.x * limit))
	local blipang = math.atan2(ypos, -xpos)
	local xmax = math.abs(math.cos(blipang) * limit * scale)
	local ymax = math.abs(math.sin(blipang) * limit * scale)
	return x - math.Clamp(xpos, -xmax, xmax), y + math.Clamp(ypos, -ymax, ymax) -- seriously, I bow down to people who can figure this shit out on their own
end

--[[------------------------------------------------------------------
  Returns the colour used by this blip.
  @param {number} player's team
  @param {Vector|Entity} blip origin
  @param {table} colour table
  @return {Color} colour used
]]--------------------------------------------------------------------
local function blipColour(t, origin, colours)
  if isvector(origin) then return colours.position end

	-- ask the custom hook if there's a colour for this entity
	local colour = hook.Run('GTA3HUD_GetEntityRadarColor', origin)
	if colour then return colour end

	-- otherwise, let's guess it
  if origin:IsPlayer() or origin:IsNPC() then
		local onTeam = false
		if origin:IsPlayer() then
			onTeam = hook.Run('GTA3HUD_IsTeamMember', origin)
			if onTeam == nil then onTeam = origin:Team() == t end
			if colours.useTeamColour then return team.GetColor(t) end
		else
			onTeam = IsFriendEntityName(origin:GetClass())
		end
		if onTeam then return colours.friend end
		return colours.hostile
  end
  return colours.entities
end

--[[------------------------------------------------------------------
	Draws all blips.
  @param {number} x
  @param {number} y
  @param {number} radar radius
  @param {number} radar angle
  @param {table} colour table
    - friend: Friendly player/NPC colour
    - hostile: Hostile player/NPC colour
    - useTeamColour: Use the team colour for players
    - entities: Colour for entities
    - position: Colour for static positions
  @param {number} scale
]]--------------------------------------------------------------------
local origin2d, blip2d = Vector(0, 0, 0), Vector(0, 0, 0) -- cached vectors used in 2D distance calculus
function GTA3HUD.radar.DrawBlips(x, y, radius, angle, colours, scale)
	local origin = LocalPlayer():GetPos()
	local zoom = GTA3HUD.map.GetZoom()
	local range = GTA3HUD.map.GetRange()

	-- prepare local origin for 2D distance calculus
	origin2d.x = origin.x
	origin2d.y = origin.y

	-- draw players and NPCs
	for _, ent in pairs(ents.GetAll()) do
		if not IsValid(ent) or ent == LocalPlayer() or (not ent:IsPlayer() and not ent:IsNPC()) then continue end
		local t, pos = LocalPlayer():Team(), ent:GetPos()
		blip2d.x = pos.x
		blip2d.y = pos.y
		if ent:IsPlayer() then
			local onTeam = hook.Run('GTA3HUD_IsTeamMember', ent)
			if onTeam == nil then onTeam = ent:Team() == t end
			local show = hook.Run('GTA3HUD_DrawPlayerOnRadar', ent, blip2d:Distance(origin2d) < range)
			if show == false then continue end
			if show == nil and not (showplayersonradar:GetBool() and blip2d:Distance(origin2d) < range) and not (onTeam and showteamplayersonradar:GetBool()) then continue end
		elseif ent:IsNPC() then
			local show = hook.Run('GTA3HUD_DrawNPCOnRadar', ent)
			if show == false then continue end
			if show == nil and ((not game.SinglePlayer() and not shownpcsonradar:GetBool()) or blip2d:Distance(origin2d) > range) then continue end
		end
		local xpos, ypos = GTA3HUD.radar.GetBlipScreenPos(x, y, radius, range / scale, origin - pos, angle, scale)
		GTA3HUD.radar.DrawBlip(xpos, ypos, blipColour(t, ent, colours), pos.z - origin.z, scale)
	end

	-- draw blips
	for id, blip in pairs(blips) do
		local pos = blip.origin
		if not isvector(blip.origin) then
			if not IsValid(blip.origin) then
				blips[id] = nil
				continue
			end
			pos = blip.origin:GetPos()
		end
		blip2d.x = pos.x
		blip2d.y = pos.y
		local dist = blip2d:Distance(origin2d)
		if not blip.always and dist > range then continue end
		local xpos, ypos = GTA3HUD.radar.GetBlipScreenPos(x, y, radius, range / scale, origin - pos, angle, scale)
		if blip.icon then
			GTA3HUD.radar.DrawIconBlip(xpos, ypos, blip.icon, 1 - BLIP_MAX_TRANSPARENCY * (math.Clamp(dist - range, 0, BLIP_MAX_DISTANCE) / BLIP_MAX_DISTANCE), scale)
		else
			GTA3HUD.radar.DrawBlip(xpos, ypos, blipColour(t, origin, colours), pos.z - origin.z, scale)
		end
	end
end

--[[------------------------------------------------------------------
	Draws the radar frame. Defaults to the GTA 3 texture.
	@param {number} x
	@param {number} y
	@param {number} radius
	@param {Color} colour
	@param {Material|nil} texture override
]]--------------------------------------------------------------------
function GTA3HUD.radar.DrawFrame(x, y, radius, colour, texture)
	surface.SetDrawColor(colour)
	surface.SetMaterial(texture or FRAME_TEXTURE)
	surface.DrawTexturedRect(x, y, radius, radius)
end

--[[------------------------------------------------------------------
	Renders the north icon rotating around a circle.
  @param {number} x
  @param {number} y
  @param {number} radius
  @param {number} angle
  @param {number} scale
  @param {Material} texture override
]]--------------------------------------------------------------------
function GTA3HUD.radar.DrawNorth(x, y, radius, angle, scale, texture)
  texture = texture or NORTH_TEXTURE
  local size = ICON_SIZE * scale
  local margin = radius * FRAME_THICKNESS
  x = x + math.cos(math.rad(angle - 90)) * (radius * .5 - margin)
  y = y + math.sin(math.rad(angle - 90)) * (radius * .5 - margin)
  surface.SetMaterial(texture)
  surface.SetDrawColor(color_white)
  surface.DrawTexturedRect(x - size * .5, y - size * .5, size, size)
end

--[[------------------------------------------------------------------
	Draws the center of the radar.
  @param {number} x
  @param {number} y
  @param {number} scale
  @param {Material} texture override
]]--------------------------------------------------------------------
function GTA3HUD.radar.DrawCenter(x, y, scale, texture)
  texture = texture or CENTER_TEXTURE
  local size = ICON_SIZE * scale
  surface.SetMaterial(texture)
  surface.SetDrawColor(color_white)
  surface.DrawTexturedRect(x - size * .5, y - size * .5, size, size)
end

--[[------------------------------------------------------------------
	Draws the radar.
	@param {number} x
	@param {number} y
	@param {Color} colour
	@param {number} radius
	@param {boolean} should render background
  @param {table} blip colour table
    - friend
    - hostile
    - position
    - entities
	@param {number} scale
  @param {Material|nil} frame texture override
	@param {Material|nil} radar center texture override
	@return {number} scaled size
]]--------------------------------------------------------------------
local MINIMAP_MARGIN = 3
function GTA3HUD.radar.Draw(x, y, colour, radius, background, blipColours, scale, frame, center)
	local size = radius * scale
	local margin = MINIMAP_MARGIN * scale
	y = y - size
	local yaw = render.GetViewSetup().angles.y - 90
	if background then GTA3HUD.map.Draw(x + margin, y + margin, size - margin * 2, size - margin * 2) end
	GTA3HUD.radar.DrawFrame(x, y, radius * scale, colour, frame)
	x = x + size * .5
	y = y + size * .5
	GTA3HUD.radar.DrawNorth(x, y, size, yaw, scale)
	GTA3HUD.radar.DrawCenter(x, y, scale, center)
	GTA3HUD.radar.DrawBlips(x, y, radius, yaw, blipColours, scale)
	return size
end

--[[------------------------------------------------------------------
	Draws the radar preview.
	@param {number} canvas width
	@param {number} canvas height
	@param {boolean} should draw preview background
	@param {Material|nil} frame texture override
	@param {Material|nil} radar center texture override
]]--------------------------------------------------------------------
local PREVIEW_RADIUS = 110
local PREVIEW_MINIMAP_MARGIN = 4
function GTA3HUD.radar.DrawPreview(w, h, colour, background, frame, center)
	local x, y = w * .5 - PREVIEW_RADIUS * .5, 10
	if background then GTA3HUD.map.DrawPreview(x + PREVIEW_MINIMAP_MARGIN, y + PREVIEW_MINIMAP_MARGIN, PREVIEW_RADIUS - PREVIEW_MINIMAP_MARGIN * 2) end
	GTA3HUD.radar.DrawFrame(x, y, PREVIEW_RADIUS, colour, frame)
	x, y = x + PREVIEW_RADIUS * .5, y + PREVIEW_RADIUS * .5
	GTA3HUD.radar.DrawNorth(x, y, PREVIEW_RADIUS, 0, 1)
	GTA3HUD.radar.DrawCenter(x, y, 1, center)
end
