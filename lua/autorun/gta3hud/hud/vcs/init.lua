--[[------------------------------------------------------------------
	Grand Theft Auto: Vice City Stories
]]--------------------------------------------------------------------

if SERVER then return end

GTA3HUD.VCS = {} -- namespace

local HUD = GTA3HUD.settings.Copy(GTA3HUD.hud.Get(GTA3HUD.LCS.ID))

HUD.SOUND_MISSIONPASSED = 'gta3hud/vcs/mission_passed.mp3'

HUD.properties.armour.properties.colour.default = Color(100, 190, 250)
HUD.properties.health.properties.colour.default = Color(255, 150, 225)
HUD.properties.wasted.properties.colour.default = Color(0, 160, 110)
HUD.properties.minimap.properties.friend.default = Color(20, 20, 120)
HUD.properties.minimap.properties.hostile.default = Color(120, 20, 20)
HUD.properties.minimap.properties.entities.default = Color(40, 70, 50)
HUD.properties.minimap.properties.position.default = Color(120, 70, 90)
HUD.properties.stats.properties.altCol.default = Color(100, 190, 250)
HUD.properties.taskresult.properties.colour.default = Color(255, 150, 225)
HUD.properties.taskresult.properties.altCol = nil

GTA3HUD.VCS.ID = GTA3HUD.hud.Register('Vice City Stories', HUD)
