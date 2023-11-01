
if SERVER then return end

local HUDNUMBERS = GTA3HUD.LCS.HUDNUMBERS -- import HUD numbers
local BIGTEXT = GTA3HUD.LCS.BIGTEXT -- import pricedown
local GAMETEXT = GTA3HUD.LCS.GAMETEXT -- import regular text
local HUDATLAS = GTA3HUD.LCS.HUDATLAS -- import HUD numbers atlas

local TIME_FORMAT = '%02d:%02d'
local MONEY_FORMAT = '$%08d'

local WEAPON_FRAME = Material('gta3hud/lcs/weapon.png')
local WEAPON_FRAME_WIDTH, WEAPON_FRAME_HEIGHT = 128, 128
local WEAPON_MARGIN = 36
local AMMO_FORMAT = '%s-%s'

-- format the aux. power label so only the first letter of each word is upper case
local LABEL_AUXPOW = language.GetPhrase('Valve_Hud_AUX_POWER')
local pieces = string.Split(LABEL_AUXPOW, ' ')
LABEL_AUXPOW = ''
for i, piece in pairs(pieces) do
	LABEL_AUXPOW = LABEL_AUXPOW .. utf8.sub(piece, 1, 1) .. string.lower(utf8.sub(piece, 2))
	if i < #pieces then LABEL_AUXPOW = LABEL_AUXPOW .. ' ' end
end

--[[------------------------------------------------------------------
	Draws the time indicator.
  @param {number} hour
	@param {number} minutes
  @param {number} x
  @param {number} y
  @param {Color} colour
  @param {number} scale
  @return {number} width
  @return {number} height
]]--------------------------------------------------------------------
function GTA3HUD.LCS.DrawTime(hour, minutes, x, y, colour, scale)
	scale = scale or 1
	x = x - 2 * scale
	y = y - 12 * scale
	HUDNUMBERS:DrawText(string.format(TIME_FORMAT, hour, minutes), x, y, colour, 4, scale, TEXT_ALIGN_RIGHT, nil, -7.25, -1)
end

--[[------------------------------------------------------------------
	Draws a progress bar.
  @param {number} value
  @param {number} x
  @param {number} y
  @param {number} width
  @param {number} height
  @param {Color} colour
  @param {number} scale
	@param {boolean} render the extended icon
]]--------------------------------------------------------------------
local OVERHEAL_GLYPH = '+'
local BAR_TEXTURE, BAR_TEXTURE_PS2 = Material('gta3hud/lcs/bar.png'), Material('gta3hud/lcs/ps2/bar.png')
local background = Color(255, 255, 255)
function GTA3HUD.LCS.DrawBar(value, x, y, w, h, colour, scale, extended, alternate)
	value = math.Clamp(value, 0, 1)
	w = w * scale
	h = h * scale
	x = x - w
  local barw = math.floor(w * value)

	-- change background colour
	background.r = colour.r * .5
	background.g = colour.g * .5
	background.b = colour.b * .5
	background.a = colour.a

	-- background
	local texture = BAR_TEXTURE
	if alternate then texture = BAR_TEXTURE_PS2 end
	surface.SetMaterial(texture)
	surface.SetDrawColor(background)
	surface.DrawTexturedRectUV(x + barw, y, (w - barw), h, barw / w, 0, 1, 1)

	-- foreground
	surface.SetDrawColor(colour)
	surface.DrawTexturedRectUV(x, y, barw, h, 0, 0, barw / w, 1)

	-- extended icon
	if not extended then return end
	GTA3HUD.LCS.GAMEATLAS:Draw(OVERHEAL_GLYPH, x - 16 * scale, y - 10 * scale, color_white, scale * 1.25)
end

--[[------------------------------------------------------------------
	Draws the weapon panel.
	@param {Weapon} weapon
	@param {table} weapon icon database
	@param {number} x
	@param {number} y
	@param {Color} colour
	@param {Color} weapon icon colour
	@param {Color} ammunition colour
	@param {number} scale
]]--------------------------------------------------------------------
function GTA3HUD.LCS.DrawWeapon(weapon, database, x, y, colour, iconColour, ammoColour, scale)
	scale = scale or 1
	local w = WEAPON_FRAME_WIDTH * scale
	x = x - w + WEAPON_MARGIN * scale
	surface.SetDrawColor(colour)
	surface.SetMaterial(WEAPON_FRAME)
	surface.DrawTexturedRect(x, y, w, WEAPON_FRAME_HEIGHT * scale)
	database:DrawWeaponIcon(weapon, x - scale * 2, y - 4 * scale, 94 * scale, 94 * scale, iconColour)

	-- draw ammunition
	local primary, clip, reserve = GTA3HUD.ammo.Primary()
	local secondary, alt = GTA3HUD.ammo.Secondary()
	if not primary and not secondary then return end
	local ammo = clip
	if reserve then ammo = string.format(AMMO_FORMAT, reserve, clip) end
	GTA3HUD.LCS.GAMETEXT:DrawText(ammo, x + 48 * scale, y + 78 * scale, ammoColour, 0, scale / 2, TEXT_ALIGN_CENTER)
	if not secondary then return end
	GTA3HUD.LCS.GAMETEXT:DrawText(alt, x + 10 * scale, y + 10 * scale, ammoColour, 0, scale / 2)
end

--[[------------------------------------------------------------------
	Draws the money indicator.
  @param {number} money
  @param {number} x
  @param {number} y
  @param {Color} colour
  @param {number} scale
]]--------------------------------------------------------------------
function GTA3HUD.LCS.DrawMoney(money, x, y, colour, scale)
	return HUDNUMBERS:DrawText(string.format(MONEY_FORMAT, money), x, y, colour, 4, scale, TEXT_ALIGN_RIGHT, nil, -7.25, -1)
end

--[[------------------------------------------------------------------
	Draws the wanted level.
  @param {number} stars
  @param {number} x
  @param {number} y
  @param {Color} colour
  @param {number} scale
]]--------------------------------------------------------------------
function GTA3HUD.LCS.DrawStars(stars, x, y, colour, scale)
	if stars <= 0 then return end
	for i=1, stars do
		local w = HUDATLAS:Draw('star', x, y, colour, scale, TEXT_ALIGN_RIGHT)
		x = x - w - 2 * scale
	end
end

--[[------------------------------------------------------------------
	Draws the wasted label.
	@param {string} label contents
	@param {number} x
	@param {number} y
	@param {Color} colour
	@param {number} transparency
	@param {number} scale
]]--------------------------------------------------------------------
function GTA3HUD.LCS.DrawWasted(label, x, y, colour, alpha, scale)
	scale = scale or 1
	alpha = alpha or 1
	scale = scale * 2
	label = language.GetPhrase(label)
	surface.SetAlphaMultiplier(alpha)
	GTA3HUD.LCS.BIGTEXT:DrawText(label, x + 2 * scale, y + 2 * scale, color_black, 1, scale, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	GTA3HUD.LCS.BIGTEXT:DrawText(label, x, y, colour, 1, scale, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	surface.SetAlphaMultiplier(1)
end

--[[------------------------------------------------------------------
	Draws a progress bar statistic.
	@param {string} label contents
	@param {number} value
	@param {number} x
	@param {number} y
	@param {Color} colour
	@param {number} scale
]]--------------------------------------------------------------------
local STAT_LABEL_MARGIN, STAT_PROGRESS_WIDTH, STAT_PROGRESS_HEIGHT, STAT_PROGRESS_MARGIN = 120, 116, 32, 6
local background = Color(0, 0, 0)
function GTA3HUD.LCS.DrawProgressStat(label, value, x, y, colour, scale)
	scale = scale or 1
	GTA3HUD.LCS.GAMETEXT:DrawText(language.GetPhrase(label), x - STAT_LABEL_MARGIN * scale, y, colour, 1, scale, TEXT_ALIGN_RIGHT)
	local w, h = STAT_PROGRESS_WIDTH * scale, STAT_PROGRESS_HEIGHT * scale
	x = x - w
	y = y + STAT_PROGRESS_MARGIN * scale
	background.r = colour.r * .5
	background.g = colour.g * .5
	background.b = colour.b * .5
	draw.RoundedBox(0, x, y, w, h, color_black)
	x = x + scale * 2
	y = y + scale * 2
	w = w - scale * 4
	h = h - scale * 4
	draw.RoundedBox(0, x, y, w, h, background)
	draw.RoundedBox(0, x, y, w * value, h, colour)
end

--[[------------------------------------------------------------------
	Draws all registered statistics.
	@param {number} x
	@param {number} y
	@param {Color} colour
	@param {Color} alternative colour
	@param {number} scale
]]--------------------------------------------------------------------
local MARGIN = 48
local TEXT_STAT_FORMAT = '%s %s'
local auxpow = GTA3HUD.stats.CreateProgressBar(LABEL_AUXPOW, 1, true)
function GTA3HUD.LCS.DrawStats(x, y, colour, altColour, scale)
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
		if stat.type == GTA3HUD.stats.STAT_TEXT then
			local text = stat.value
			if stat.label then text = string.format(TEXT_STAT_FORMAT, stat.label, stat.value) end
			GAMETEXT:DrawText(language.GetPhrase(text), x, y, col, 1, scale, TEXT_ALIGN_RIGHT)
		elseif stat.type == GTA3HUD.stats.STAT_PROGRESS then
			GTA3HUD.LCS.DrawProgressStat(stat.label, stat.value, x, y, col, scale)
		end
		y = y + MARGIN * scale
	end
end

--[[------------------------------------------------------------------
	Draws the task result.
	@param {number} x
	@param {number} y
	@param {table} lines
	@param {number} opacity
	@param {Color} colour
	@param {number} scale
]]--------------------------------------------------------------------
function GTA3HUD.LCS.DrawTaskResult(x, y, lines, alpha, colour, scale)
	scale = scale * 2
	surface.SetAlphaMultiplier(alpha)
	for _, line in pairs(lines) do
		line = language.GetPhrase(line)
		BIGTEXT:DrawText(line, x + 2 * scale, y + 2 * scale, color_black, 1, scale, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		local _, h = BIGTEXT:DrawText(line, x, y, colour, 1, scale, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		y = y + h * 1.15
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
	@param {number} scale
]]--------------------------------------------------------------------
function GTA3HUD.LCS.DrawTaskMessage(x, y, message, stringified, defaultColour, altColour, scale)
	scale = scale or 1
	x = x - GAMETEXT:GetTextSize(stringified) * scale * .5
	local colour = defaultColour
	for _, text in pairs(message) do
		if not isstring(text) then
			if not text or text == NULL then colour = defaultColour continue end
			if isbool(text) and text then colour = altColour continue end
			colour = text
			continue
		end
		x = x + GAMETEXT:DrawText(text, x, y, colour, 0, scale, nil, TEXT_ALIGN_BOTTOM, nil, nil, atlas)
	end
end
