--[[------------------------------------------------------------------
	Grand Theft Auto III
]]--------------------------------------------------------------------

if CLIENT then GTA3HUD.GTA3 = {} end

GTA3HUD.include('resources.lua')
GTA3HUD.include('draw.lua')
GTA3HUD.include('death.lua')

if SERVER then return end

local HUD = GTA3HUD.hud.Create()

HUD.default = true -- set as default

-- [[ Constants ]] --
local BLINK_FAST, BLINK_SLOW = .14, .33
local BLINK_DURATION = 3

-- [[ Settings ]] --
HUD:Parameter('x', '#gta3hud.menu.common.x', 47)
HUD:Parameter('y', '#gta3hud.menu.common.y', 38)
HUD:Parameter('shadowCol', '#gta3hud.menu.gta3.shadow_colour', Color(0, 0, 0))
HUD:Parameter('shadowPos', '#gta3hud.menu.gta3.shadow_pos', 2)
HUD:Parameter('outline', '#gta3hud.menu.gta3.outlined', false)

-- [[ Properties ]] --
local offset = math.random(0, 23)
local DAY, MINUTE = 1440, 60
local TIME_FETCH = { GTA3HUD.util.OSTime, GTA3HUD.util.GameSession }
local HUD_TIME = HUD:Element('time', '#gta3hud.menu.common.time', Color(185, 160, 120), 102, -7)
HUD_TIME:Option('source', '#gta3hud.menu.common.time.source', {'#gta3hud.menu.common.time.source.1', '#gta3hud.menu.common.time.source.2'}, 1)
HUD_TIME.Preview = function(self, w, h, settings)
	local x, y = (w * .5) + 47, (h * .5) - 16
	local curtime = CurTime() + MINUTE * offset
	local days = math.floor(curtime / DAY)
	local time = curtime - days * DAY
	local hours = math.floor(time / MINUTE)
	local minutes = time - hours * MINUTE
	if not settings.outline then GTA3HUD.GTA3.DrawTime(hours, minutes, x + settings.shadowPos, y + settings.shadowPos, settings.shadowCol) end
	GTA3HUD.GTA3.DrawTime(hours, minutes, x, y, settings.time.colour, 1, settings.outline)
end

local preview = 0
local HUD_MONEY = HUD:Element('money', '#gta3hud.menu.common.money', Color(90, 115, 150), 102, 23)
HUD_MONEY:Parameter('animation', '#gta3hud.menu.common.money.animation', true)
HUD_MONEY:Option('source', '#gta3hud.menu.common.money.modes', GTA3HUD.money.MODES, 1)
HUD_MONEY:Parameter('multiplier', '#gta3hud.menu.common.money.multiplier', 1)
HUD_MONEY:Parameter('input', '#gta3hud.menu.common.money.input', 0)
HUD_MONEY.Preview = function(self, w, h, settings)
	local x, y = (w * .5) + 86, (h * .5) - 16
	preview = preview + 32
	if preview >= 99999999 then preview = 0 end
	if not settings.outline then GTA3HUD.GTA3.DrawMoney(math.floor(preview), x + settings.shadowPos, y + settings.shadowPos, settings.shadowCol) end
	GTA3HUD.GTA3.DrawMoney(math.floor(preview), x, y, settings.money.colour, 1, settings.outline)
end

local preview = 0
local PREVIEW_BLINK = GTA3HUD.blink.Create()
local HUD_HEALTH = HUD:Element('health', '#gta3hud.menu.common.health', Color(185, 100, 50), 102, 55)
HUD_HEALTH:Range('warning', '#gta3hud.menu.common.health.warning', 10, 0, 100)
HUD_HEALTH:Parameter('move', '#gta3hud.menu.gta3.health.move', true)
HUD_HEALTH.Preview = function(self, w, h, settings)
	local x, y = (w * .5) + 43, (h * .5) - 16
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
	if not settings.outline then GTA3HUD.GTA3.DrawHealth(health, x + settings.shadowPos, y + settings.shadowPos, settings.shadowCol, 1, blink) end
	GTA3HUD.GTA3.DrawHealth(health, x, y, settings.health.colour, 1, blink, settings.outline)
end

local preview = 0
local PREVIEW_BLINK0, PREVIEW_BLINK1 = GTA3HUD.blink.Create(BLINK_FAST), GTA3HUD.blink.Create()
local HUD_ARMOUR = HUD:Element('armour', '#gta3hud.menu.common.armour', Color(110, 130, 80), 192, 55)
HUD_ARMOUR.Preview = function(self, w, h, settings)
	local x, y = (w * .5) + 43, (h * .5) - 16
	if preview < CurTime() then preview = CurTime() + 10 end
	local armour = math.floor(math.Clamp((preview - 2) - CurTime(), 0, 7) * (100 / 7))
	PREVIEW_BLINK0:SetActive(armour < 100)
	PREVIEW_BLINK1:SetActive(armour < 100)
	PREVIEW_BLINK0:Run()
	PREVIEW_BLINK1:Run()
	local blink = PREVIEW_BLINK0
	if not settings.outline then
		GTA3HUD.GTA3.DrawArmour(armour, x + settings.shadowPos, y + settings.shadowPos, settings.shadowCol, 1, PREVIEW_BLINK0:IsBlinking())
		blink = PREVIEW_BLINK1
	end
	GTA3HUD.GTA3.DrawArmour(armour, x, y, settings.armour.colour, 1, blink:IsBlinking(), settings.outline)
end

local HUD_WEAPON = HUD:Element('weapon', '#gta3hud.menu.common.weapon', Color(248, 177, 0))
HUD_WEAPON:Parameter('ammoCol', '#gta3hud.menu.common.weapon.ammo_colour', Color(0, 0, 0))
HUD_WEAPON:Parameter('alternate', '#gta3hud.menu.gta3.weapon.alternate', false)
HUD_WEAPON.Preview = function(self, w, h, settings)
	local x, y = (w * .5) + 43, (h * .5) - 45
	GTA3HUD.GTA3.DrawWeapon(LocalPlayer():GetActiveWeapon(), GTA3HUD.GTA3.WEAPONS, x, y, settings.weapon.colour, settings.weapon.ammoCol, 1, settings.weapon.alternate, true)
end

local preview = 0
local PREVIEW_BLINK = GTA3HUD.blink.Create(BLINK_FAST)
local HUD_STARS = HUD:Element('stars', '#gta3hud.menu.common.stars', Color(185, 160, 120), 2, 86)
HUD_STARS.Preview = function(self, w, h, settings)
	local x, y = (w * .5) + 89, (h * .5) - 16
	if preview < CurTime() then preview = CurTime() + 10 end
	PREVIEW_BLINK:SetActive((preview - CurTime()) > 2)
	PREVIEW_BLINK:Run()
	local i, j = x, y
	if not outline then i, j = x + settings.shadowPos, y + settings.shadowPos end
	GTA3HUD.GTA3.DrawStars(6, x, y, settings.shadowCol)
	if PREVIEW_BLINK:IsBlinking() then return end
	GTA3HUD.GTA3.DrawStars(6 - math.floor(math.max((preview - 3) - CurTime(), 0)) * (6 / 7), x, y, settings.stars.colour, 1, settings.outline)
end

local HUD_WASTED = HUD:Element('wasted', '#gta3hud.menu.gta3.wasted', Color(160, 120, 80), 47, 76)
HUD_WASTED:Parameter('camera', '#gta3hud.menu.common.wasted.camera', true)
HUD_WASTED:Parameter('label', '#gta3hud.menu.common.wasted.label', language.GetPhrase('gta3hud.menu.gta3.wasted.default'))
HUD_WASTED.Preview = function(self, w, h, settings)
	local x, y = (w * .5), (h * .5) + 27
	GTA3HUD.GTA3.DrawWasted(settings.wasted.label, x, y, settings.wasted.colour, settings.shadowPos, settings.shadowCol, nil, nil, TEXT_ALIGN_CENTER, settings.outline)
end

local HUD_MINIMAP = HUD:Element('minimap', '#gta3hud.menu.common.radar', Color(0, 0, 0), 28, 56)
HUD_MINIMAP:Parameter('radius', '#gta3hud.menu.common.radar.radius', 110)
HUD_MINIMAP:Parameter('background', '#gta3hud.menu.common.radar.minimap', true)
HUD_MINIMAP:Parameter('alive', '#gta3hud.menu.gta3.radar.alive', Color(100, 160, 120))
HUD_MINIMAP:Parameter('entities', '#gta3hud.menu.common.radar.entities', Color(0, 255, 255))
HUD_MINIMAP:Parameter('position', '#gta3hud.menu.common.radar.position', Color(255, 0, 255))
HUD_MINIMAP.Preview = function(self, w, h, settings)
	GTA3HUD.radar.DrawPreview(w, h, settings.minimap.colour, settings.minimap.background)
end

local HUD_STATS = HUD:Element('stats', '#gta3hud.menu.common.stats', Color(185, 100, 50), 0, 124)
HUD_STATS:Parameter('altCol', '#gta3hud.menu.common.stats.alternate_colour', Color(0, 100, 150))
HUD_STATS.Preview = function(self, w, h, settings)
	local x, y = (w * .5) + 95, 8
	GTA3HUD.GTA3.DrawTextStat(nil, '04:13', x, y, settings.stats.colour, settings.shadowPos, settings.shadowCol, 1, settings.outline)
	GTA3HUD.GTA3.DrawProgressStat('#gta3hud.menu.gta3.stats.sample.1', .7, x, y + 33, settings.stats.altCol, settings.shadowPos, settings.shadowCol, 1, settings.outline)
	GTA3HUD.GTA3.DrawTextStat('#gta3hud.menu.gta3.stats.sample.2', '10', x, y + 66, settings.stats.altCol, settings.shadowPos, settings.shadowCol, 1, settings.outline)
end

local PREVIEW = { '#gta3hud.menu.gta3.taskresult.sample.1', '#gta3hud.menu.gta3.taskresult.sample.2' }
local HUD_TASKRESULT = HUD:Element('taskresult', '#gta3hud.menu.common.taskresult', Color(85, 120, 130), 0, -8)
HUD_TASKRESULT.Preview = function(self, w, h, settings)
	local x, y = w * .5, 46
	GTA3HUD.GTA3.DrawTaskResult(x, y, PREVIEW, 1, settings.taskresult.colour, settings.shadowPos, settings.shadowCol, .66, settings.outline)
end

local PREVIEW = { language.GetPhrase('gta3hud.menu.common.taskmessage.sample') }
local HUD_TASKMESSAGE = HUD:Element('taskmessage', '#gta3hud.menu.common.taskmessage', Color(110, 130, 80), 0, 128)
HUD_TASKMESSAGE:Parameter('altCol', '#gta3hud.menu.common.taskmessage.alt_colour', Color(95, 45, 70))
HUD_TASKMESSAGE.Preview = function(self, w, h, settings)
	local x, y = w * .5, h * .5 + 20
	GTA3HUD.GTA3.DrawTaskMessage(x, y, PREVIEW, PREVIEW[1], settings.taskmessage.colour, settings.taskmessage.altCol, settings.shadowPos, settings.shadowCol, 2, settings.outline)
end

-- [[ Replace default elements with visible ones ]] --
function HUD:HUDShouldDraw(settings, element)
  if element == 'CHudHealth' and settings.health.visible then return false end
  if element == 'CHudBattery' and settings.armour.visible then return false end
	if (element == 'CHudAmmo' or element == 'CHudSecondaryAmmo') and settings.weapon.visible then return false end
	if element == 'CHudDamageIndicator' and settings.wasted.visible and LocalPlayer and LocalPlayer().Alive and not LocalPlayer():Alive() then return false end
	if element == 'CHudSuitPower' and settings.stats.visible then return false end
end

-- [[ Bring players back to 2001 ]] --
local BLINK_HEALTH, BLINK_WARNING = GTA3HUD.blink.Create(BLINK_FAST), GTA3HUD.blink.Create(BLINK_SLOW)
local BLINK_ARMOUR0, BLINK_ARMOUR1 = GTA3HUD.blink.Create(), GTA3HUD.blink.Create(BLINK_FAST)
local BLINK_STARS = GTA3HUD.blink.Create(BLINK_FAST)
local lastHealth, healthTime = 100, 0
local lastArmour, armourTime = 0, 0
local lastStars, starsTime = 0, 0
local blipColours = {}
function HUD:Draw(settings, scale)
	scale = scale or 1
  local x, y = ScrW() - settings.x * scale, settings.y * scale
	local money = GTA3HUD.money.GetMoney(GTA3HUD.money.UserValue(settings.money.source, settings.money.input) * settings.money.multiplier, not settings.money.animation)
  local health, armour = math.max(LocalPlayer():Health(), 0), LocalPlayer():Armor()
	local hours, minutes = hook.Run('GTA3HUD_GetTime')
	if not hours or not minutes then hours, minutes = TIME_FETCH[settings.time.source]() end
	local stars = GTA3HUD.wanted.GetWantedLevel()

	-- blip colours
	blipColours.friend = settings.minimap.alive
	blipColours.hostile = settings.minimap.alive
	blipColours.position = settings.minimap.position
	blipColours.entities = settings.minimap.entities

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
		starsTime = CurTime() + BLINK_DURATION
		lastStars = stars
	end

	-- blinking
	BLINK_HEALTH:SetActive(health > 0 and healthTime > CurTime())
	BLINK_HEALTH:Run()
	BLINK_WARNING:SetActive(health <= settings.health.warning)
	BLINK_WARNING:Run()
	BLINK_ARMOUR0:SetActive(armourTime > CurTime())
	BLINK_ARMOUR0:Run()
	BLINK_ARMOUR1:SetActive(armourTime > CurTime())
	BLINK_ARMOUR1:Run()
	BLINK_STARS:SetActive(starsTime > CurTime())
	BLINK_STARS:Run()
	local armourBlink = BLINK_ARMOUR0

  -- position
  local shadow = settings.shadowPos * scale
	local time_xpos, time_ypos = x - settings.time.x * scale, y + settings.time.y * scale
	local money_xpos, money_ypos = x - settings.money.x * scale, y + settings.money.y * scale
  local health_xpos, health_ypos = x - settings.health.x * scale, y + settings.health.y * scale
	local health_wide = (GTA3HUD.GTA3.FONT1:GetSize('0') + 1) * scale
  local armour_xpos, armour_ypos = x - settings.armour.x * scale, y + settings.armour.y * scale
	if settings.health.visible and settings.health.move then armour_xpos = armour_xpos - health_wide * math.max(math.log10(health) - 2, 0) end
	local stars_xpos, stars_ypos = x - settings.stars.x * scale, y + settings.stars.y * scale

	-- weapon
	local w, h = 0, 0
	if settings.weapon.visible then
		w, h = GTA3HUD.GTA3.DrawWeapon(LocalPlayer():GetActiveWeapon(), GTA3HUD.GTA3.WEAPONS, x - settings.weapon.x * scale, y + settings.weapon.y * scale, settings.weapon.colour, settings.weapon.ammoCol, scale, settings.weapon.alternate)
	end

  -- shadow
	if not settings.outline then
		if settings.time.visible then GTA3HUD.GTA3.DrawTime(hours, minutes, time_xpos + shadow, time_ypos + shadow, settings.shadowCol, scale) end
		if settings.money.visible then GTA3HUD.GTA3.DrawMoney(money, money_xpos + shadow, money_ypos + shadow, settings.shadowCol, scale) end
	  if settings.health.visible and not BLINK_WARNING:IsBlinking() then GTA3HUD.GTA3.DrawHealth(health, health_xpos + shadow, health_ypos + shadow, settings.shadowCol, scale, BLINK_HEALTH:IsBlinking()) end
	  if settings.armour.visible and armour > 0 then GTA3HUD.GTA3.DrawArmour(armour, armour_xpos + shadow, armour_ypos + shadow, settings.shadowCol, scale, BLINK_ARMOUR1:IsBlinking()) end
		if settings.stars.visible then GTA3HUD.GTA3.DrawStars(6, stars_xpos + shadow, stars_ypos + shadow, settings.shadowCol, scale) end
	else
		if settings.stars.visible then GTA3HUD.GTA3.DrawStars(6, stars_xpos, stars_ypos + scale, settings.shadowCol, scale) end
		armourBlink = BLINK_ARMOUR1
	end

  -- foreground
	if settings.time.visible then GTA3HUD.GTA3.DrawTime(hours, minutes, time_xpos, time_ypos, settings.time.colour, scale, settings.outline) end
	if settings.money.visible then GTA3HUD.GTA3.DrawMoney(money, money_xpos, money_ypos, settings.money.colour, scale, settings.outline) end
  if settings.health.visible and not BLINK_WARNING:IsBlinking() then GTA3HUD.GTA3.DrawHealth(health, health_xpos, health_ypos, settings.health.colour, scale, BLINK_HEALTH:IsBlinking(), settings.outline) end
  if settings.armour.visible and armour > 0 then GTA3HUD.GTA3.DrawArmour(armour, armour_xpos, armour_ypos, settings.armour.colour, scale, armourBlink:IsBlinking(), settings.outline) end
	if settings.stars.visible and not BLINK_STARS:IsBlinking() then GTA3HUD.GTA3.DrawStars(stars, stars_xpos, stars_ypos, settings.stars.colour, scale, settings.outline) end
	if settings.stats.visible then GTA3HUD.GTA3.DrawStats(x - settings.stats.x * scale, y + settings.stats.y * scale, settings.stats.colour, settings.stats.altCol, settings.shadowPos, settings.shadowCol, scale, settings.outline) end

	-- wasted
	if settings.wasted.visible and GTA3HUD.util.IsWasted() then
		GTA3HUD.GTA3.DrawWasted(settings.wasted.label, ScrW() - settings.wasted.x * scale, ScrH() - settings.wasted.y * scale, settings.wasted.colour, settings.shadowPos, settings.shadowCol, math.min(GTA3HUD.util.DeathTime() * 2, 1), scale, nil, settings.outline)
	end

	-- task result
	if settings.taskresult.visible and GTA3HUD.taskresult.GetOpacity() > 0 then
		if GTA3HUD.taskresult.ShouldMusicSound() then GTA3HUD.taskresult.PlayMusic(GTA3HUD.GTA3.SOUND_MISSIONPASSED) end
		GTA3HUD.GTA3.DrawTaskResult(ScrW() * .5 + settings.taskresult.x * scale, ScrH() * .5 + settings.taskresult.y * scale, GTA3HUD.taskresult.GetLines(), GTA3HUD.taskresult.GetOpacity(), settings.taskresult.colour, settings.shadowPos, settings.shadowCol, scale, settings.outline)
	end

	-- task message
	if settings.taskmessage.visible and GTA3HUD.taskmessage.ShouldDraw() then
		GTA3HUD.GTA3.DrawTaskMessage(ScrW() * .5 + settings.taskmessage.x * scale, y + ScrH() - settings.taskmessage.y * scale, GTA3HUD.taskmessage.Get(), GTA3HUD.taskmessage.GetString(), settings.taskmessage.colour, settings.taskmessage.altCol, settings.shadowPos, settings.shadowCol, scale, settings.outline)
	end

	-- radar
	if not settings.minimap.visible then return end
	GTA3HUD.radar.Draw(settings.minimap.x * scale, ScrH() - settings.minimap.y * scale, settings.minimap.colour, settings.minimap.radius, settings.minimap.background, blipColours, scale)
end

-- [[ Wasted animation ]] --
function HUD:CalcView(settings, _player, origin, angles, fov, znear, zfar)
	if not settings.wasted.visible or not settings.wasted.camera or not GTA3HUD.util.IsWasted() then return end
	return GTA3HUD.GTA3.WastedView(_player, origin, angles, fov, znear, zfar)
end

GTA3HUD.GTA3.ID = GTA3HUD.hud.Register('Grand Theft Auto III', HUD)
