--[[------------------------------------------------------------------
	Grand Theft Auto: Liberty City Stories
]]--------------------------------------------------------------------

if CLIENT then GTA3HUD.LCS = {} end

GTA3HUD.include('resources.lua')
GTA3HUD.include('draw.lua')
GTA3HUD.include('death.lua')

if SERVER then return end

local HUD = GTA3HUD.hud.Create()

HUD.SOUND_MISSIONPASSED = 'gta3hud/lcs/mission_passed.mp3' -- allow VCS to change this

-- [[ Constants ]] --
local BLINK_FAST, BLINK_SLOW = .14, .33
local BLINK_DURATION = 3
local BAR_WIDTH, BAR_HEIGHT = 106, 32

-- [[ Settings ]] --
HUD:Parameter('x', '#gta3hud.menu.common.x', 22)
HUD:Parameter('y', '#gta3hud.menu.common.y', 14)

-- [[ Properties ]] --
local offset = math.random(0, 23)
local DAY, MINUTE = 1440, 60
local TIME_FETCH = { GTA3HUD.util.OSTime, GTA3HUD.util.GameSession }
local HUD_TIME = HUD:Element('time', '#gta3hud.menu.common.time', Color(184, 128, 0), 95, 13)
HUD_TIME:Option('source', '#gta3hud.menu.common.time.source', {'#gta3hud.menu.common.time.source.1', '#gta3hud.menu.common.time.source.2'}, 1)
HUD_TIME.Preview = function(self, w, h, settings)
	local curtime = CurTime() + MINUTE * offset
	local days = math.floor(curtime / DAY)
	local time = curtime - days * DAY
	local hours = math.floor(time / MINUTE)
	local minutes = time - hours * MINUTE
	GTA3HUD.LCS.DrawTime(hours, minutes, (w * .5) + 47, (h * .5) - 4, settings.time.colour, 1)
end

local preview, previewOverheal = 0, true
local PREVIEW_BLINK = GTA3HUD.blink.Create(BLINK_FAST)
local HUD_ARMOUR = HUD:Element('armour', '#gta3hud.menu.common.armour', Color(42, 120, 190), 95, 36)
HUD_ARMOUR:Parameter('alternate', '#gta3hud.menu.lcs.armour.alternate', false)
HUD_ARMOUR.Preview = function(self, w, h, settings)
	if preview < CurTime() then
		previewOverheal = not previewOverheal
		preview = CurTime() + 10
	end
	local armour = math.Clamp((preview - 2) - CurTime(), 0, 7) / 7
	PREVIEW_BLINK:SetActive(armour < 1)
	PREVIEW_BLINK:Run()
	if PREVIEW_BLINK:IsBlinking() then return end
	GTA3HUD.LCS.DrawBar(armour, (w * .5) + BAR_WIDTH * .5, (h * .5) - BAR_HEIGHT * .5, BAR_WIDTH, BAR_HEIGHT, settings.armour.colour, 1, previewOverheal, settings.armour.alternate)
end

local preview, previewOverheal = 0, false
local PREVIEW_BLINK = GTA3HUD.blink.Create(BLINK_SLOW)
local HUD_HEALTH = HUD:Element('health', '#gta3hud.menu.common.health', Color(150, 0, 0), 95, 70)
HUD_HEALTH:Parameter('alternate', '#gta3hud.menu.lcs.health.alternate', false)
HUD_HEALTH:Range('warning', '#gta3hud.menu.common.health.warning', 10, 0, 100)
HUD_HEALTH.Preview = function(self, w, h, settings)
	if preview < CurTime() then
		previewOverheal = not previewOverheal
		preview = CurTime() + 10
	end
	local health = math.Clamp((preview - 2) - CurTime(), 0, 7) / 7
	PREVIEW_BLINK:SetActive(health < settings.health.warning * .01)
	PREVIEW_BLINK:Run()
	if PREVIEW_BLINK:IsBlinking() then return end
	GTA3HUD.LCS.DrawBar(health, (w * .5) + BAR_WIDTH * .5, (h * .5) - BAR_HEIGHT * .5, BAR_WIDTH, BAR_HEIGHT, settings.health.colour, 1, previewOverheal, settings.health.alternate)
end

local HUD_WEAPON = HUD:Element('weapon', '#gta3hud.menu.common.weapon', Color(0, 0, 0), 0, 0)
HUD_WEAPON:Parameter('iconCol', '#gta3hud.menu.sa.weapon.icon_colour', Color(200, 200, 200))
HUD_WEAPON:Parameter('ammoCol', '#gta3hud.menu.common.weapon.ammo_colour', Color(200, 200, 200))
HUD_WEAPON.Preview = function(self, w, h, settings)
	local x, y = (w * .5) + 46, 12
	GTA3HUD.LCS.DrawWeapon(LocalPlayer():GetActiveWeapon(), GTA3HUD.SA.WEAPONS, x, y, settings.weapon.colour, settings.weapon.iconCol, settings.weapon.ammoCol)
end

local HUD_MONEY = HUD:Element('money', '#gta3hud.menu.common.money', Color(16, 92, 16), 0, 104)
HUD_MONEY:Parameter('animation', '#gta3hud.menu.common.money.animation', true)
HUD_MONEY:Option('source', '#gta3hud.menu.common.money.modes', GTA3HUD.money.MODES, 1)
HUD_MONEY:Parameter('multiplier', '#gta3hud.menu.common.money.multiplier', 1)
HUD_MONEY:Parameter('input', '#gta3hud.menu.common.money.input', 0)
HUD_MONEY.Preview = function(self, w, h, settings)
	preview = preview + 32
	if preview >= 99999999 then preview = 0 end
	GTA3HUD.LCS.DrawMoney(math.floor(preview), (w * .5) + 90, (h * .5) - 14, settings.money.colour)
end

local preview = 0
local PREVIEW_BLINK = GTA3HUD.blink.Create(BLINK_FAST)
local HUD_STARS = HUD:Element('stars', '#gta3hud.menu.common.stars', Color(166, 120, 44), 2, 138)
HUD_STARS.Preview = function(self, w, h, settings)
	if preview < CurTime() then preview = CurTime() + 10 end
	PREVIEW_BLINK:SetActive((preview - CurTime()) > 2)
	PREVIEW_BLINK:Run()
	if PREVIEW_BLINK:IsBlinking() then return end
	GTA3HUD.LCS.DrawStars(6 - math.floor(math.max((preview - 3) - CurTime(), 0)) * (6 / 7), (w * .5) + 90, (h * .5) - 16, settings.stars.colour, 1)
end

local HUD_WASTED = HUD:Element('wasted', '#gta3hud.menu.lcs.wasted', Color(150, 0, 0), 0, 0)
HUD_WASTED:Parameter('camera', '#gta3hud.menu.common.wasted.camera', true)
HUD_WASTED:Parameter('label', '#gta3hud.menu.common.wasted.label', language.GetPhrase('gta3hud.menu.lcs.wasted.default'))
HUD_WASTED.Preview = function(self, w, h, settings)
	local x, y = w * .5, (h * .5) + 40
	GTA3HUD.LCS.DrawWasted(settings.wasted.label, x, y, settings.wasted.colour)
end

local HUD_MINIMAP = HUD:Element('minimap', '#gta3hud.menu.common.radar', Color(0, 0, 0), 16, 16)
HUD_MINIMAP:Parameter('radius', '#gta3hud.menu.common.radar.radius', 150)
HUD_MINIMAP:Parameter('background', '#gta3hud.menu.common.radar.minimap', true)
HUD_MINIMAP:Parameter('friend', '#gta3hud.menu.sa.radar.friend', Color(70, 100, 255))
HUD_MINIMAP:Parameter('hostile', '#gta3hud.menu.sa.radar.hostile', Color(255, 40, 80))
HUD_MINIMAP:Parameter('entities', '#gta3hud.menu.common.radar.entities', Color(110, 160, 130))
HUD_MINIMAP:Parameter('position', '#gta3hud.menu.common.radar.position', Color(255, 230, 0))
HUD_MINIMAP.Preview = function(self, w, h, settings)
	GTA3HUD.radar.DrawPreview(w, h, settings.minimap.colour, settings.minimap.background, nil, GTA3HUD.LCS.RADAR_CENTER)
end

local HUD_STATS = HUD:Element('stats', '#gta3hud.menu.common.stats', Color(200, 200, 200), 0, 186)
HUD_STATS:Parameter('altCol', '#gta3hud.menu.common.stats.alternate_colour', Color(50, 70, 120))
HUD_STATS.Preview = function(self, w, h, settings)
	local x, y = (w * .5) + 110, 18
	GTA3HUD.LCS.GAMETEXT:DrawText(string.format('%s 2/6', language.GetPhrase('gta3hud.menu.lcs.stats.sample.1')), x, y, settings.stats.colour, 1, 1, TEXT_ALIGN_RIGHT)
	GTA3HUD.LCS.DrawProgressStat('#gta3hud.menu.lcs.stats.sample.2', 0.4, x, y + 48, settings.stats.altCol)
end

local PREVIEW = { '#gta3hud.menu.gta3.taskresult.sample.1', '#gta3hud.menu.gta3.taskresult.sample.2' }
local HUD_TASKRESULT = HUD:Element('taskresult', '#gta3hud.menu.common.taskresult', Color(210, 185, 65), 0, 0)
HUD_TASKRESULT:Parameter('altCol', '#gta3hud.menu.sa.taskresult.alt_colour', Color(150, 0, 0))
HUD_TASKRESULT:Parameter('deathMargin', '#gta3hud.menu.lcs.taskresult.death_margin', 92)
HUD_TASKRESULT.Preview = function(self, w, h, settings)
	local x, y = w * .5, 40
	GTA3HUD.LCS.DrawTaskResult(x, y, PREVIEW, 1, settings.taskresult.colour, 0.66)
end

local PREVIEW = { language.GetPhrase('gta3hud.menu.sa.taskmessage.sample.1'), true, language.GetPhrase('gta3hud.menu.sa.taskmessage.sample.2'), NULL, language.GetPhrase('gta3hud.menu.sa.taskmessage.sample.3') }
local PREVIEW_STRING = PREVIEW[1] .. PREVIEW[3] .. PREVIEW[5]
local HUD_TASKMESSAGE = HUD:Element('taskmessage', '#gta3hud.menu.common.taskmessage', Color(200, 200, 200), 16, 80)
HUD_TASKMESSAGE:Parameter('altCol', '#gta3hud.menu.common.taskmessage.alt_colour', Color(200, 0, 0))
HUD_TASKMESSAGE.Preview = function(self, w, h, settings)
	local x, y = w * .5, h * .5 + 20
	GTA3HUD.LCS.DrawTaskMessage(x, y, PREVIEW, PREVIEW_STRING, settings.taskmessage.colour, settings.taskmessage.altCol, 1)
end

-- [[ Import San Andreas weapon icons ]] --
HUD.weapons = GTA3HUD.SA.icons.weapons
HUD.worldmodels = GTA3HUD.SA.icons.worldmodels

-- [[ Replace default elements with visible ones ]] --
function HUD:HUDShouldDraw(settings, element)
	if element == 'CHudHealth' and settings.health.visible then return false end
	if element == 'CHudBattery' and settings.armour.visible then return false end
	if (element == 'CHudAmmo' or element == 'CHudSecondaryAmmo') and settings.weapon.visible then return false end
	if element == 'CHudDamageIndicator' and settings.wasted.visible and LocalPlayer and LocalPlayer().Alive and not LocalPlayer():Alive() then return false end
	if element == 'CHudSuitPower' and settings.stats.visible then return false end
end

-- [[ Back to Liberty City ]] --
local BLINK_WARNING = GTA3HUD.blink.Create(BLINK_SLOW)
local BLINK_ARMOUR = GTA3HUD.blink.Create(BLINK_FAST)
local BLINK_STARS = GTA3HUD.blink.Create(BLINK_FAST)
local lastArmour, armourTime = 0, 0
local lastStars, starsTime = 0, 0
local blipColours = {}
function HUD:Draw(settings, scale)
	scale = scale or 1
	local x, y = ScrW() - settings.x * scale, settings.y * scale
	local health, maxHealth = LocalPlayer():Health(), LocalPlayer():GetMaxHealth()
	local armour, maxArmour = LocalPlayer():Armor(), LocalPlayer():GetMaxArmor()
	local hours, minutes = hook.Run('GTA3HUD_GetTime')
	if not hours or not minutes then hours, minutes = TIME_FETCH[settings.time.source]() end
	local money = GTA3HUD.money.GetMoney(GTA3HUD.money.UserValue(settings.money.source, settings.money.input) * settings.money.multiplier, not settings.money.animation)
	local stars = GTA3HUD.wanted.GetWantedLevel()

	-- blip colours
	blipColours.friend = settings.minimap.friend
	blipColours.hostile = settings.minimap.hostile
	blipColours.position = settings.minimap.position
	blipColours.entities = settings.minimap.entities

	-- animations
	if armour ~= lastArmour then
		if armour < lastArmour then armourTime = CurTime() + BLINK_DURATION end
		lastArmour = armour
	end
	if stars ~= lastStars then
		starsTime = CurTime() + BLINK_DURATION
		lastStars = stars
	end

	-- blinking
	BLINK_WARNING:SetActive(health <= settings.health.warning)
	BLINK_WARNING:Run()
	BLINK_ARMOUR:SetActive(armourTime > CurTime())
	BLINK_ARMOUR:Run()
	BLINK_STARS:SetActive(starsTime > CurTime())
	BLINK_STARS:Run()

	-- draw
	local weapon = LocalPlayer():GetActiveWeapon()
	if settings.weapon.visible then GTA3HUD.LCS.DrawWeapon(weapon, GTA3HUD.SA.WEAPONS, x - settings.weapon.x * scale, y + settings.weapon.y * scale, settings.weapon.colour, settings.weapon.iconCol, settings.weapon.ammoCol, scale) end
	if settings.time.visible then GTA3HUD.LCS.DrawTime(hours, minutes, x - settings.time.x * scale, y + settings.time.y * scale, settings.time.colour, scale) end
	if settings.armour.visible and armour > 0 and not BLINK_ARMOUR:IsBlinking() then GTA3HUD.LCS.DrawBar(armour / maxArmour, x - settings.armour.x * scale, y + settings.armour.y * scale, BAR_WIDTH, BAR_HEIGHT, settings.armour.colour, scale, math.max(armour, maxArmour) > 100, settings.armour.alternate) end
	if settings.health.visible and not BLINK_WARNING:IsBlinking() then GTA3HUD.LCS.DrawBar(health / maxHealth, x - settings.health.x * scale, y + settings.health.y * scale, BAR_WIDTH, BAR_HEIGHT, settings.health.colour, scale, math.max(health, maxHealth) > 100, settings.health.alternate) end
	if settings.money.visible then GTA3HUD.LCS.DrawMoney(money, x - settings.money.x * scale, y + settings.money.y * scale, settings.money.colour, scale) end
	if settings.stars.visible and not BLINK_STARS:IsBlinking() then GTA3HUD.LCS.DrawStars(stars, x - settings.stars.x * scale, y + settings.stars.y * scale, settings.stars.colour, scale) end
	if settings.stats.visible then GTA3HUD.LCS.DrawStats(x - settings.stats.x * scale, y + settings.stats.y * scale, settings.stats.colour, settings.stats.altCol, scale) end

	-- wasted
	if settings.wasted.visible and GTA3HUD.util.IsWasted() then
		GTA3HUD.LCS.DrawWasted(settings.wasted.label, ScrW() * .5 + settings.wasted.x * scale, ScrH() * .5 + settings.wasted.y * scale, settings.wasted.colour, math.min(GTA3HUD.util.DeathTime() * 2, 1), scale)
	end

	-- task result
	if settings.taskresult.visible and GTA3HUD.taskresult.GetOpacity() > 0 then
		if GTA3HUD.taskresult.ShouldMusicSound() then GTA3HUD.taskresult.PlayMusic(self.SOUND_MISSIONPASSED) end
		local colour = settings.taskresult.colour
		if GTA3HUD.taskresult.GetType() == GTA3HUD.taskresult.RESULT_FAILURE and settings.taskresult.altCol then colour = settings.taskresult.altCol end
		local offset = settings.taskresult.y
		if settings.wasted.visible and LocalPlayer().Alive and not LocalPlayer():Alive() then offset = offset + settings.taskresult.deathMargin end
		GTA3HUD.LCS.DrawTaskResult(ScrW() * .5 + settings.taskresult.x * scale, ScrH() * .5 + offset * scale, GTA3HUD.taskresult.GetLines(), GTA3HUD.taskresult.GetOpacity(), colour, scale)
	end

	-- task message
	if settings.taskmessage.visible and GTA3HUD.taskmessage.ShouldDraw() then
		GTA3HUD.LCS.DrawTaskMessage(ScrW() * .5 + settings.taskmessage.x * scale, y + ScrH() - settings.taskmessage.y * scale, GTA3HUD.taskmessage.Get(), GTA3HUD.taskmessage.GetString(), settings.taskmessage.colour, settings.taskmessage.altCol, scale)
	end

	-- radar
	if not settings.minimap.visible then return end
	GTA3HUD.radar.Draw(settings.minimap.x * scale, ScrH() - settings.minimap.y * scale, settings.minimap.colour, settings.minimap.radius, settings.minimap.background, blipColours, scale, nil, GTA3HUD.LCS.RADAR_CENTER)
end

-- [[ Wasted animation ]] --
function HUD:CalcView(settings, _player, origin, angles, fov, znear, zfar)
	if not settings.wasted.visible or not settings.wasted.camera or not GTA3HUD.util.IsWasted() then return end
	return GTA3HUD.LCS.WastedView(_player, origin, angles, fov, znear, zfar)
end

GTA3HUD.LCS.ID =GTA3HUD.hud.Register('Liberty City Stories', HUD)
