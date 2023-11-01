
if SERVER then return end

local FORMAT_TIME, FORMAT_MONEY, FORMAT_NEGATIVE_MONEY = '%02d:%02d', '$%08d', '-$%07d'
local STAR_GLYPH = '*'
local BAR_OUTLINE, TEXT_OUTLINE = 4, 4
local NEGATIVE_MONEY_COLOUR = Color(170, 40, 40)

local WEAPON_FRAME = Material('gta3hud/sa/weapon.png')
local WEAPON_FRAME_WIDTH, WEAPON_FRAME_HEIGHT = 80, 98
local AMMO_FORMAT, AMMO_FORMAT_ALT = '%s-%s', '%s-%s | %s'

-- [[ Fonts ]] --
local FONT1, FONT1_PREVIEW = GTA3HUD.fonts.Create('sa_status', 'Grand Theft Display Widespace', 33)
local FONT2, FONT2_PREVIEW = GTA3HUD.fonts.Create('sa_stars', 'Grand Theft Display Widespace', 38)
local FONT3, FONT3_PREVIEW = GTA3HUD.fonts.Create('sa_wasted', 'Beckett', 96)
local FONT4, FONT4_PREVIEW = GTA3HUD.fonts.Create('sa_ammo', 'Futura LT', 20)
local FONT5, FONT5_PREVIEW = GTA3HUD.fonts.Create('sa_stats', 'BankGothic Md BT', 32)
local FONT6, FONT6_PREVIEW = GTA3HUD.fonts.Create('sa_taskresult', 'Pricedown Theft Auto', 66)
local FONT7, FONT7_PREVIEW = GTA3HUD.fonts.Create('sa_taskmessage', 'Futura LT', 26)

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
function GTA3HUD.SA.DrawTime(hour, minutes, x, y, colour, scale, preview)
	scale = scale or 1
	x = x - 2 * scale
	y = y - 12 * scale
	local font = FONT1
	if preview then font = FONT1_PREVIEW end
	draw.SimpleTextOutlined(string.format(FORMAT_TIME, hour, minutes), font, x, y, colour, TEXT_ALIGN_RIGHT, nil, scale * TEXT_OUTLINE, color_black)
end

--[[------------------------------------------------------------------
	Draws a progress bar.
  @param {number} percentage
  @param {number} x
  @param {number} y
  @param {number} width
  @param {number} height
  @param {Color} colour
  @param {number} scale
]]--------------------------------------------------------------------
local background = Color(0, 0, 0)
function GTA3HUD.SA.DrawBar(value, x, y, w, h, colour, scale)
  scale = scale or 1
  x = x - w
  background.a = colour.a
  background.r = colour.r * .5
  background.g = colour.g * .5
  background.b = colour.b * .5
  draw.RoundedBox(0, x, y, w, h, color_black)
  draw.RoundedBox(0, x + BAR_OUTLINE * scale, y + BAR_OUTLINE * scale, w - (BAR_OUTLINE * 2 * scale), h - (BAR_OUTLINE * 2 * scale), background)
  draw.RoundedBox(0, x + BAR_OUTLINE * scale, y + BAR_OUTLINE * scale, (w - (BAR_OUTLINE * 2 * scale)) * math.min(value, 1), h - (BAR_OUTLINE * 2 * scale), colour)
end

--[[------------------------------------------------------------------
	Draws the money indicator.
  @param {number} money
  @param {number} x
  @param {number} y
  @param {Color} colour
  @param {number} scale
	@param {boolean|nil} show preview font
]]--------------------------------------------------------------------
function GTA3HUD.SA.DrawMoney(money, x, y, colour, scale, preview)
	scale = scale or 1
	x = x - 2 * scale
	y = y - 12 * scale
	local font = FONT1
	if preview then font = FONT1_PREVIEW end
	local format = FORMAT_MONEY
	if money < 0 then
		format = FORMAT_NEGATIVE_MONEY
		colour = NEGATIVE_MONEY_COLOUR
	end
	draw.SimpleTextOutlined(string.format(format, math.abs(money)), font, x, y, colour, TEXT_ALIGN_RIGHT, nil, scale * TEXT_OUTLINE, color_black)
end

--[[------------------------------------------------------------------
	Draws the wanted level.
	@param {number} active stars
	@param {number} x
	@param {number} y
	@param {Color} colour
  @param {number} background opacity
	@param {number} scale
	@param {boolean|nil} show preview font
	@param {boolean} should the active stars be blinking
]]--------------------------------------------------------------------
function GTA3HUD.SA.DrawStars(stars, x, y, colour, opacity, scale, blink, preview)
  scale = scale or 1
	local font = FONT2
	if preview then font = FONT2_PREVIEW end
  for i=1, 6 do
		if stars >= i then
			if blink then continue end
			draw.SimpleTextOutlined(STAR_GLYPH, font, x - 33 * (i - 1) * scale, y, colour, TEXT_ALIGN_RIGHT, nil, scale * 2, color_black)
		else
			surface.SetAlphaMultiplier(opacity)
			draw.SimpleText(STAR_GLYPH, font, x - 33 * (i - 1) * scale, y, color_black, TEXT_ALIGN_RIGHT)
			surface.SetAlphaMultiplier(1)
		end
	end
end

--[[------------------------------------------------------------------
	Draws the weapon panel.
	@param {Weapon} weapon
	@param {table} weapon icons database
	@param {number} x
	@param {number} y
	@param {Color} colour
	@param {Color} weapon icon colour
	@param {Color} ammunition colour
	@param {number} scale
	@param {boolean|nil} show preview font
]]--------------------------------------------------------------------
function GTA3HUD.SA.DrawWeapon(weapon, database, x, y, colour, iconColour, ammoColour, scale, preview)
	scale = scale or 1
	local w, h = WEAPON_FRAME_WIDTH * scale, WEAPON_FRAME_HEIGHT * scale
	x = x - w
	local font = FONT4
	if preview then font = FONT4_PREVIEW end
	surface.SetDrawColor(colour)
	surface.SetMaterial(WEAPON_FRAME)
	surface.DrawTexturedRect(x, y, w, h)
	database:DrawWeaponIcon(weapon, x - scale, y, w, h, iconColour)
	local primary, clip, reserve = GTA3HUD.ammo.Primary()
	local secondary, alt = GTA3HUD.ammo.Secondary()
	if not primary and not secondary then return end
	local ammo = clip
	if secondary then
		ammo = string.format(AMMO_FORMAT_ALT, reserve, clip or 0, alt)
	elseif reserve then
		ammo = string.format(AMMO_FORMAT, reserve, clip)
	end
	draw.SimpleTextOutlined(ammo, font, x + w * .5, y + 77 * scale, ammoColour, TEXT_ALIGN_CENTER, nil, 2 * scale, color_black)
end

--[[------------------------------------------------------------------
	Draws the wasted label.
	@param {string} label contents
	@param {number} x
	@param {number} y
	@param {Color} colour
	@param {number} transparency
	@param {number} scale
	@param {boolean|nil} show preview font
]]--------------------------------------------------------------------
function GTA3HUD.SA.DrawWasted(label, x, y, colour, alpha, scale, preview)
	scale = scale or 1
	alpha = alpha or 1
	local font = FONT3
	if preview then font = FONT3_PREVIEW end
	surface.SetAlphaMultiplier(alpha)
	draw.SimpleTextOutlined(label, font, x, y, colour, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, scale * 4, color_black)
	surface.SetAlphaMultiplier(1)
end

--[[------------------------------------------------------------------
	Draws a statistic label.
	@param {string} label
	@param {number} x
	@param {number} y
	@param {Color} colour
	@param {number} scale
	@param {boolean|nil} show preview font
]]--------------------------------------------------------------------
local STAT_LABEL_MARGIN = 156
function GTA3HUD.SA.DrawStatLabel(label, x, y, colour, scale, preview)
	scale = scale or 1
	local font = FONT5
	if preview then font = FONT5_PREVIEW end
	draw.SimpleTextOutlined(language.GetPhrase(label), font, x - STAT_LABEL_MARGIN * scale, y, colour, TEXT_ALIGN_RIGHT, nil, scale * 3, color_black)
end

--[[------------------------------------------------------------------
	Draws a text based statistic.
	@param {string} label
	@param {string} text to display
	@param {number} x
	@param {number} y
	@param {Color} colour
	@param {number} scale
	@param {boolean|nil} show preview font
]]--------------------------------------------------------------------
function GTA3HUD.SA.DrawTextStat(label, text, x, y, colour, scale, preview)
	local font = FONT5
	if preview then font = FONT5_PREVIEW end
	if label then GTA3HUD.SA.DrawStatLabel(label, x, y, colour, scale, preview) end
	draw.SimpleTextOutlined(text, font, x, y, colour, TEXT_ALIGN_RIGHT, nil, scale * 3, color_black)
end

--[[------------------------------------------------------------------
	Draws a text based statistic.
	@param {string} label
	@param {number} value
	@param {number} x
	@param {number} y
	@param {Color} colour
	@param {number} scale
	@param {boolean|nil} show preview font
]]--------------------------------------------------------------------
local STAT_PROGRESS_WIDTH, STAT_PROGRESS_HEIGHT, STAT_PROGRESS_HORIZONTAL_MARGIN, STAT_PROGRESS_VERTICAL_MARGIN = 106, 16, 2, 10
function GTA3HUD.SA.DrawProgressStat(label, value, x, y, colour, scale, preview)
	if label then GTA3HUD.SA.DrawStatLabel(label, x, y, colour, scale, preview) end
	GTA3HUD.SA.DrawBar(value, x + STAT_PROGRESS_HORIZONTAL_MARGIN * scale, y + STAT_PROGRESS_VERTICAL_MARGIN * scale, STAT_PROGRESS_WIDTH * scale, STAT_PROGRESS_HEIGHT * scale, colour, scale)
end

--[[------------------------------------------------------------------
	Draws all registered statistics.
	@param {number} x
	@param {number} y
	@param {Color} colour
	@param {Color} alternative colour
	@param {number} scale
]]--------------------------------------------------------------------
local MARGIN = 43
function GTA3HUD.SA.DrawStats(x, y, colour, altColour, scale)
	GTA3HUD.stats.Flush()
	GTA3HUD.stats.RunHook()
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
			GTA3HUD.SA.DrawTextStat(stat.label, stat.value, x, y, col, scale)
		elseif stat.type == GTA3HUD.stats.STAT_PROGRESS then
			GTA3HUD.SA.DrawProgressStat(stat.label, stat.value, x, y, col, scale)
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
	@param {Color} title colour
	@param {Color} subtitle colour
	@param {number} scale
	@param {boolean} is it a preview
]]--------------------------------------------------------------------
local MARGIN = 48
function GTA3HUD.SA.DrawTaskResult(x, y, lines, alpha, colour, colour2, scale, preview)
	local font = FONT6
	if preview then font = FONT6_PREVIEW end
	surface.SetAlphaMultiplier(alpha)
	for i, line in pairs(lines) do
		line = language.GetPhrase(line)
		local col = colour
		if i > 1 then col = colour2 end
		draw.SimpleTextOutlined(line, font, x, y, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, scale * 3, color_black)
		y = y + MARGIN * scale
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
	@param {boolean} preview
]]--------------------------------------------------------------------
function GTA3HUD.SA.DrawTaskMessage(x, y, message, stringified, defaultColour, altColour, scale, preview)
	local font = FONT7
	if preview then font = FONT7_PREVIEW end
	surface.SetFont(font)
	x = x - surface.GetTextSize(stringified) * .5
	local colour = defaultColour
	for _, text in pairs(message) do
		if not isstring(text) then
			if not text or text == NULL then colour = defaultColour continue end
			if isbool(text) and text then colour = altColour continue end
			colour = text
			continue
		end
		draw.SimpleTextOutlined(text, font, x, y, colour, nil, TEXT_ALIGN_BOTTOM, 2 * scale, color_black)
		x = x + surface.GetTextSize(text)
	end
end
