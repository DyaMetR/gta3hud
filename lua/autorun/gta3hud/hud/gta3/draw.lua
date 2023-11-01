
if SERVER then return end

local ATLAS1 = GTA3HUD.GTA3.ATLAS1 -- import Font 1 atlas
local ATLAS1_OUTLINED = GTA3HUD.GTA3.ATLAS1_OUTLINED -- import outlined Font 1 atlas
local ATLAS2_OUTLINED = GTA3HUD.GTA3.ATLAS2_OUTLINED -- import outlined Font 2 atlas
local FONT1 = GTA3HUD.GTA3.FONT1 -- import Font 1
local FONT2 = GTA3HUD.GTA3.FONT2 -- import Font 2

local TIME_FORMAT = '%02d'
local HEALTH_FORMAT = '%03d'
local MONEY_FORMAT = '$%08d'
local NEGATIVE_MONEY_FORMAT = '-$%07d'

local WEAPON_FRAME_WIDTH, WEAPON_FRAME_HEIGHT = 86, 90
local FRAME_MARGIN, AMMO_PANEL_HEIGHT, AMMO_FORMAT = 2, 18, '%s-%s'

-- [[ Textures ]] --
local WEAPON_FRAME_DEFAULT, WEAPON_FRAME_PS2 = Material('gta3hud/gta3/weapon.png'), Material('gta3hud/gta3/ps2/weapon.png')

--[[------------------------------------------------------------------
	Draws the time indicator.
  @param {number} hour
	@param {number} minutes
  @param {number} x
  @param {number} y
  @param {Color} colour
  @param {boolean} is it outlined
	@param {number} skin
  @return {number} width
  @return {number} height
]]--------------------------------------------------------------------
function GTA3HUD.GTA3.DrawTime(hour, minutes, x, y, colour, scale, outline)
	scale = scale or 1
	local atlas = ATLAS1
	if outline then atlas = ATLAS1_OUTLINED end
	local w, h = FONT1:DrawText(string.format(TIME_FORMAT, minutes), x, y, colour, 1, scale, TEXT_ALIGN_RIGHT, nil, nil, nil, atlas)
	w = w + (16 + 2) * scale
	atlas:Draw(':', x - w, y + scale, colour, scale)
	w = w + 2 * scale
	w = w + FONT1:DrawText(string.format(TIME_FORMAT, hour), x - w, y, colour, 1, scale, TEXT_ALIGN_RIGHT, nil, nil, nil, atlas)
	return w, h
end

--[[------------------------------------------------------------------
	Draws the money indicator.
  @param {number} money
  @param {number} x
  @param {number} y
  @param {Color} colour
  @param {number} scale
	@param {boolean} is it outlined
  @return {number} width
  @return {number} height
]]--------------------------------------------------------------------
function GTA3HUD.GTA3.DrawMoney(money, x, y, colour, scale, outline)
	local format = MONEY_FORMAT
	if money < 0 then
		money = math.abs(money)
		format = NEGATIVE_MONEY_FORMAT
	end
	local atlas
	if outline then atlas = ATLAS1_OUTLINED end
  return FONT1:DrawText(string.format(format, money), x, y, colour, 1, scale or 1, TEXT_ALIGN_RIGHT, nil, nil, nil, atlas)
end

--[[------------------------------------------------------------------
	Draws the health indicator.
  @param {number} health
  @param {number} x
  @param {number} y
  @param {Color} colour
  @param {number} scale
	@param {boolean} should the heart be hidden
	@param {boolean} is it outlined
  @return {number} width
  @return {number} height
]]--------------------------------------------------------------------
function GTA3HUD.GTA3.DrawHealth(health, x, y, colour, scale, blink, outline)
	scale = scale or 1
	local atlas = ATLAS1
	if outline then atlas = ATLAS1_OUTLINED end
  local w, h = FONT1:DrawText(string.format(HEALTH_FORMAT, health), x, y, colour, 1, scale, TEXT_ALIGN_RIGHT, nil, nil, nil, atlas)
	w = w + (26 + 3) * scale
  if not blink then atlas:Draw('heart', x - w, y, colour, scale, nil, nil, nil, atlas) end
  return w, h
end

--[[------------------------------------------------------------------
	Draws the armour indicator.
  @param {number} armour
  @param {number} x
  @param {number} y
  @param {Color} colour
  @param {number} scale
	@param {boolean} should the shield be hidden
	@param {boolean} is it outlined
  @return {number} width
  @return {number} height
]]--------------------------------------------------------------------
function GTA3HUD.GTA3.DrawArmour(armour, x, y, colour, scale, blink, outline)
	scale = scale or 1
	local atlas = ATLAS1
	if outline then atlas = ATLAS1_OUTLINED end
  local w, h = FONT1:DrawText(string.format(HEALTH_FORMAT, armour), x, y, colour, 1, scale, TEXT_ALIGN_RIGHT, nil, nil, nil, atlas)
  w = w + (26 + 1) * scale
  if not blink then atlas:Draw('shield', x - w, y, colour, scale) end
  return w, h
end

--[[------------------------------------------------------------------
	Draws the wanted level.
	@param {number} stars
	@param {number} x
	@param {number} y
	@param {Color} colour
	@param {number} scale
	@param {boolean} is it outlined
]]--------------------------------------------------------------------
function GTA3HUD.GTA3.DrawStars(stars, x, y, colour, scale, outline)
	scale = scale or 1
	local atlas = ATLAS1
	if outline then atlas = ATLAS1_OUTLINED end
	for i=1, stars do
		atlas:Draw('star', x - 30 * scale * (i - 1), y, colour, scale, TEXT_ALIGN_RIGHT)
	end
end

--[[------------------------------------------------------------------
	Draws the weapon panel.
	@param {Weapon} weapon
	@param {table} icon database
	@param {number} x
	@param {number} y
	@param {Color} colour
	@param {Color} ammunition colour
	@param {number} scale
	@param {boolean} show the alternate variant
	@param {boolean} disable render scissoring
]]--------------------------------------------------------------------
function GTA3HUD.GTA3.DrawWeapon(weapon, database, x, y, colour, ammoColour, scale, alternate, noScissor)
	local w, h = WEAPON_FRAME_WIDTH * scale, WEAPON_FRAME_HEIGHT * scale
	x = x - w

	-- draw weapon icon
	local innerw = h - (AMMO_PANEL_HEIGHT / 64) * h
	local icoh = h
	if not noScissor then render.SetScissorRect(x + FRAME_MARGIN * scale, y + FRAME_MARGIN * scale, x + w - FRAME_MARGIN * scale, y + innerw, true) end
	if not database:FindWeaponIcon(weapon) then icoh = innerw end
	database:DrawWeaponIcon(weapon, x, y, w, icoh, colour)
	if not noScissor then render.SetScissorRect(0, 0, 0, 0, false) end

	-- draw frame
	local frame = WEAPON_FRAME_DEFAULT
	if alternate then frame = WEAPON_FRAME_PS2 end
	surface.SetMaterial(frame)
	surface.SetDrawColor(colour)
	surface.DrawTexturedRect(x, y, w, h)

	-- draw ammunition
	local primary, clip, reserve = GTA3HUD.ammo.Primary()
	local secondary, alt = GTA3HUD.ammo.Secondary()
	local ammo = clip
	if not clip then return end
	if reserve then ammo = string.format(AMMO_FORMAT, reserve, clip) end
	FONT2:DrawText(ammo, x + w * .5, y + 66 * scale, ammoColour, 0, scale / 4, TEXT_ALIGN_CENTER, nil, 4, -1)
	if not secondary then return end
	FONT2:DrawText(alt, x + 8 * scale, y + 8 * scale, color_black, 0, scale / 4, nil, nil, 4, -1)
	FONT2:DrawText(alt, x + 6 * scale, y + 6 * scale, colour, 0, scale / 4, nil, nil, 4, -1)
end

--[[------------------------------------------------------------------
	Draws the wasted label.
	@param {string} label contents
	@param {number} x
	@param {number} y
	@param {Color} colour
	@param {number} shadow offset
	@param {Color} shadow colour
	@param {number} transparency
	@param {number} scale
	@param {TEXT_ALIGN_} text alignment
	@param {boolean} is it outlined
]]--------------------------------------------------------------------
function GTA3HUD.GTA3.DrawWasted(label, x, y, colour, shadowPos, shadowCol, alpha, scale, align, outline)
	alpha = alpha or 1
	scale = (scale or 1) * 2
	align = align or TEXT_ALIGN_RIGHT
	local atlas
	if outline then atlas = ATLAS1_OUTLINED end
	surface.SetAlphaMultiplier(alpha)
	if not outline then FONT1:DrawText(label, x + shadowPos * scale, y + shadowPos * scale, shadowCol, 1, scale, align, TEXT_ALIGN_BOTTOM, 6, -12) end
	FONT1:DrawText(label, x, y, colour, 1, scale, align, TEXT_ALIGN_BOTTOM, 6, -12, atlas)
	surface.SetAlphaMultiplier(1)
end

--[[------------------------------------------------------------------
	Draws a stat label, leaving space on the right for the actual stat.
	@param {string} label
	@param {number} x
	@param {number} y
	@param {Color} colour
	@param {number} shadow offset
	@param {Color} shadow colour
	@param {number} scale
	@param {boolean} is it outlined
]]--------------------------------------------------------------------
local STAT_LABEL_MARGIN = 80
function GTA3HUD.GTA3.DrawStatLabel(label, x, y, colour, shadowPos, shadowCol, scale, outline)
	scale = scale or 1
	x = x - STAT_LABEL_MARGIN * scale
	local atlas
	if outline then atlas = ATLAS1_OUTLINED end
	if not outline then FONT1:DrawText(label, x + shadowPos * scale, y + shadowPos * scale, shadowCol, 1, scale, TEXT_ALIGN_RIGHT) end
	FONT1:DrawText(label, x, y, colour, 1, scale, TEXT_ALIGN_RIGHT, nil, nil, nil, atlas)
end

--[[------------------------------------------------------------------
	Draws a progress bar stat.
	@param {string} label
	@param {number} progress
	@param {number} x
	@param {number} y
	@param {Color} colour
	@param {number} shadow offset
	@param {Color} shadow colour
	@param {number} scale
	@param {boolean} is it outlined
]]--------------------------------------------------------------------
local STAT_PROGRESS_WIDTH, STAT_PROGRESS_HEIGHT, STAT_PROGRESS_HORIZONTAL_MARGIN, STAT_PROGRESS_VERTICAL_MARGIN = 67, 16, 3, 13
local background = Color(0, 0, 0)
function GTA3HUD.GTA3.DrawProgressStat(label, value, x, y, colour, shadowPos, shadowCol, scale, outline)
	scale = scale or 1
	if label then GTA3HUD.GTA3.DrawStatLabel(label, x, y, colour, shadowPos, shadowCol, scale, outline) end
	local w, h = STAT_PROGRESS_WIDTH * scale, STAT_PROGRESS_HEIGHT * scale
	x = x - w + STAT_PROGRESS_HORIZONTAL_MARGIN * scale
	y = y + STAT_PROGRESS_VERTICAL_MARGIN * scale
	background.r = colour.r * .5
	background.g = colour.g * .5
	background.b = colour.b * .5
	if outline then
		draw.RoundedBox(0, x - scale * 2, y - scale * 2, w + scale * 4, h + scale * 4, shadowCol)
	else
		draw.RoundedBox(0, x + shadowPos * scale, y + shadowPos * scale, w, h, shadowCol)
	end
	draw.RoundedBox(0, x, y, w, h, background)
	draw.RoundedBox(0, x, y, w * value, h, colour)
end

--[[------------------------------------------------------------------
	Draws a text based stat. Label will only show if text is under 4 characters.
	@param {string} label
	@param {string} text to display
	@param {number} x
	@param {number} y
	@param {Color} colour
	@param {number} shadow offset
	@param {Color} shadow colour
	@param {number} scale
	@param {boolean} is it outlined
]]--------------------------------------------------------------------
function GTA3HUD.GTA3.DrawTextStat(label, text, x, y, colour, shadowPos, shadowCol, scale, outline)
	scale = scale or 1
	local atlas
	if outline then atlas = ATLAS1_OUTLINED end
	if label and string.len(text) <= 4 then GTA3HUD.GTA3.DrawStatLabel(label, x, y, colour, shadowPos, shadowCol, scale, outline) end
	if not outlined then FONT1:DrawText(text, x + shadowPos * scale, y + shadowPos * scale, shadowCol, 1, scale, TEXT_ALIGN_RIGHT) end
	FONT1:DrawText(text, x, y, colour, 1, scale, TEXT_ALIGN_RIGHT, nil, nil, nil, atlas)
end

--[[------------------------------------------------------------------
	Draws all registered statistics.
	@param {number} x
	@param {number} y
	@param {Color} colour
	@param {Color} alternative colour
	@param {number} shadow offset
	@param {Color} shadow colour
	@param {number} scale
	@param {boolean} is it outlined
]]--------------------------------------------------------------------
local MARGIN = 33
local auxpow = GTA3HUD.stats.CreateProgressBar('Valve_Hud_AUX_POWER', 1, true)
function GTA3HUD.GTA3.DrawStats(x, y, colour, altColour, shadowPos, shadowCol, scale, outline)
	GTA3HUD.stats.Flush()
	GTA3HUD.stats.RunHook()

	-- support for vanilla HEV
	local suit = hook.Run('GTA3HUD_GetSuitPower') or (LocalPlayer():GetSuitPower() * .01)
	if suit < 1 then
		auxpow.value = suit
		GTA3HUD.stats.Add(auxpow)
	end

	-- render
	for _, stat in pairs(GTA3HUD.stats.All()) do
		local col = colour
		if stat.colour then
			if isbool(stat.colour) then
				col = altColour
			else
				col = stat.colour
			end
		end
		local label = string.lower(language.GetPhrase(stat.label or ''))
		if stat.type == GTA3HUD.stats.STAT_TEXT then
			GTA3HUD.GTA3.DrawTextStat(label, string.lower(stat.value), x, y, col, shadowPos, shadowCol, scale, outline)
		elseif stat.type == GTA3HUD.stats.STAT_PROGRESS then
			GTA3HUD.GTA3.DrawProgressStat(label, string.lower(stat.value), x, y, col, shadowPos, shadowCol, scale, outline)
		end
		y = y + MARGIN * scale
	end
end

--[[------------------------------------------------------------------
  Draws the task result label.
	@param {number} x
	@param {number} y
	@param {table} rows of text
	@param {number} alpha
	@param {Color} colour
	@param {number} shadow offset
	@param {Color} shadow colour
	@param {number} scale
	@param {boolean} outline
]]--------------------------------------------------------------------
function GTA3HUD.GTA3.DrawTaskResult(x, y, lines, alpha, colour, shadowPos, shadowCol, scale, outline)
	scale = scale * 2
	local atlas
	if outline then atlas = ATLAS1_OUTLINED end
	surface.SetAlphaMultiplier(alpha)
	for _, line in pairs(lines) do
		line = language.GetPhrase(line)
		if not outline then FONT1:DrawText(line, x + shadowPos * scale, y + shadowPos * scale, shadowCol, 1, scale, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 6, -12) end
		local _, h = FONT1:DrawText(line, x, y, colour, 1, scale, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 6, -12, atlas)
		y = y + h
	end
	surface.SetAlphaMultiplier(1)
end

--[[------------------------------------------------------------------
  Draws the task message label.
	@param {number} x
	@param {number} y
	@param {table} message
	@param {string} message raw string
	@param {Color} default colour
	@param {Color} alternative colour
	@param {number} shadow offset
	@param {Color} shadow colour
	@param {number} scale
	@param {boolean} outline
]]--------------------------------------------------------------------
function GTA3HUD.GTA3.DrawTaskMessage(x, y, message, stringified, defaultColour, altColour, shadowPos, shadowCol, scale, outline)
	scale = scale or 1
	local atlas
	if outline then atlas = ATLAS2_OUTLINED end
	x = x - (FONT2:GetTextSize(stringified) * scale * .3) * .5
	if not outline then FONT2:DrawText(stringified, x + shadowPos * scale, y + shadowPos * scale, shadowCol, 1, scale * .3, nil, TEXT_ALIGN_BOTTOM) end
	local colour = defaultColour
	if isbool(message[1]) and message[1] then colour = altColour end
	for _, text in pairs(message) do
		if not isstring(text) then continue end
		x = x + FONT2:DrawText(text, x, y, colour, 1, scale * .3, nil, TEXT_ALIGN_BOTTOM, nil, nil, atlas) + (scale * .6)
	end
end

--[[------------------------------------------------------------------
  Draws a hint box.
	@param {string} hint
	@param {number} x
	@param {number} y
	@param {number} w
	@param {number} line height
	@param {Color} text colour
	@param {Color} background colour
	@param {number} scale
	@param {boolean} is it outlined
	@deprecated
]]--------------------------------------------------------------------
local lastHint, lines = '', {}
function GTA3HUD.GTA3.DrawHint(text, x, y, w, h, colour, background, scale, outline)
	scale = (scale or 1) * .4

	-- get atlas
	local atlas = ATLAS2
	if outline then atlas = ATLAS2_OUTLINED end

	-- fetch lines
	if text ~= lastHint then
		lines = GTA3HUD.draw.GetLinesInBox(FONT2, text, w / scale)
		lastHint = text
	end

	-- draw background
	draw.RoundedBox(0, x, y, w, h * #lines, background)

	-- draw lines
	x = x + 5 * scale
	for _, line in pairs(lines) do
		local w, h = FONT2:DrawText(line, x, y, colour, 1, scale, nil, nil, nil, nil, atlas)
		y = y + h
	end
end
