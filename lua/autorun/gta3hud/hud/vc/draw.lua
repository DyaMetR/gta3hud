
if SERVER then return end

local FONT1 = GTA3HUD.VC.FONT1 -- deprecated

-- import textures
local ATLAS1 = GTA3HUD.VC.ATLAS1
local ATLAS1_OUTLINED = GTA3HUD.VC.ATLAS1_OUTLINED
local ARBORCREST = GTA3HUD.VC.ARBORCREST
local PRICEDOWN = GTA3HUD.VC.PRICEDOWN
--local RAGEITALIC = GTA3HUD.VC.RAGEITALIC

-- status text formats
local TIME_FORMAT = '%02d'
local HEALTH_FORMAT = '%03d'
local MONEY_FORMAT = '$%08d'
local NEGATIVE_MONEY_FORMAT = '$%07d'

-- weapon panel
local WEAPON_FRAME = Material('gta3hud/vc/weapon.png')
local WEAPON_BACKGROUND = Material('gta3hud/vc/weapon_background.png')
local WEAPON_FRAME_WIDTH, WEAPON_FRAME_HEIGHT = 85, 90
local AMMO_FORMAT, AMMO_FORMAT_ALT = '%s-%s', '%s-%s(%s)'

-- weapon type detection
local AMMO_HANDGUN  = { [3] = true, [5] = true }
local AMMO_SMG			= 4
local AMMO_SHOTGUN	= 7
local AMMO_RIFLE		= 1
local AMMO_SNIPER		= { [6] = true, [13] = true, [14] = true }
local AMMO_EXPLOSIVE= { [8] = true, [9] = true, [10] = true, [11] = true }
local HOLDTYPE_MELEE		= { crowbar = true, melee = true, melee2 = true, knife = true }
local HOLDTYPE_HANDGUN	= { pistol = true, revolver = true, duel = true }
local HOLDTYPE_SMG			= 'smg'
local HOLDTYPE_SHOTGUN	= 'shotgun'
local HOLDTYPE_RIFLE		= { ar2 = true, crossbow = true }
local HOLDTYPE_LAUNCHER	= 'rpg'
local HOLDTYPE_PHYSGUN	= 'physgun'
local HOLDTYPE_THROWABLE= { grenade = true, slam = true }
local HOLDTYPE_TOOL			= 'camera'
local CLIP1_HEAVY		= 60

--[[------------------------------------------------------------------
	Draws the time indicator.
  @param {number} hour
	@param {number} minutes
  @param {number} x
  @param {number} y
  @param {Color} colour
  @param {number} scale
	@param {boolean} is it outlined
  @return {number} width
  @return {number} height
]]--------------------------------------------------------------------
function GTA3HUD.VC.DrawTime(hour, minutes, x, y, colour, scale, outlined)
	scale = scale or 1
	local atlas = ATLAS1
	if outlined then atlas = ATLAS1_OUTLINED end
	local w, h = PRICEDOWN:DrawText(string.format(TIME_FORMAT, minutes), x, y, colour, 1, scale, TEXT_ALIGN_RIGHT, nil, nil, nil, atlas)
	w = w + (16 + 3) * scale
	atlas:Draw(':b', x - w + scale, y + scale, colour, scale)
	w = w + PRICEDOWN:DrawText(string.format(TIME_FORMAT, hour), x - w, y, colour, 1, scale, TEXT_ALIGN_RIGHT, nil, nil, nil, atlas)
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
function GTA3HUD.VC.DrawMoney(money, x, y, colour, scale, outline)
	local format = MONEY_FORMAT
	if money < 0 then
		money = math.abs(money)
		format = NEGATIVE_MONEY_FORMAT
		if outline then draw.RoundedBox(0, x - 166 * scale, y + 20 * scale, 14 * scale, 8 * scale, color_black) end
		draw.RoundedBox(0, x - 165 * scale, y + 19 * scale, 12 * scale, 6 * scale, colour)
	end
	local atlas
	if outline then atlas = ATLAS1_OUTLINED end
  return PRICEDOWN:DrawText(string.format(format, money), x, y, colour, 1, scale or 1, TEXT_ALIGN_RIGHT, nil, nil, nil, atlas)
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
function GTA3HUD.VC.DrawHealth(health, x, y, colour, scale, blink, outline)
	scale = scale or 1
	local atlas =  ATLAS1
	if outline then atlas = ATLAS1_OUTLINED end
	local w, h = PRICEDOWN:DrawText(string.format(HEALTH_FORMAT, health), x, y, colour, 1, scale, TEXT_ALIGN_RIGHT, nil, nil, nil, atlas)
	w = w + (26 + 6) * scale
	if not blink then atlas:Draw('heart', x - w, y, colour, scale) end
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
function GTA3HUD.VC.DrawArmour(armour, x, y, colour, scale, blink, outline)
scale = scale or 1
local atlas = ATLAS1
if outline then atlas = ATLAS1_OUTLINED end
local w, h = PRICEDOWN:DrawText(string.format(HEALTH_FORMAT, armour), x, y, colour, 1, scale, TEXT_ALIGN_RIGHT, nil, nil, nil, atlas)
w = w + (26 + 6) * scale
if not blink then atlas:Draw('shield', x - w, y + scale, colour, scale) end
return w, h
end

--[[------------------------------------------------------------------
	Draws the wanted level.
	@param {number} active stars
	@param {number} x
	@param {number} y
	@param {Color} colour
	@param {Color} background colour
	@param {number} shadow offset
	@param {Color} shadow colour
	@param {number} scale
	@param {boolean} should the active stars be blinking
	@param {boolean} is it outlined
]]--------------------------------------------------------------------
function GTA3HUD.VC.DrawStars(stars, x, y, colour, background, shadowPos, shadowCol, scale, blink, outline)
	scale = scale or 1
	local atlas = ATLAS1
	if outline then
		atlas = ATLAS1_OUTLINED
		shadowPos = 0
	end
	for i=1, 6 do
		if stars >= i and blink then continue end
		atlas:Draw('star', x - (31 * (i - 1) - shadowPos) * scale, y + shadowPos * scale, shadowCol, scale, TEXT_ALIGN_RIGHT)
	end
	for i=1, 6 do
		local tint = background
		if stars >= i then
			if blink then continue end
			tint = colour
		end
		atlas:Draw('star', x - 31 * scale * (i - 1), y, tint, scale, TEXT_ALIGN_RIGHT)
	end
end

--[[------------------------------------------------------------------
	Guesses the type of a weapon.
	@param {Weapon} weapon
	@return {number} weapon type
]]--------------------------------------------------------------------
local lastWeapon
local cachedType = GTA3HUD.VC.WEAPON_NONE
function GTA3HUD.VC.GetWeaponType(weapon)
	if not IsValid(weapon) then return GTA3HUD.VC.WEAPON_NONE end
	if lastWeapon == weapon then return cachedType end
	local primary, secondary = weapon:GetPrimaryAmmoType(), weapon:GetSecondaryAmmoType()
	local holdtype = weapon:GetHoldType()
	if primary <= 0 and secondary > 0 then primary = secondary end
	if weapon:GetMaxClip1() > CLIP1_HEAVY then
		cachedType = GTA3HUD.VC.WEAPON_HEAVY
	elseif AMMO_HANDGUN[primary] then
		if string.len(holdtype) <= 0 or HOLDTYPE_HANDGUN[holdtype] then
			cachedType = GTA3HUD.VC.WEAPON_HANDGUN
		else
			cachedType = GTA3HUD.VC.WEAPON_SMG
		end
	elseif primary == AMMO_SMG then
		cachedType = GTA3HUD.VC.WEAPON_SMG
	elseif primary == AMMO_SHOTGUN then
		cachedType = GTA3HUD.VC.WEAPON_SHOTGUN
	elseif primary == AMMO_RIFLE then
		cachedType = GTA3HUD.VC.WEAPON_ASSAULT
	elseif AMMO_SNIPER[primary] then
		cachedType = GTA3HUD.VC.WEAPON_SNIPER
	elseif AMMO_EXPLOSIVE[primary] then
		cachedType = GTA3HUD.VC.WEAPON_HEAVY
	else
		if HOLDTYPE_MELEE[holdtype] then
			cachedType = GTA3HUD.VC.WEAPON_MELEE
		elseif HOLDTYPE_HANDGUN[holdtype] then
			cachedType = GTA3HUD.VC.WEAPON_HANDGUN
		elseif holdtype == HOLDTYPE_SMG then
			cachedType = GTA3HUD.VC.WEAPON_SMG
		elseif holdtype == HOLDTYPE_SHOTGUN then
			cachedType = GTA3HUD.VC.WEAPON_SHOTGUN
		elseif HOLDTYPE_RIFLE[holdtype] then
			cachedType = GTA3HUD.VC.WEAPON_ASSAULT
		elseif HOLDTYPE_THROWABLE[holdtype] then
			cachedType = GTA3HUD.VC.WEAPON_THROWABLE
		elseif holdtype == HOLDTYPE_LAUNCHER or (holdtype == HOLDTYPE_PHYSGUN and primary > 0) then
			cachedType = GTA3HUD.VC.WEAPON_HEAVY
		elseif holdtype == HOLDTYPE_TOOL then
			cachedType = GTA3HUD.VC.WEAPON_TOOL
		else
			cachedType = GTA3HUD.VC.WEAPON_NONE
		end
	end
	lastWeapon = weapon
	return cachedType
end

--[[------------------------------------------------------------------
	Draws the weapon panel.
	@param {Weapon} weapon
	@param {Material} weapon icon texture
	@param {Color} category colour
	@param {number} x
	@param {number} y
	@param {Color} colour
	@param {Color} ammunition colour
	@param {number} shadow offset
	@param {Color} shadow colour
	@param {number} scale
	@param {boolean} should ammunition indicator be outlined
]]--------------------------------------------------------------------
function GTA3HUD.VC.DrawWeapon(weapon, icon, background, x, y, colour, ammoCol, shadowPos, shadowCol, scale, outline)
	local w, h = WEAPON_FRAME_WIDTH * scale, WEAPON_FRAME_HEIGHT * scale
	x = x - w

	-- draw background
	if background then
		surface.SetAlphaMultiplier(220 / 225)
		surface.SetMaterial(WEAPON_BACKGROUND)
		surface.SetDrawColor(background)
		surface.DrawTexturedRect(x, y, w, h)
		surface.SetAlphaMultiplier(1)
	end

	-- draw frame
	surface.SetMaterial(WEAPON_FRAME)
	surface.SetDrawColor(colour)
	surface.DrawTexturedRect(x, y, w, h)

	-- draw icon
	if icon then
		surface.SetMaterial(icon)
		surface.SetDrawColor(color_white)
		surface.DrawTexturedRect(x, y, w, h)
	else
		GTA3HUD.draw.WeaponIcon(weapon, x + w * .52, y + h * .5, w)
	end

	-- draw ammunition
	local primary, clip, reserve = GTA3HUD.ammo.Primary()
	local secondary, alt = GTA3HUD.ammo.Secondary()
	if not primary and not secondary then return end
	local ammo = clip
	if secondary then
		ammo = string.format(AMMO_FORMAT_ALT, reserve, clip or 0, alt)
	elseif reserve then
		ammo = string.format(AMMO_FORMAT, reserve, clip)
	end
	x = x + 2 * scale
	y = y + 93 * scale
	local atlas
	if outline then atlas = ATLAS1_OUTLINED end
	if not outline then ARBORCREST:DrawText(ammo, x + (w * .5) + shadowPos * scale, y + shadowPos * scale, shadowCol, 0, scale  * .6, TEXT_ALIGN_CENTER, nil, 4, -1) end
	ARBORCREST:DrawText(ammo, x + w * .5, y, ammoCol, 0, scale * .6, TEXT_ALIGN_CENTER, nil, 4, -1, atlas)
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
function GTA3HUD.VC.DrawWasted(label, x, y, colour, shadowPos, shadowCol, alpha, scale, align, outline)
	alpha = alpha or 1
	scale = (scale or 1) * 2
	align = align or TEXT_ALIGN_RIGHT
	local atlas
	if outline then atlas = ATLAS1_OUTLINED end
	surface.SetAlphaMultiplier(alpha)
	if not outline then PRICEDOWN:DrawText(label, x + shadowPos * scale, y + shadowPos * scale, shadowCol, 1, scale, align, TEXT_ALIGN_BOTTOM, 6, -11) end
	PRICEDOWN:DrawText(label, x, y, colour, 1, scale, align, TEXT_ALIGN_BOTTOM, 6, -11, atlas)
	surface.SetAlphaMultiplier(1)
end

--[[------------------------------------------------------------------
  Draws the task message label.
	@param {number} x
	@param {number} y
	@param {table} message
	@param {string} message raw string
	@param {Color} default colour
	@param {number} shadow offset
	@param {Color} shadow colour
	@param {number} scale
	@param {boolean} outline
]]--------------------------------------------------------------------
function GTA3HUD.VC.DrawTaskMessage(x, y, message, stringified, colour, shadowPos, shadowCol, scale, outline)
	scale = scale or 1
	local atlas = ATLAS1
	if outline then atlas = ATLAS1_OUTLINED end
	x = x - (ARBORCREST:GetTextSize(stringified) * scale * .6) * .5
	if not outline then ARBORCREST:DrawText(stringified, x + shadowPos * scale, y + shadowPos * scale, shadowCol, 1, scale * .6, nil, TEXT_ALIGN_BOTTOM) end
	for _, text in pairs(message) do
		if not isstring(text) then continue end
		x = x + ARBORCREST:DrawText(text, x, y, colour, 1, scale * .6, nil, TEXT_ALIGN_BOTTOM, nil, nil, atlas)
	end
end
