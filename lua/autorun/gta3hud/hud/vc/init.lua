--[[------------------------------------------------------------------
	Grand Theft Auto: Vice City
]]--------------------------------------------------------------------

if CLIENT then GTA3HUD.VC = {} end

GTA3HUD.include('resources.lua')
GTA3HUD.include('draw.lua')
GTA3HUD.include('death.lua')

if SERVER then return end

local HUD = GTA3HUD.hud.Create()

-- [[ Extensions ]] --
--[[------------------------------------------------------------------
	Returns the actual colour of a category.
	@param {table} settings
	@param {WEAPON_} weapon category
	@return {Color} colour
]]--------------------------------------------------------------------
function HUD:WeaponTypeColour(settings, category)
	return settings.weapon['slot' .. category]
end

-- [[ Constants ]] --
local BLINK_FAST, BLINK_SLOW = .14, .33
local BLINK_DURATION = 3

-- [[ Settings ]] --
HUD:Parameter('x', 'Horizontal offset', 47)
HUD:Parameter('y', 'Vertical offset', 38)
HUD:Parameter('shadowCol', 'Shadow colour', Color(0, 0, 0))
HUD:Parameter('shadowPos', 'Shadow offset', 2)
HUD:Parameter('outline', 'Outlined', false)

-- [[ Properties ]] --
local offset = math.random(0, 23)
local DAY, MINUTE = 1440, 60
local TIME_FETCH = { GTA3HUD.util.OSTime, GTA3HUD.util.GameSession }
local HUD_TIME = HUD:Element('time', '#gta3hud.menu.common.time', Color(100, 190, 250), 103, -7)
HUD_TIME:Option('source', '#gta3hud.menu.common.time.source', {'#gta3hud.menu.common.time.source.1', '#gta3hud.menu.common.time.source.2'}, 1)
HUD_TIME.Preview = function(self, w, h, settings)
	local x, y = (w * .5) + 47, (h * .5) - 16
	local curtime = CurTime() + MINUTE * offset
	local days = math.floor(curtime / DAY)
	local time = curtime - days * DAY
	local hours = math.floor(time / MINUTE)
	local minutes = time - hours * MINUTE
	if not settings.outline then GTA3HUD.VC.DrawTime(hours, minutes, x + settings.shadowPos, y + settings.shadowPos, settings.shadowCol) end
	GTA3HUD.VC.DrawTime(hours, minutes, x, y, settings.time.colour, 1, settings.outline)
end

local preview = 0
local HUD_MONEY = HUD:Element('money', '#gta3hud.menu.common.money', Color(0, 210, 133), 103, 23)
HUD_MONEY:Parameter('animation', '#gta3hud.menu.common.money.animation', true)
HUD_MONEY:Option('source', '#gta3hud.menu.common.money.modes', GTA3HUD.money.MODES, 1)
HUD_MONEY:Parameter('multiplier', '#gta3hud.menu.common.money.multiplier', 1)
HUD_MONEY:Parameter('input', '#gta3hud.menu.common.money.input', 0)
HUD_MONEY.Preview = function(self, w, h, settings)
	local x, y = (w * .5) + 86, (h * .5) - 14
	preview = preview + 32
	if preview >= 99999999 then preview = 0 end
	if not settings.outline then GTA3HUD.VC.DrawMoney(math.floor(preview), x + settings.shadowPos, y + settings.shadowPos, settings.shadowCol) end
	GTA3HUD.VC.DrawMoney(math.floor(preview), x, y, settings.money.colour, 1, settings.outline)
end

local preview = 0
local PREVIEW_BLINK = GTA3HUD.blink.Create()
local HUD_HEALTH = HUD:Element('health', '#gta3hud.menu.common.health', Color(255, 150, 225), 103, 55)
HUD_HEALTH:Range('warning', '#gta3hud.menu.common.health.warning', 10, 0, 100)
HUD_HEALTH:Parameter('move', '#gta3hud.menu.gta3.health.move', true)
HUD_HEALTH.Preview = function(self, w, h, settings)
	local x, y = (w * .5) + 43, (h * .5) - 14
	if preview < CurTime() then preview = CurTime() + 10 end
	local health = math.floor(math.Clamp((preview - 2) - CurTime(), 0, 7) * (100 / 7))
	if health < settings.health.warning then
		PREVIEW_BLINK:SetRate(BLINK_SLOW)
	else
		PREVIEW_BLINK:SetRate(BLINK_FAST)
	end
	PREVIEW_BLINK:SetActive(health < 100)
	PREVIEW_BLINK:Run()
	local blink = PREVIEW_BLINK:IsBlinking()
	if health < settings.health.warning and blink then return end
	if not settings.outline then GTA3HUD.VC.DrawHealth(health, x + settings.shadowPos, y + settings.shadowPos, settings.shadowCol, 1, blink) end
	GTA3HUD.VC.DrawHealth(health, x, y, settings.health.colour, 1, blink, settings.outline)
end

local preview = 0
local PREVIEW_BLINK = GTA3HUD.blink.Create(BLINK_FAST)
local HUD_ARMOUR = HUD:Element('armour', '#gta3hud.menu.common.armour', Color(185, 185, 185), 201, 55)
HUD_ARMOUR.Preview = function(self, w, h, settings)
	local x, y = (w * .5) + 43, (h * .5) - 14
	if preview < CurTime() then preview = CurTime() + 10 end
	local armour = math.floor(math.Clamp((preview - 2) - CurTime(), 0, 7) * (100 / 7))
	PREVIEW_BLINK:SetActive(armour < 100)
	PREVIEW_BLINK:Run()
	local blink = PREVIEW_BLINK:IsBlinking()
	if not settings.outline then GTA3HUD.VC.DrawArmour(armour, x + settings.shadowPos, y + settings.shadowPos, settings.shadowCol, 1, blink) end
	GTA3HUD.VC.DrawArmour(armour, x, y, settings.armour.colour, 1, blink, settings.outline)
end

local HUD_WEAPON = HUD:Element('weapon', '#gta3hud.menu.common.weapon', Color(255, 200, 255))
HUD_WEAPON:Parameter('ammoCol', '#gta3hud.menu.common.weapon.ammo_colour', Color(255, 175, 225))
HUD_WEAPON:Parameter('slot1', '#gta3hud.menu.vc.weapon.melee', Color(143, 186, 231))
HUD_WEAPON:Parameter('slot2', '#gta3hud.menu.vc.weapon.handgun', Color(150, 200, 25))
HUD_WEAPON:Parameter('slot3', '#gta3hud.menu.vc.weapon.smg', Color(255, 230, 80))
HUD_WEAPON:Parameter('slot4', '#gta3hud.menu.vc.weapon.shotgun', Color(50, 160, 90))
HUD_WEAPON:Parameter('slot5', '#gta3hud.menu.vc.weapon.assault', Color(255, 140, 0))
HUD_WEAPON:Parameter('slot6', '#gta3hud.menu.vc.weapon.sniper', Color(255, 135, 220))
HUD_WEAPON:Parameter('slot7', '#gta3hud.menu.vc.weapon.heavy', Color(170, 40, 185))
HUD_WEAPON:Parameter('slot8', '#gta3hud.menu.vc.weapon.throwable', Color(25, 90, 130))
HUD_WEAPON:Parameter('slot9', '#gta3hud.menu.vc.weapon.tool', Color(66, 66, 66))
HUD_WEAPON.Preview = function(self, w, h, settings)
	local x, y = (w * .5) + 43, 6
	local weapon = LocalPlayer():GetActiveWeapon()
	local database = GTA3HUD.VC.WEAPONS
	GTA3HUD.VC.DrawWeapon(weapon, database:Get(database:FindWeaponIcon(weapon)), HUD:WeaponTypeColour(settings, database:FindWeaponType(weapon) or GTA3HUD.VC.GetWeaponType(weapon)), x, y, settings.weapon.colour, settings.weapon.ammoCol, settings.shadowPos, settings.shadowCol, 1, settings.outline)
end

local preview = 0
local PREVIEW_BLINK = GTA3HUD.blink.Create(BLINK_FAST)
local HUD_STARS = HUD:Element('stars', '#gta3hud.menu.common.stars', Color(100, 190, 250), 94, 87)
HUD_STARS:Parameter('background', '#gta3hud.menu.vc.stars.background', Color(25, 90, 130))
HUD_STARS.Preview = function(self, w, h, settings)
	local x, y = (w * .5) + 89, (h * .5) - 16
	if preview < CurTime() then preview = CurTime() + 10 end
	PREVIEW_BLINK:SetActive((preview - CurTime()) > 2)
	PREVIEW_BLINK:Run()
	GTA3HUD.VC.DrawStars(6 - math.floor(math.max((preview - 3) - CurTime(), 0)) * (6 / 7), x, y, settings.stars.colour, settings.stars.background, settings.shadowPos, settings.shadowCol, 1, PREVIEW_BLINK:IsBlinking(), settings.outline)
end

local HUD_WASTED = HUD:Element('wasted', '#gta3hud.menu.vc.wasted', Color(100, 190, 250), 47, 76)
HUD_WASTED:Parameter('camera', '#gta3hud.menu.gta3.wasted.camera', true)
HUD_WASTED:Parameter('label', 'Label', language.GetPhrase('gta3hud.menu.vc.wasted.default'))
HUD_WASTED.Preview = function(self, w, h, settings)
	local x, y = (w * .5), (h * .5) + 27
	GTA3HUD.VC.DrawWasted(settings.wasted.label, x, y, settings.wasted.colour, settings.shadowPos, settings.shadowCol, 1, 1, TEXT_ALIGN_CENTER, settings.outline)
end

local RADAR_FRAME = Material('gta3hud/vc/radardisc.png')
local HUD_MINIMAP = HUD:Element('minimap', '#gta3hud.menu.common.radar', Color(240, 120, 255), 28, 56)
HUD_MINIMAP:Parameter('radius', '#gta3hud.menu.common.radar.radius', 110)
HUD_MINIMAP:Parameter('background', '#gta3hud.menu.common.radar.minimap', true)
HUD_MINIMAP:Parameter('alive', '#gta3hud.menu.gta3.radar.alive', Color(255, 255, 0))
HUD_MINIMAP:Parameter('entities', '#gta3hud.menu.common.radar.entities', Color(0, 255, 255))
HUD_MINIMAP:Parameter('position', '#gta3hud.menu.common.radar.position', Color(255, 0, 255))
HUD_MINIMAP.Preview = function(self, w, h, settings)
	GTA3HUD.radar.DrawPreview(w, h, settings.minimap.colour, settings.minimap.background, RADAR_FRAME)
end

local HUD_STATS = HUD:Element('stats', '#gta3hud.menu.common.stats', Color(100, 190, 250), 0, 124)
HUD_STATS.Preview = function(self, w, h, settings)
	local x, y = (w * .5) + 140, 8
	GTA3HUD.GTA3.DrawTextStat(nil, '01:01', x, y, settings.stats.colour, settings.shadowPos, settings.shadowCol, 1, settings.outline)
	GTA3HUD.GTA3.DrawProgressStat('#gta3hud.menu.vc.stats.sample.1', .4, x, y + 33, settings.stats.colour, settings.shadowPos, settings.shadowCol, 1, settings.outline)
	GTA3HUD.GTA3.DrawTextStat('#gta3hud.menu.vc.stats.sample.2', '10', x, y + 66, settings.stats.colour, settings.shadowPos, settings.shadowCol, 1, settings.outline)
end

local PREVIEW = { '#gta3hud.menu.gta3.taskresult.sample.1', '#gta3hud.menu.gta3.taskresult.sample.2' }
local HUD_TASKRESULT = HUD:Element('taskresult', '#gta3hud.menu.common.taskresult', Color(100, 190, 250), 0, -8)
HUD_TASKRESULT.Preview = function(self, w, h, settings)
	local x, y = w * .5, 46
	GTA3HUD.GTA3.DrawTaskResult(x, y, PREVIEW, 1, settings.taskresult.colour, settings.shadowPos, settings.shadowCol, .66, settings.outline)
end

local PREVIEW = { language.GetPhrase('gta3hud.menu.common.taskmessage.sample') }
local HUD_TASKMESSAGE = HUD:Element('taskmessage', '#gta3hud.menu.common.taskmessage', Color(255, 150, 255), 0, 128)
HUD_TASKMESSAGE.Preview = function(self, w, h, settings)
	local x, y = w * .5, h * .5 + 20
	GTA3HUD.VC.DrawTaskMessage(x, y, PREVIEW, PREVIEW[1], settings.taskmessage.colour, settings.shadowPos, settings.shadowCol, 2, settings.outline)
end

-- [[ Replace default elements with visible ones ]] --
function HUD:HUDShouldDraw(settings, element)
	if element == 'CHudHealth' and settings.health.visible then return false end
	if element == 'CHudBattery' and settings.armour.visible then return false end
	if (element == 'CHudAmmo' or element == 'CHudSecondaryAmmo') and settings.weapon.visible then return false end
	if element == 'CHudDamageIndicator' and settings.wasted.visible and LocalPlayer and LocalPlayer().Alive and not LocalPlayer():Alive() then return false end
	if element == 'CHudSuitPower' and settings.stats.visible then return false end
end

-- [[ ... you're not in Liberty City now ]] --
local BLINK_HEALTH, BLINK_WARNING = GTA3HUD.blink.Create(BLINK_FAST), GTA3HUD.blink.Create(BLINK_SLOW)
local BLINK_ARMOUR, BLINK_STARS = GTA3HUD.blink.Create(BLINK_FAST), GTA3HUD.blink.Create(BLINK_FAST)
local lastHealth, healthTime = 100, 0
local lastArmour, armourTime = 0, 0
local lastStars, starsTime = 0, 0
local blipColours = {}
function HUD:Draw(settings, scale)
  scale = scale or 1
  local x, y = ScrW() - settings.x * scale, settings.y * scale
  local localPlayer = LocalPlayer()
	local money = GTA3HUD.money.GetMoney(GTA3HUD.money.UserValue(settings.money.source, settings.money.input) * settings.money.multiplier, not settings.money.animation)
	local health, armour = math.max(localPlayer:Health(), 0), localPlayer:Armor()
	local hours, minutes = hook.Run('GTA3HUD_GetTime')
	if not hours or not minutes then hours, minutes = TIME_FETCH[settings.time.source]() end
	local stars = GTA3HUD.wanted.GetWantedLevel()

	-- blip colours
	blipColours.friend = settings.minimap.alive
	blipColours.hostile = settings.minimap.alive
	blipColours.entities = settings.minimap.entities
	blipColours.position = settings.minimap.position

	-- animations
	if health ~= lastHealth then
		if health < lastHealth then healthTime = CurTime() + BLINK_DURATION end
		lastHealth = health
	end
	if armour ~= lastArmour then
		if armour < lastArmour then armourTime = CurTime() + BLINK_DURATION end
		lastArmour = armour
	end
	if stars ~= lastStars then
		if stars > 0 then starsTime = CurTime() + BLINK_DURATION end
		lastStars = stars
	end

	-- blinking
	BLINK_HEALTH:SetActive(health > 0 and healthTime > CurTime())
	BLINK_HEALTH:Run()
	BLINK_WARNING:SetActive(health <= settings.health.warning)
	BLINK_WARNING:Run()
	BLINK_ARMOUR:SetActive(armourTime > CurTime())
	BLINK_ARMOUR:Run()
	BLINK_STARS:SetActive(starsTime > CurTime())
	BLINK_STARS:Run()

  -- position
  local shadow = settings.shadowPos * scale
	local time_xpos, time_ypos = x - settings.time.x * scale, y + settings.time.y * scale
	local money_xpos, money_ypos = x - settings.money.x * scale, y + settings.money.y * scale
  local health_xpos, health_ypos = x - settings.health.x * scale, y + settings.health.y * scale
	local health_wide = (GTA3HUD.VC.PRICEDOWN:GetSize('0') + 1) * scale
  local armour_xpos, armour_ypos = x - settings.armour.x * scale, y + settings.armour.y * scale
	if settings.health.visible and settings.health.move then armour_xpos = armour_xpos - health_wide * math.max(math.log10(health) - 2, 0) end
	local stars_xpos, stars_ypos = x - settings.stars.x * scale, y + settings.stars.y * scale

  -- shadow
	if not settings.outline then
		if settings.time.visible then GTA3HUD.VC.DrawTime(hours, minutes, time_xpos + shadow, time_ypos + shadow, settings.shadowCol, scale) end
		if settings.money.visible then GTA3HUD.VC.DrawMoney(money, money_xpos + shadow, money_ypos + shadow, settings.shadowCol, scale) end
	  if settings.health.visible and not BLINK_WARNING:IsBlinking() then GTA3HUD.VC.DrawHealth(health, health_xpos + shadow, health_ypos + shadow, settings.shadowCol, scale, BLINK_HEALTH:IsBlinking()) end
	  if settings.armour.visible and armour > 0 then GTA3HUD.VC.DrawArmour(armour, armour_xpos + shadow, armour_ypos + shadow, settings.shadowCol, scale, BLINK_ARMOUR:IsBlinking()) end
	end

  -- foreground
	if settings.time.visible then GTA3HUD.VC.DrawTime(hours, minutes, time_xpos, time_ypos, settings.time.colour, scale, settings.outline) end
	if settings.money.visible then GTA3HUD.VC.DrawMoney(money, money_xpos, money_ypos, settings.money.colour, scale, settings.outline) end
  if settings.health.visible and not BLINK_WARNING:IsBlinking() then GTA3HUD.VC.DrawHealth(health, health_xpos, health_ypos, settings.health.colour, scale, BLINK_HEALTH:IsBlinking(), settings.outline) end
  if settings.armour.visible and armour > 0 then GTA3HUD.VC.DrawArmour(armour, armour_xpos, armour_ypos, settings.armour.colour, scale, BLINK_ARMOUR:IsBlinking(), settings.outline) end
	if settings.stars.visible and not BLINK_STARS:IsBlinking() then GTA3HUD.VC.DrawStars(stars, stars_xpos, stars_ypos, settings.stars.colour, settings.stars.background, settings.shadowPos, settings.shadowCol, scale, BLINK_STARS:IsBlinking(), settings.outline) end
	 -- TODO: use own, or at least pass the VC's atlas
	if settings.stats.visible then GTA3HUD.GTA3.DrawStats(x - settings.stats.x * scale, y + settings.stats.y * scale, settings.stats.colour, settings.stats.colour, settings.shadowPos, settings.shadowCol, scale, settings.outline) end

	-- weapon
	if settings.weapon.visible then
		local weapon = LocalPlayer():GetActiveWeapon()
		local database = GTA3HUD.VC.WEAPONS
		GTA3HUD.VC.DrawWeapon(weapon, database:Get(database:FindWeaponIcon(weapon)), self:WeaponTypeColour(settings, database:FindWeaponType(weapon) or GTA3HUD.VC.GetWeaponType(weapon)), x - settings.weapon.x * scale, y + settings.weapon.y * scale, settings.weapon.colour, settings.weapon.ammoCol, settings.shadowPos, settings.shadowCol, scale, settings.outline)
	end

	-- wasted
	if settings.wasted.visible and GTA3HUD.util.IsWasted() then
		GTA3HUD.VC.DrawWasted(settings.wasted.label, ScrW() - settings.wasted.x * scale, ScrH() - settings.wasted.y * scale, settings.wasted.colour, settings.shadowPos, settings.shadowCol, math.min(GTA3HUD.util.DeathTime() * 2, 1), scale, nil, settings.outline)
	end

	-- task result
	if settings.taskresult.visible and GTA3HUD.taskresult.GetOpacity() > 0 then -- TODO: use own, or at least pass the VC's atlas
		if GTA3HUD.taskresult.ShouldMusicSound() then GTA3HUD.taskresult.PlayMusic(GTA3HUD.VC.SOUND_MISSIONPASSED) end
		GTA3HUD.GTA3.DrawTaskResult(ScrW() * .5 + settings.taskresult.x * scale, ScrH() * .5 + settings.taskresult.y * scale, GTA3HUD.taskresult.GetLines(), GTA3HUD.taskresult.GetOpacity(), settings.taskresult.colour, settings.shadowPos, settings.shadowCol, scale, settings.outline)
	end

	-- task message
	if settings.taskmessage.visible and GTA3HUD.taskmessage.ShouldDraw() then
		GTA3HUD.VC.DrawTaskMessage(ScrW() * .5 + settings.taskmessage.x * scale, y + ScrH() - settings.taskmessage.y * scale, GTA3HUD.taskmessage.Get(), GTA3HUD.taskmessage.GetString(), settings.taskmessage.colour, settings.shadowPos, settings.shadowCol, scale, settings.outline)
	end

	-- radar
	if not settings.minimap.visible then return end
	GTA3HUD.radar.Draw(settings.minimap.x * scale, ScrH() - settings.minimap.y * scale, settings.minimap.colour, settings.minimap.radius, settings.minimap.background, blipColours, scale, RADAR_FRAME)
end

-- [[ Wasted animation ]] --
function HUD:CalcView(settings, _player, origin, angles, fov, znear, zfar)
	if not settings.wasted.visible or not settings.wasted.camera or not GTA3HUD.util.IsWasted() then return end
	return GTA3HUD.VC.WastedView(_player, origin, angles, fov, znear, zfar)
end

GTA3HUD.VC.ID =GTA3HUD.hud.Register('Vice City', HUD)
