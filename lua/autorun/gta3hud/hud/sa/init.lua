--[[------------------------------------------------------------------
	Grand Theft Auto: San Andreas
]]--------------------------------------------------------------------

if CLIENT then GTA3HUD.SA = {} end

GTA3HUD.include('draw.lua')
GTA3HUD.include('resources.lua')

if SERVER then return end

local HUD = GTA3HUD.hud.Create()

-- [[ Export icons ]] --
GTA3HUD.SA.icons = { weapons = HUD.weapons, worldmodels = HUD.worldmodels }

-- [[ Constants ]] --
local BLINK_FAST, BLINK_SLOW = .14, .33
local BLINK_DURATION = 3
local BAR_WIDTH, MAX_BAR_WIDTH, BAR_HEIGHT = 109, 191, 16

-- [[ Settings ]] --
HUD:Parameter('x', 'Horizontal offset', 57)
HUD:Parameter('y', 'Vertical offset', 52)

-- [[ Properties ]] --
local offset = math.random(0, 23)
local DAY, MINUTE = 1440, 60
local TIME_FETCH = { GTA3HUD.util.OSTime, GTA3HUD.util.GameSession }
local HUD_TIME = HUD:Element('time', '#gta3hud.menu.common.time', Color(215, 215, 215), 0, 0)
HUD_TIME:Option('source', '#gta3hud.menu.common.time.source', {'#gta3hud.menu.common.time.source.1', '#gta3hud.menu.common.time.source.2'}, 1)
HUD_TIME.Preview = function(self, w, h, settings)
	local x, y = (w * .5) + 52, (h * .5) - 10
	local curtime = CurTime() + MINUTE * offset
	local days = math.floor(curtime / DAY)
	local time = curtime - days * DAY
	local hours = math.floor(time / MINUTE)
	local minutes = time - hours * MINUTE
	GTA3HUD.SA.DrawTime(hours, minutes, x, y, settings.time.colour, 1, true)
end

local preview = 0
local HUD_ARMOUR = HUD:Element('armour', '#gta3hud.menu.common.armour', Color(185, 185, 185), 0, 28)
HUD_ARMOUR.Preview = function(self, w, h, settings)
	local x, y = (w * .5) + 56, (h * .5) - 8
	if preview < CurTime() then preview = CurTime() + 10 end
	local armour = math.Clamp((preview - 2) - CurTime(), 0, 7)
	GTA3HUD.SA.DrawBar(armour, x, y, BAR_WIDTH, BAR_HEIGHT, settings.armour.colour)
end

local preview = 0
local HUD_AUXPOW = HUD:Element('auxpow', '#gta3hud.menu.sa.auxpow', Color(170, 200, 240), 0, 47)
HUD_AUXPOW.Preview = function(self, w, h, settings)
	local x, y = (w * .5) + 56, (h * .5) - 8
	if preview < CurTime() then preview = CurTime() + 10 end
	local auxpow = math.Clamp((preview - 2) - CurTime(), 0, 7)
	GTA3HUD.SA.DrawBar(auxpow, x, y, BAR_WIDTH, BAR_HEIGHT, settings.auxpow.colour)
end

local preview, extended, time = 0, true, 0
local PREVIEW_BLINK = GTA3HUD.blink.Create(BLINK_SLOW)
local HUD_HEALTH = HUD:Element('health', '#gta3hud.menu.common.health', Color(210, 40, 40), 0, 66)
HUD_HEALTH:Range('warning', '#gta3hud.menu.common.health.warning', 10, 0, 100)
HUD_HEALTH:Parameter('resize', '#gta3hud.menu.sa.health.resize', true)
HUD_HEALTH:Parameter('move', '#gta3hud.menu.sa.health.move', true)
HUD_HEALTH.Preview = function(self, w, h, settings)
	local barw, warning = BAR_WIDTH, settings.health.warning
	if extended then
		barw = barw * 2
		warning = warning * .5
	end
	local x, y = (w * .5) + barw * .5, (h * .5) - 8
	if preview < CurTime() then
		extended = not extended
		if not extended then
			time = 10
		else
			time = 20
		end
		preview = CurTime() + time
		health = 1
	end
	local health = ((preview - 2) - CurTime()) / (time - 3)
	PREVIEW_BLINK:SetActive(health <= warning * .01)
	PREVIEW_BLINK:Run()
	if PREVIEW_BLINK:IsBlinking() then return end
	GTA3HUD.SA.DrawBar(health, x, y, barw, BAR_HEIGHT, settings.health.colour)
end

local HUD_WEAPON = HUD:Element('weapon', '#gta3hud.menu.common.weapon', Color(0, 0, 0), 111, -14)
HUD_WEAPON:Parameter('iconCol', '#gta3hud.menu.sa.weapon.icon_colour', Color(200, 200, 200))
HUD_WEAPON:Parameter('ammoCol', '#gta3hud.menu.common.weapon.ammo_colour', Color(170, 200, 255))
HUD_WEAPON.Preview = function(self, w, h, settings)
	local x, y = (w * .5) + 43, (h * .5) - 45
	GTA3HUD.SA.DrawWeapon(LocalPlayer():GetActiveWeapon(), GTA3HUD.SA.WEAPONS, x, y, settings.weapon.colour, settings.weapon.iconCol, settings.weapon.ammoCol, 1, true)
end

local preview = 0
local HUD_MONEY = HUD:Element('money', '#gta3hud.menu.common.money', Color(70, 120, 50), 0, 95)
HUD_MONEY:Parameter('animation', '#gta3hud.menu.common.money.animation', true)
HUD_MONEY:Option('source', '#gta3hud.menu.common.money.source', GTA3HUD.money.MODES, 1)
HUD_MONEY:Parameter('multiplier', '#gta3hud.menu.common.money.multiplier', 1)
HUD_MONEY:Parameter('input', '#gta3hud.menu.common.money.input', 0)
HUD_MONEY.Preview = function(self, w, h, settings)
	local x, y = (w * .5) + 86, (h * .5) - 10
	preview = preview + 32
	if preview >= 99999999 then preview = 0 end
	GTA3HUD.SA.DrawMoney(math.floor(preview), x, y, settings.money.colour, 1, true)
end

local preview = 0
local PREVIEW_BLINK = GTA3HUD.blink.Create(BLINK_FAST)
local HUD_STARS = HUD:Element('stars', '#gta3hud.menu.common.stars', Color(160, 120, 30), -2, 124)
HUD_STARS:Range('opacity', '#gta3hud.menu.sa.stars.opacity', 0.6, 0, 1, true)
HUD_STARS.Preview = function(self, w, h, settings)
	local x, y = (w * .5) + 95, (h * .5) - 18
	if preview < CurTime() then preview = CurTime() + 10 end
	PREVIEW_BLINK:SetActive((preview - CurTime()) > 2)
	PREVIEW_BLINK:Run()
	GTA3HUD.SA.DrawStars(6 - math.floor(math.max((preview - 3) - CurTime(), 0)) * (6 / 7), x, y, settings.stars.colour, settings.stars.opacity, 1, PREVIEW_BLINK:IsBlinking(), true)
end

local HUD_WASTED = HUD:Element('wasted', '#gta3hud.menu.sa.wasted', Color(215, 215, 215), 0, 64)
HUD_WASTED:Parameter('camera', '#gta3hud.menu.common.wasted.camera', true)
HUD_WASTED:Parameter('label', '#gta3hud.menu.common.wasted.label', '#gta3hud.menu.sa.wasted.default')
HUD_WASTED.Preview = function(self, w, h, settings)
	local x, y = w * .5, (h * .5) + 60
	GTA3HUD.SA.DrawWasted(settings.wasted.label, x, y, settings.wasted.colour, 1, 1, true)
end

local HUD_MINIMAP = HUD:Element('minimap', '#gta3hud.menu.common.radar', Color(0, 0, 0), 52, 34)
HUD_MINIMAP:Parameter('radius', '#gta3hud.menu.common.radar.radius', 110)
HUD_MINIMAP:Parameter('background', '#gta3hud.menu.common.radar.minimap', true)
HUD_MINIMAP:Parameter('friend', '#gta3hud.menu.sa.radar.friends', Color(26, 236, 26))
HUD_MINIMAP:Parameter('hostile', '#gta3hud.menu.sa.radar.hostiles', Color(236, 16, 16))
HUD_MINIMAP:Parameter('entities', '#gta3hud.menu.common.radar.entities', Color(16, 200, 255))
HUD_MINIMAP:Parameter('position', '#gta3hud.menu.common.radar.position', Color(220, 220, 60))
HUD_MINIMAP.Preview = function(self, w, h, settings)
	GTA3HUD.radar.DrawPreview(w, h, settings.minimap.colour, settings.minimap.background)
end

local HUD_STATS = HUD:Element('stats', '#gta3hud.menu.common.stats', Color(235, 235, 235), 0, 220)
HUD_STATS:Parameter('altCol', '#gta3hud.menu.common.stats.alternate_colour', Color(170, 200, 240))
HUD_STATS.Preview = function(self, w, h, settings)
	local x, y = (w * .5) + 132, 26
	GTA3HUD.SA.DrawTextStat('#gta3hud.menu.sa.radar.sample.1', '02:16', x, y, settings.stats.colour, 1, settings.outline)
	GTA3HUD.SA.DrawProgressStat('#gta3hud.menu.sa.radar.sample.2:', .9, x, y + 43, settings.stats.altCol, 1, settings.outline)
end

local PREVIEW = { '#gta3hud.menu.gta3.taskresult.sample.1', '#gta3hud.menu.gta3.taskresult.sample.2' }
local HUD_TASKRESULT = HUD:Element('taskresult', '#gta3hud.menu.common.taskresult', Color(120, 80, 20), 0, -8)
HUD_TASKRESULT:Parameter('altCol', '#gta3hud.menu.sa.taskresult.alt_colour', Color(220, 0, 0))
HUD_TASKRESULT:Parameter('subCol', '#gta3hud.menu.sa.taskresult.subtitle_colour', Color(200, 200, 200))
HUD_TASKRESULT.Preview = function(self, w, h, settings)
	local x, y = w * .5, 42
	GTA3HUD.SA.DrawTaskResult(x, y, PREVIEW, 1, settings.taskresult.colour, settings.taskresult.subCol, 1, true)
end

local PREVIEW = { language.GetPhrase('gta3hud.menu.sa.taskmessage.sample.1'), true, language.GetPhrase('gta3hud.menu.sa.taskmessage.sample.2'), NULL, language.GetPhrase('gta3hud.menu.sa.taskmessage.sample.3') }
local PREVIEW_STRING = PREVIEW[1] .. PREVIEW[3] .. PREVIEW[5]
local HUD_TASKMESSAGE = HUD:Element('taskmessage', '#gta3hud.menu.common.taskmessage', Color(200, 200, 200), 32, 164)
HUD_TASKMESSAGE:Parameter('altCol', '#gta3hud.menu.common.taskmessage.alt_colour', Color(200, 0, 0))
HUD_TASKMESSAGE.Preview = function(self, w, h, settings)
	local x, y = w * .5, h * .5 + 20
	GTA3HUD.SA.DrawTaskMessage(x, y, PREVIEW, PREVIEW_STRING, settings.taskmessage.colour, settings.taskmessage.altCol, 1, true)
end

-- [[ Replace default elements with visible ones ]] --
function HUD:HUDShouldDraw(settings, element)
	if element == 'CHudHealth' and settings.health.visible then return false end
	if element == 'CHudBattery' and settings.armour.visible then return false end
	if (element == 'CHudAmmo' or element == 'CHudSecondaryAmmo') and settings.weapon.visible then return false end
	if element == 'CHudDamageIndicator' and settings.wasted.visible and LocalPlayer and LocalPlayer().Alive and not LocalPlayer():Alive() then return false end
	if element == 'CHudSuitPower' and settings.auxpow.visible then return false end
end

-- [[ Grove Street. Home. ]] --
local BLINK_WARNING = GTA3HUD.blink.Create(BLINK_SLOW)
local BLINK_STARS = GTA3HUD.blink.Create(BLINK_FAST)
local lastStars, starsTime = 0, 0
local blipColours = { useTeamColour = true }
function HUD:Draw(settings, scale)
	scale = scale or 1
	local x, y = ScrW() - settings.x * scale, settings.y * scale
	local health, maxHealth = LocalPlayer():Health(), LocalPlayer():GetMaxHealth()
	local auxpow = hook.Run('GTA3HUD_GetSuitPower') or (LocalPlayer():GetSuitPower() * .01)
	local armour = LocalPlayer():Armor() / LocalPlayer():GetMaxArmor()
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
	BLINK_WARNING:SetActive(health <= settings.health.warning)
	BLINK_WARNING:Run()
	BLINK_STARS:SetActive(starsTime > CurTime())
	BLINK_STARS:Run()
	if stars ~= lastStars then
		starsTime = CurTime() + BLINK_DURATION
		lastStars = stars
	end

	-- draw
	local weapon = LocalPlayer():GetActiveWeapon()
	if settings.weapon.visible then GTA3HUD.SA.DrawWeapon(weapon, GTA3HUD.SA.WEAPONS, x - settings.weapon.x * scale, y + settings.weapon.y * scale, settings.weapon.colour, settings.weapon.iconCol, settings.weapon.ammoCol, scale) end
	if settings.time.visible then GTA3HUD.SA.DrawTime(hours, minutes, x - settings.time.x * scale, y + settings.time.y * scale, settings.time.colour, scale) end
	if settings.armour.visible and armour > 0 then GTA3HUD.SA.DrawBar(armour, x - settings.armour.x * scale, y + settings.armour.y * scale, BAR_WIDTH * scale, BAR_HEIGHT * scale, settings.armour.colour, scale) end
	if settings.auxpow.visible and auxpow < 1 then GTA3HUD.SA.DrawBar(auxpow, x - settings.auxpow.x * scale, y + settings.auxpow.y * scale, BAR_WIDTH * scale, BAR_HEIGHT * scale, settings.auxpow.colour, scale) end
	if settings.health.visible then
		if settings.health.move and math.max(health, maxHealth) > 100 then y = y + 19 * scale end
		if not BLINK_WARNING:IsBlinking() then GTA3HUD.SA.DrawBar(health / maxHealth, x - settings.health.x * scale, y + settings.health.y * scale, math.min(BAR_WIDTH * math.max(health, maxHealth) * .01, MAX_BAR_WIDTH) * scale, BAR_HEIGHT * scale, settings.health.colour, scale) end
	end
	if settings.money.visible then GTA3HUD.SA.DrawMoney(money, x - settings.money.x * scale, y + settings.money.y * scale, settings.money.colour, scale) end
	if settings.stars.visible and stars > 0 and not BLINK_STARS:IsBlinking() then GTA3HUD.SA.DrawStars(stars, x - settings.stars.x * scale, y + settings.stars.y * scale, settings.stars.colour, settings.stars.opacity, scale) end
	if settings.stats.visible then GTA3HUD.SA.DrawStats(x - settings.stats.x * scale, y + settings.stats.y * scale, settings.stats.colour, settings.stats.altCol, scale) end

	-- wasted
	if settings.wasted.visible and GTA3HUD.util.IsWasted() then
		GTA3HUD.SA.DrawWasted(settings.wasted.label, ScrW() * .5 + settings.wasted.x * scale, ScrH() * .5 - settings.wasted.y * scale, settings.wasted.colour, math.min(GTA3HUD.util.DeathTime(), 1), scale)
	end

	-- task result
	if settings.taskresult.visible and GTA3HUD.taskresult.GetOpacity() > 0 then
		if GTA3HUD.taskresult.ShouldMusicSound() then GTA3HUD.taskresult.PlayMusic(GTA3HUD.SA.SOUND_MISSIONPASSED) end
		local colour = settings.taskresult.colour
		if GTA3HUD.taskresult.GetType() == GTA3HUD.taskresult.RESULT_FAILURE then colour = settings.taskresult.altCol end
		GTA3HUD.SA.DrawTaskResult(ScrW() * .5 + settings.taskresult.x * scale, ScrH() * .5 + settings.taskresult.y * scale, GTA3HUD.taskresult.GetLines(), GTA3HUD.taskresult.GetOpacity(), colour, settings.taskresult.subCol, scale)
	end

	-- task message
	if settings.taskmessage.visible and GTA3HUD.taskmessage.ShouldDraw() then
		GTA3HUD.SA.DrawTaskMessage(ScrW() * .5 + settings.taskmessage.x * scale, y + ScrH() - settings.taskmessage.y * scale, GTA3HUD.taskmessage.Get(), GTA3HUD.taskmessage.GetString(), settings.taskmessage.colour, settings.taskmessage.altCol, scale)
	end

	-- radar
	if not settings.minimap.visible then return end
	GTA3HUD.radar.Draw(settings.minimap.x * scale, ScrH() - settings.minimap.y * scale, settings.minimap.colour, settings.minimap.radius, settings.minimap.background, blipColours, scale)
end

-- [[ Wasted animation ]] --
function HUD:CalcView(settings, _player, origin, angles, fov, znear, zfar)
	if not settings.wasted.visible or not settings.wasted.camera or not GTA3HUD.util.IsWasted() then return end
	return GTA3HUD.VC.WastedView(_player, origin, angles, fov, znear, zfar)
end

GTA3HUD.SA.ID =GTA3HUD.hud.Register('San Andreas', HUD)
