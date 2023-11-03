
if SERVER then return end

-- [[ Sounds ]] --
GTA3HUD.VC.SOUND_MISSIONPASSED = 'gta3hud/vc/mission_passed.mp3'

-- [[ Font 1 ]] --
local ATLAS1_MAPPING = {
  {
    '!b', '!', '"', '#', '$', '%', '&', '\'', '(', ')', '*', NULL, ',', '-', '.', '/',
    '0', NULL, '2', '3', '4', '5', '6', '7', '8', '9', ':', ';', 'shield', '=', 'star', '?',
    NULL, 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O',
    'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '[', '\\', ']', '¡', 'º',
    '`', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
    'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'heart', '|', '$b', '(b', ')b',
    'À', 'Á', 'Â', 'Ä', 'Æ', 'Ç', 'È', 'É', 'Ê', 'Ë', 'Ì', 'Í', 'Î', 'Ï', 'Ò', 'Ó',
    'Ô', 'Ö', 'Ù', 'Ú', 'Û', 'Ü', 'ß', 'à', 'á', 'â', 'ä', 'æ', 'ç', 'è', 'é', 'ê',
    'ë', 'ì', 'í', 'î', 'ï', 'ò', 'ó', 'ö', 'ô', 'ù', 'ú', 'û', 'ü', 'Ñ', 'ñ', '¿',
    '0b', '1b', '2b', '3b', '4b', '5b', '6b', '7b', '8b', '9b', ':b', 'ab', 'bb', 'cb', 'db', 'eb',
    'fb', 'gb', 'hb', 'ib', 'jb', 'kb', 'lb', 'mb', 'nb', 'ob', 'pb', 'qb', 'rb', 'sb', 'tb', 'ub',
    'vb', 'wb', 'xb', 'yb', 'zb', 'àb', 'áb', 'âb', 'äb', 'æb', 'çb', 'èb', 'éb', 'êb', 'ëb', 'ìb'
  },
  { 'íb', 'îb', 'ïb', 'òb', 'ób', 'ôb', 'öb', 'ùb', 'úb', 'ûb', 'üb', 'ßb', 'ñb', NULL, '\'b', '.b' }
}
local ATLAS1 = GTA3HUD.draw.Atlas(Material('gta3hud/vc/font1.png'), 512, 512)
ATLAS1:Add(' ', 12, 0, 8, 40)
ATLAS1:Add('1', 26, 40, 32, 40)
ATLAS1:Add('+', 32 * 11, 2, 32, 40)
local cursor = ATLAS1:Cursor(0, 0, 32, 40)
cursor:Bulk(ATLAS1_MAPPING[1], 31)
cursor:Bulk(ATLAS1_MAPPING[2], 31, 32)
GTA3HUD.VC.ATLAS1 = ATLAS1 -- export atlas

-- outlined variant atlas
local ATLAS1_OUTLINED = GTA3HUD.draw.Atlas(Material('gta3hud/vc/outlined/font1.png'), 576, 576)
ATLAS1_OUTLINED:Add(' ', 12, 2, 8, 42)
ATLAS1_OUTLINED:Add('1', 27, 44, 34, 42)
ATLAS1_OUTLINED:Add('+', 34 * 11, 3, 34, 42)
local cursor = ATLAS1_OUTLINED:Cursor(0, 0, 36, 44)
cursor:Bulk(ATLAS1_MAPPING[1], 34, 42)
cursor:Bulk(ATLAS1_MAPPING[2], 34, 42)
GTA3HUD.VC.ATLAS1_OUTLINED = ATLAS1_OUTLINED -- export atlas

-- create arborcrest font
local ARBORCREST = ATLAS1:Font()
ARBORCREST:Bulk({
  '!', '\'', ')', ',', '.', ':', ';', '¡', 'º', '`', 'I', 'i', 'j', 'l', '|'
}, 5)
ARBORCREST:Bulk({
  '$', '%', '&', '*', '+', '/',
  '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '=', '?',
  'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'N', 'O',
  'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'X', 'Y', 'Z', '[', '\\', ']',
  'À', 'Á', 'Â', 'Ä', 'Ç', 'È', 'É', 'Ê', 'Ë', 'Ò', 'Ó',
  'Ô', 'Ö', 'Ù', 'Ú', 'Û', 'Ü', 'ß', 'Ñ', '¿'
}, 20)
ARBORCREST:Bulk({
  'a', 'b', 'c', 'd', 'e', 'g', 'h', 'k', 'n', 'o',
  'p', 'q', 's', 'u', 'v', 'x', 'y', 'z',
  'à', 'á', 'â', 'ä', 'ç', 'è', 'é', 'ê',
  'ë', 'ì', 'í', 'î', 'ï', 'ò', 'ó', 'ö', 'ô', 'ù', 'ú', 'û', 'ü', 'ñ'
}, 16)
ARBORCREST:Add('(', 7)
ARBORCREST:Bulk({'f', 't', 'r', '-'}, 13)
ARBORCREST:Bulk({'m', 'w'}, 23)
ARBORCREST:Bulk({'M', 'Æ', 'æ'}, 25)
ARBORCREST:Bulk({' ', 'Ì', 'Í', 'Î', 'Ï'}, 8)
ARBORCREST:Add('W', 29)
ARBORCREST:Add('"', 9)
ARBORCREST:Add('#', 16)
GTA3HUD.VC.ARBORCREST = ARBORCREST -- export font

-- create pricedown font
local PRICEDOWN_FORMAT = '%sb'
local PRICEDOWN = ATLAS1:Font()
PRICEDOWN:Add(' ', 8)
PRICEDOWN:Bulk({ '!', ',', '-', '.', 'i', 'ì', 'í', 'î', 'ï', '.' }, 8, nil, PRICEDOWN_FORMAT)
PRICEDOWN:Bulk({
  '$', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
  'a', 'b', 'c', 'd', 'e', 'g', 'h', 'j', 'k', 'n', 'o',
  'p', 'q', 'r', 's', 'u', 'v', 'x', 'y', 'z',
  'à', 'á', 'â', 'ä', 'ç', 'è', 'é', 'ê', 'ë', 'ò', 'ó',
  'ô', 'ö', 'ù', 'ú', 'û', 'ü', 'ß', 'ñ'
}, 18, nil, PRICEDOWN_FORMAT)
PRICEDOWN:Bulk({'m', 'æ'}, 28, nil, PRICEDOWN_FORMAT)
PRICEDOWN:Bulk({'(', ')'}, 13, nil, PRICEDOWN_FORMAT)
PRICEDOWN:Bulk({':', 'f'}, 16, nil, PRICEDOWN_FORMAT)
PRICEDOWN:Add('tb', 20, nil, 't')
PRICEDOWN:Add('wb', 31, nil, 'w')
PRICEDOWN:Add('\'b', 11, nil, '\'')
PRICEDOWN:Add('lb', 13, nil, 'l')
GTA3HUD.VC.PRICEDOWN = PRICEDOWN -- export font

-- [[ Unused font ]] --
--[[local ATLAS2 = GTA3HUD.draw.Atlas(Material('gta3hud/vc/font2.png'), 512, 512)
ATLAS2:Add(' ', 0, 0, 8, 40)
ATLAS2:Add('1', 26, 40, 32, 40)
ATLAS2:Cursor(0, 0, 32, 40):Bulk({
  ' ', '!', NULL, NULL, '$', '%', '&', '\'', '[', ']', NULL, '+', ',', '-', '.', NULL,
  '0', NULL, '2', '3', '4', '5', '6', '7', '8', '9', ':', NULL, NULL, NULL, NULL, '?',
  NULL, 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O',
  'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', NULL, '\\', NULL, '¡', NULL,
  NULL, 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
  'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', NULL, NULL, NULL, NULL, NULL,
  'À', 'Á', 'Â', 'Ä', 'Æ', 'Ç', 'È', 'É', 'Ê', 'Ë', 'Ì', 'Í', 'Î', 'Ï', 'Ò', 'Ó',
  'Ô', 'Ö', 'Ù', 'Ú', 'Û', 'Ü', 'ß', 'à', 'á', 'â', 'ä', 'æ', 'ç', 'è', 'é', 'ê',
  'ë', 'ì', 'í', 'î', 'ï', 'ò', 'ó', 'ö', 'ô', 'ù', 'ú', 'û', 'ü', 'Ñ', 'ñ', '¿'
}, 31)

-- create font
local RAGEITALIC = ATLAS2:Font()
RAGEITALIC:Bulk({
  ' ', '!', '1', '¡', 'i', 'l', 'o', 'ì', 'í', 'î', 'ï', 'ò', 'ó', 'ö', 'ô'
}, 10)
RAGEITALIC:Bulk({
  '0', '2', '3', '4', '5', '6', '7', '8', '9',
  'C', 'G', 'd', 'k', 't', 'u', 'Ç', 'ù', 'ú', 'û', 'ü'
}, 17)
RAGEITALIC:Bulk({
  '$', '%', '?', 'A', 'Q', 'n', 'À', 'Á', 'Â', 'Ä', 'ñ', '¿'
}, 18)
RAGEITALIC:Bulk({
  '[', ']', 'B', 'E', 'F', 'O', 'T', 'U', 'Y', 'Z',
  'È', 'É', 'Ê', 'Ë', 'Ò', 'Ó', 'Ô', 'Ö', 'Ù', 'Ú', 'Û', 'Ü', 'ß'
}, 19)
RAGEITALIC:Bulk({
  'D', 'H', 'K', 'L', 'R', 'S', 'V', 'm', 'p', 'æ'
}, 22)
RAGEITALIC:Bulk({
  'I', 'J', 'Ì', 'Í', 'Î', 'Ï'
}, 14)
RAGEITALIC:Bulk({'\'', ',', '.'}, 4)
RAGEITALIC:Bulk({'+', '-', '\\'}, 9)
RAGEITALIC:Bulk({'&', 'N', 'P', 'X', 'Ñ'}, 24)
RAGEITALIC:Bulk({
  'a', 'g', 'h', 'j', 'q', 'w', 'y', 'z', 'à', 'á', 'â', 'ä',
}, 15)
RAGEITALIC:Bulk({
  'b', 'c', 'e', 'f', 'r', 's', 'v', 'x', 'ç', 'è', 'é', 'ê',
  'ë'
}, 12)
RAGEITALIC:Bulk({'M', 'Æ'}, 31)
RAGEITALIC:Add(':', 5)
RAGEITALIC:Add('W', 27)

GTA3HUD.VC.RAGEITALIC = RAGEITALIC -- export font]]

-- [[ Weapon categories ]] --
GTA3HUD.VC.WEAPON_NONE				= 0
GTA3HUD.VC.WEAPON_MELEE				= 1
GTA3HUD.VC.WEAPON_HANDGUN			= 2
GTA3HUD.VC.WEAPON_SMG					= 3
GTA3HUD.VC.WEAPON_SHOTGUN			= 4
GTA3HUD.VC.WEAPON_ASSAULT			= 5
GTA3HUD.VC.WEAPON_SNIPER			= 6
GTA3HUD.VC.WEAPON_HEAVY				= 7
GTA3HUD.VC.WEAPON_THROWABLE		= 8
GTA3HUD.VC.WEAPON_TOOL				= 9

-- [[ Weapon icons ]] --
local WEAPONS = GTA3HUD.weapons.Create()
WEAPONS.database.types = { textures = {}, classes = {}, worldmodels = {} }

--[[------------------------------------------------------------------
	Assigns a category to a weapon icon.
  @param {string} registered weapon icon
  @param {WEAPON_} weapon category
]]--------------------------------------------------------------------
function WEAPONS:SetType(name, category)
  self.database.types.textures[name] = category
end

--[[------------------------------------------------------------------
	Assigns a category to a weapon class.
  @param {string} weapon class
  @param {WEAPON_} weapon category
]]--------------------------------------------------------------------
function WEAPONS:SetClassType(class, category)
  self.database.types.classes[class] = category
end

--[[------------------------------------------------------------------
	Assigns a category to a world model.
  @param {string} world model
  @param {WEAPON_} weapon category
]]--------------------------------------------------------------------
function WEAPONS:SetWorldModelType(worldmodel, category)
  self.database.types.worldmodels[worldmodel] = category
end

--[[------------------------------------------------------------------
	Registers a weapon icon alongside a category.
  @param {string} name
  @param {Material} texture
  @param {WEAPON_} weapon category
  @return {string} provided name
  @return {Material} provided texture
  @return {WEAPON_} provided weapon category
]]--------------------------------------------------------------------
local register = WEAPONS.Register
function WEAPONS:Register(name, texture, category)
  register(self, name, texture)
  self:SetType(name, category)
  return name, texture, category
end

--[[------------------------------------------------------------------
	Finds the adequate category for this weapon.
  @param {Weapon} weapon
  @return {WEAPON_} weapon category
]]--------------------------------------------------------------------
function WEAPONS:FindWeaponType(weapon)
  local classname = NULL
  if IsValid(weapon) then classname = weapon:GetClass() end
  local class = self.database.types.classes[classname]
  if class then return class end
  local worldmodel = self.database.types.worldmodels[weapon:GetModel()]
  if worldmodel then return worldmodel end
  return self.database.types.textures[self:FindWeaponIcon(weapon)]
end

-- register icon textures
local weapon_fists = WEAPONS:Register('fists', Material('gta3hud/vc/weapon_fists.png'), GTA3HUD.VC.WEAPON_NONE)
local weapon_physcannon = WEAPONS:Register('physcannon', Material('gta3hud/vc/weapon_physcannon.png'), GTA3HUD.VC.WEAPON_NONE)
local weapon_crowbar = WEAPONS:Register('crowbar', Material('gta3hud/vc/weapon_crowbar.png'), GTA3HUD.VC.WEAPON_MELEE)
local weapon_stunstick = WEAPONS:Register('stunstick', Material('gta3hud/vc/weapon_stunstick.png'), GTA3HUD.VC.WEAPON_MELEE)
local weapon_pistol = WEAPONS:Register('pistol', Material('gta3hud/vc/weapon_pistol.png'), GTA3HUD.VC.WEAPON_HANDGUN)
local weapon_357 = WEAPONS:Register('357', Material('gta3hud/vc/weapon_357.png'), GTA3HUD.VC.WEAPON_HANDGUN)
local weapon_alyxgun = WEAPONS:Register('alyxgun', Material('gta3hud/vc/weapon_alyxgun.png'), GTA3HUD.VC.WEAPON_HANDGUN)
local weapon_smg1 = WEAPONS:Register('smg1', Material('gta3hud/vc/weapon_smg1.png'), GTA3HUD.VC.WEAPON_smg)
local weapon_ar2 = WEAPONS:Register('ar2', Material('gta3hud/vc/weapon_ar2.png'), GTA3HUD.VC.WEAPON_ASSAULT)
local weapon_shotgun = WEAPONS:Register('shotgun', Material('gta3hud/vc/weapon_shotgun.png'), GTA3HUD.VC.WEAPON_SHOTGUN)
local weapon_crossbow = WEAPONS:Register('crossbow', Material('gta3hud/vc/weapon_crossbow.png'), GTA3HUD.VC.WEAPON_SNIPER)
local weapon_annabelle = WEAPONS:Register('annabelle', Material('gta3hud/vc/weapon_annabelle.png'), GTA3HUD.VC.WEAPON_SHOTGUN)
local weapon_frag = WEAPONS:Register('frag', Material('gta3hud/vc/weapon_frag.png'), GTA3HUD.VC.WEAPON_THROWABLE)
local weapon_rpg = WEAPONS:Register('rpg', Material('gta3hud/vc/weapon_rpg.png'), GTA3HUD.VC.WEAPON_HEAVY)
local weapon_slam = WEAPONS:Register('slam', Material('gta3hud/vc/weapon_slam.png'), GTA3HUD.VC.WEAPON_THROWABLE)
local weapon_bugbait = WEAPONS:Register('bugbait', Material('gta3hud/vc/weapon_bugbait.png'), GTA3HUD.VC.WEAPON_TOOL)
local weapon_toolgun = WEAPONS:Register('toolgun', Material('gta3hud/vc/weapon_toolgun.png'), GTA3HUD.VC.WEAPON_TOOL)
local weapon_knife = WEAPONS:Register('knife', Material('gta3hud/vc/weapon_knife.png'), GTA3HUD.VC.WEAPON_MELEE)
local weapon_glock = WEAPONS:Register('glock', Material('gta3hud/vc/weapon_glock.png'), GTA3HUD.VC.WEAPON_HANDGUN)
local weapon_usp = WEAPONS:Register('usp', Material('gta3hud/vc/weapon_usp.png'), GTA3HUD.VC.WEAPON_HANDGUN)
local weapon_usp_silenced = WEAPONS:Register('usp_silenced', Material('gta3hud/vc/weapon_usp_silenced.png'), GTA3HUD.VC.WEAPON_HANDGUN)
local weapon_p228 = WEAPONS:Register('p228', Material('gta3hud/vc/weapon_p228.png'), GTA3HUD.VC.WEAPON_HANDGUN)
local weapon_elite_single = WEAPONS:Register('elite_single', Material('gta3hud/vc/weapon_beretta.png'), GTA3HUD.VC.WEAPON_HANDGUN)
local weapon_elite = WEAPONS:Register('elites', Material('gta3hud/vc/weapon_dualies.png'), GTA3HUD.VC.WEAPON_HANDGUN)
local weapon_tec9 = WEAPONS:Register('tec9', Material('gta3hud/vc/weapon_tec9.png'), GTA3HUD.VC.WEAPON_HANDGUN)
local weapon_cz75 = WEAPONS:Register('cz75', Material('gta3hud/vc/weapon_cz75.png'), GTA3HUD.VC.WEAPON_HANDGUN)
local weapon_fiveseven = WEAPONS:Register('fiveseven', Material('gta3hud/vc/weapon_fiveseven.png'), GTA3HUD.VC.WEAPON_HANDGUN)
local weapon_deagle = WEAPONS:Register('deagle', Material('gta3hud/vc/weapon_deagle.png'), GTA3HUD.VC.WEAPON_HANDGUN)
local weapon_mac10 = WEAPONS:Register('mac10', Material('gta3hud/vc/weapon_mac10.png'), GTA3HUD.VC.WEAPON_SMG)
local weapon_tmp = WEAPONS:Register('tmp', Material('gta3hud/vc/weapon_tmp.png'), GTA3HUD.VC.WEAPON_SMG)
local weapon_mp5 = WEAPONS:Register('mp5', Material('gta3hud/vc/weapon_mp5.png'), GTA3HUD.VC.WEAPON_SMG)
local weapon_ump45 = WEAPONS:Register('ump45', Material('gta3hud/vc/weapon_ump45.png'), GTA3HUD.VC.WEAPON_SMG)
local weapon_p90 = WEAPONS:Register('p90', Material('gta3hud/vc/weapon_p90.png'), GTA3HUD.VC.WEAPON_SMG)
local weapon_ppbizon = WEAPONS:Register('ppbizon', Material('gta3hud/vc/weapon_ppbizon.png'), GTA3HUD.VC.WEAPON_SMG)
local weapon_m3super90 = WEAPONS:Register('m3super90', Material('gta3hud/vc/weapon_m3super90.png'), GTA3HUD.VC.WEAPON_SHOTGUN)
local weapon_nova = WEAPONS:Register('nova', Material('gta3hud/vc/weapon_nova.png'), GTA3HUD.VC.WEAPON_SHOTGUN)
local weapon_xm1014 = WEAPONS:Register('xm1014', Material('gta3hud/vc/weapon_xm1014.png'), GTA3HUD.VC.WEAPON_SHOTGUN)
local weapon_mag7 = WEAPONS:Register('mag7', Material('gta3hud/vc/weapon_mag7.png'), GTA3HUD.VC.WEAPON_SHOTGUN)
local weapon_sawedoff = WEAPONS:Register('sawedoff', Material('gta3hud/vc/weapon_sawedoff.png'), GTA3HUD.VC.WEAPON_SHOTGUN)
local weapon_galil = WEAPONS:Register('galil', Material('gta3hud/vc/weapon_galil.png'), GTA3HUD.VC.WEAPON_ASSAULT)
local weapon_famas = WEAPONS:Register('famas', Material('gta3hud/vc/weapon_famas.png'), GTA3HUD.VC.WEAPON_ASSAULT)
local weapon_ak47 = WEAPONS:Register('ak47', Material('gta3hud/vc/weapon_ak47.png'), GTA3HUD.VC.WEAPON_ASSAULT)
local weapon_m4a1 = WEAPONS:Register('m4a1', Material('gta3hud/vc/weapon_m4a1.png'), GTA3HUD.VC.WEAPON_ASSAULT)
local weapon_sg552 = WEAPONS:Register('sg552', Material('gta3hud/vc/weapon_sg552.png'), GTA3HUD.VC.WEAPON_ASSAULT)
local weapon_aug = WEAPONS:Register('aug', Material('gta3hud/vc/weapon_aug.png'), GTA3HUD.VC.WEAPON_ASSAULT)
local weapon_scar = WEAPONS:Register('scar', Material('gta3hud/vc/weapon_scar.png'), GTA3HUD.VC.WEAPON_ASSAULT)
local weapon_scout = WEAPONS:Register('scout', Material('gta3hud/vc/weapon_scout.png'), GTA3HUD.VC.WEAPON_SNIPER)
local weapon_awp = WEAPONS:Register('awp', Material('gta3hud/vc/weapon_awp.png'), GTA3HUD.VC.WEAPON_SNIPER)
local weapon_g3sg1 = WEAPONS:Register('g3sg1', Material('gta3hud/vc/weapon_g3sg1.png'), GTA3HUD.VC.WEAPON_SNIPER)
local weapon_sg550 = WEAPONS:Register('sg550', Material('gta3hud/vc/weapon_sg550.png'), GTA3HUD.VC.WEAPON_SNIPER)
local weapon_scar20 = WEAPONS:Register('scar20', Material('gta3hud/vc/weapon_scar20.png'), GTA3HUD.VC.WEAPON_SNIPER)
local weapon_m249 = WEAPONS:Register('m249', Material('gta3hud/vc/weapon_m249.png'), GTA3HUD.VC.WEAPON_HEAVY)
local weapon_negev = WEAPONS:Register('negev', Material('gta3hud/vc/weapon_negev.png'), GTA3HUD.VC.WEAPON_HEAVY)
local weapon_grenade = WEAPONS:Register('grenade', Material('gta3hud/vc/weapon_he.png'), GTA3HUD.VC.WEAPON_THROWABLE)
local weapon_molotov = WEAPONS:Register('molotov', Material('gta3hud/vc/weapon_molotov.png'), GTA3HUD.VC.WEAPON_THROWABLE)
local weapon_c4 = WEAPONS:Register('ied', Material('gta3hud/vc/weapon_c4.png'), GTA3HUD.VC.WEAPON_THROWABLE)
local weapon_zeus26 = WEAPONS:Register('zeus26', Material('gta3hud/vc/weapon_zeus26.png'), GTA3HUD.VC.WEAPON_MELEE)

-- Fists
WEAPONS:AddClass(NULL, weapon_fists)
WEAPONS:AddClass('weapon_fists', weapon_fists)
WEAPONS:AddClass('none', weapon_fists)
WEAPONS:AddClass('climb_swep2', weapon_fists)

-- Half-Life 2
WEAPONS:AddWorldModel('models/weapons/w_physics.mdl', weapon_physcannon)
WEAPONS:AddWorldModel('models/weapons/w_crowbar.mdl', weapon_crowbar)
WEAPONS:AddWorldModel('models/weapons/w_stunbaton.mdl', weapon_stunstick)
WEAPONS:AddWorldModel('models/weapons/w_pistol.mdl', weapon_pistol)
WEAPONS:AddWorldModel('models/weapons/w_357.mdl', weapon_357)
WEAPONS:AddWorldModel('models/weapons/w_alyx_gun.mdl', weapon_alyxgun)
WEAPONS:AddWorldModel('models/weapons/w_smg1.mdl', weapon_smg1)
WEAPONS:AddWorldModel('models/weapons/w_irifle.mdl', weapon_ar2)
WEAPONS:AddWorldModel('models/weapons/w_shotgun.mdl', weapon_shotgun)
WEAPONS:AddWorldModel('models/weapons/w_annabelle.mdl', weapon_annabelle)
WEAPONS:AddWorldModel('models/weapons/w_crossbow.mdl', weapon_crossbow)
WEAPONS:AddWorldModel('models/weapons/w_grenade.mdl', weapon_frag)
WEAPONS:AddWorldModel('models/weapons/w_rocket_launcher.mdl', weapon_rpg)
WEAPONS:AddWorldModel('models/weapons/w_slam.mdl', weapon_slam)
WEAPONS:AddWorldModel('models/weapons/w_bugbait.mdl', weapon_bugbait)
WEAPONS:AddWorldModel('models/weapons/w_toolgun.mdl', weapon_toolgun)

-- Counter-Strike: Source
WEAPONS:AddWorldModel('models/weapons/w_knife_ct.mdl', weapon_knife)
WEAPONS:AddWorldModel('models/weapons/w_knife_t.mdl', weapon_knife)
WEAPONS:AddWorldModel('models/weapons/w_pist_glock18.mdl', weapon_glock)
WEAPONS:AddWorldModel('models/weapons/w_pist_usp.mdl', weapon_usp)
WEAPONS:AddWorldModel('models/weapons/w_pist_usp_silenced.mdl', weapon_usp_silenced)
WEAPONS:AddWorldModel('models/weapons/w_pist_p228.mdl', weapon_p228)
WEAPONS:AddWorldModel('models/weapons/w_pist_elite_single.mdl', weapon_elite_single)
WEAPONS:AddWorldModel('models/weapons/w_pist_elite.mdl', weapon_elite)
WEAPONS:AddWorldModel('models/weapons/w_pist_fiveseven.mdl', weapon_fiveseven)
WEAPONS:AddWorldModel('models/weapons/w_pist_deagle.mdl', weapon_deagle)
WEAPONS:AddWorldModel('models/weapons/w_smg_mac10.mdl', weapon_mac10)
WEAPONS:AddWorldModel('models/weapons/w_smg_tmp.mdl', weapon_tmp)
WEAPONS:AddWorldModel('models/weapons/w_smg_mp5.mdl', weapon_mp5)
WEAPONS:AddWorldModel('models/weapons/w_smg_ump45.mdl', weapon_ump45)
WEAPONS:AddWorldModel('models/weapons/w_smg_p90.mdl', weapon_p90)
WEAPONS:AddWorldModel('models/weapons/w_shot_m3super90.mdl', weapon_m3super90)
WEAPONS:AddWorldModel('models/weapons/w_shot_xm1014.mdl', weapon_xm1014)
WEAPONS:AddWorldModel('models/weapons/w_rif_ak47.mdl', weapon_ak47)
WEAPONS:AddWorldModel('models/weapons/w_rif_galil.mdl', weapon_galil)
WEAPONS:AddWorldModel('models/weapons/w_rif_sg552.mdl', weapon_sg552)
WEAPONS:AddWorldModel('models/weapons/w_rif_m4a1.mdl', weapon_m4a1)
WEAPONS:AddWorldModel('models/weapons/w_rif_m4a1_silenced.mdl', weapon_m4a1)
WEAPONS:AddWorldModel('models/weapons/w_rif_famas.mdl', weapon_famas)
WEAPONS:AddWorldModel('models/weapons/w_rif_aug.mdl', weapon_aug)
WEAPONS:AddWorldModel('models/weapons/w_snip_scout.mdl', weapon_scout)
WEAPONS:AddWorldModel('models/weapons/w_snip_awp.mdl', weapon_awp)
WEAPONS:AddWorldModel('models/weapons/w_snip_g3sg1.mdl', weapon_g3sg1)
WEAPONS:AddWorldModel('models/weapons/w_snip_sg550.mdl', weapon_sg550)
WEAPONS:AddWorldModel('models/weapons/w_mach_m249para.mdl', weapon_m249)
WEAPONS:AddWorldModel('models/weapons/w_eq_flashbang.mdl', weapon_frag)
WEAPONS:AddWorldModel('models/weapons/w_eq_smokegrenade.mdl', weapon_frag)
WEAPONS:AddWorldModel('models/weapons/w_eq_fraggrenade.mdl', weapon_grenade)
WEAPONS:AddWorldModel('models/weapons/w_c4.mdl', weapon_c4)

-- Counter-Strike: Global Offensive (SWCS)
WEAPONS:AddClass('weapon_swcs_fists', weapon_fists)
WEAPONS:AddWorldModel('models/weapons/csgo/w_knife_gg.mdl', weapon_knife)
WEAPONS:AddWorldModel('models/weapons/csgo/w_knife_default_ct.mdl', weapon_knife)
WEAPONS:AddWorldModel('models/weapons/csgo/w_knife_default_t.mdl', weapon_knife)
WEAPONS:AddWorldModel('models/weapons/csgo/w_knife_butterfly.mdl', weapon_knife)
WEAPONS:AddWorldModel('models/weapons/csgo/w_knife_canis.mdl', weapon_knife)
WEAPONS:AddWorldModel('models/weapons/csgo/w_knife_cord.mdl', weapon_knife)
WEAPONS:AddWorldModel('models/weapons/csgo/w_knife_falchion_advanced.mdl', weapon_knife)
WEAPONS:AddWorldModel('models/weapons/csgo/w_knife_ghost.mdl', weapon_knife)
WEAPONS:AddWorldModel('models/weapons/csgo/w_knife_gypsy_jackknife.mdl', weapon_knife)
WEAPONS:AddWorldModel('models/weapons/csgo/w_knife_outdoor.mdl', weapon_knife)
WEAPONS:AddWorldModel('models/weapons/csgo/w_knife_push.mdl', weapon_knife)
WEAPONS:AddWorldModel('models/weapons/csgo/w_knife_skeleton.mdl', weapon_knife)
WEAPONS:AddWorldModel('models/weapons/csgo/w_knife_stiletto.mdl', weapon_knife)
WEAPONS:AddWorldModel('models/weapons/csgo/w_knife_survival_bowie.mdl', weapon_knife)
WEAPONS:AddWorldModel('models/weapons/csgo/w_knife_ursus.mdl', weapon_knife)
WEAPONS:AddWorldModel('models/weapons/csgo/w_knife_widowmaker.mdl', weapon_knife)
WEAPONS:AddWorldModel('models/weapons/csgo/w_knife_bayonet.mdl', weapon_knife)
WEAPONS:AddWorldModel('models/weapons/csgo/w_knife_css.mdl', weapon_knife)
WEAPONS:AddWorldModel('models/weapons/csgo/w_knife_flip.mdl', weapon_knife)
WEAPONS:AddWorldModel('models/weapons/csgo/w_knife_gut.mdl', weapon_knife)
WEAPONS:AddWorldModel('models/weapons/csgo/w_knife_karam.mdl', weapon_knife)
WEAPONS:AddWorldModel('models/weapons/csgo/w_knife_m9_bay.mdl', weapon_knife)
WEAPONS:AddWorldModel('models/weapons/csgo/w_knife_tactical.mdl', weapon_knife)
WEAPONS:AddWorldModel('models/weapons/csgo/w_pist_deagle.mdl', weapon_deagle)
WEAPONS:AddWorldModel('models/weapons/csgo/w_pist_fiveseven.mdl', weapon_fiveseven)
WEAPONS:AddWorldModel('models/weapons/csgo/w_pist_tec9.mdl', weapon_tec9)
WEAPONS:AddWorldModel('models/weapons/csgo/w_pist_cz_75.mdl', weapon_cz75)
WEAPONS:AddWorldModel('models/weapons/csgo/w_pist_glock18.mdl', weapon_glock)
WEAPONS:AddWorldModel('models/weapons/csgo/w_pist_p250.mdl', weapon_p228)
WEAPONS:AddWorldModel('models/weapons/csgo/w_pist_hkp2000.mdl', weapon_usp)
WEAPONS:AddWorldModel('models/weapons/csgo/w_pist_223.mdl', weapon_usp_silenced)
WEAPONS:AddWorldModel('models/weapons/csgo/w_pist_elite_single.mdl', weapon_elite_single)
WEAPONS:AddWorldModel('models/weapons/csgo/w_pist_elite.mdl', weapon_elite)
WEAPONS:AddWorldModel('models/weapons/csgo/w_pist_revolver.mdl', weapon_magnum)
WEAPONS:AddWorldModel('models/weapons/csgo/w_smg_mac10.mdl', weapon_mac10)
WEAPONS:AddWorldModel('models/weapons/csgo/w_smg_mp9.mdl', weapon_tmp)
WEAPONS:AddWorldModel('models/weapons/csgo/w_smg_mp5sd.mdl', weapon_mp5)
WEAPONS:AddWorldModel('models/weapons/csgo/w_smg_mp5.mdl', weapon_mp5)
WEAPONS:AddWorldModel('models/weapons/csgo/w_smg_mp7.mdl', weapon_smg1)
WEAPONS:AddWorldModel('models/weapons/csgo/w_smg_ump45.mdl', weapon_ump45)
WEAPONS:AddWorldModel('models/weapons/csgo/w_smg_p90.mdl', weapon_p90)
WEAPONS:AddWorldModel('models/weapons/csgo/w_smg_bizon.mdl', weapon_ppbizon)
WEAPONS:AddWorldModel('models/weapons/csgo/w_rif_ak47.mdl', weapon_ak47)
WEAPONS:AddWorldModel('models/weapons/csgo/w_rif_galilar.mdl', weapon_galil)
WEAPONS:AddWorldModel('models/weapons/csgo/w_rif_sg556.mdl', weapon_sg552)
WEAPONS:AddWorldModel('models/weapons/csgo/w_rif_m4a1.mdl', weapon_m4a1)
WEAPONS:AddWorldModel('models/weapons/csgo/w_rif_m4a1_s.mdl', weapon_m4a1)
WEAPONS:AddWorldModel('models/weapons/csgo/w_rif_m4a4.mdl', weapon_m4a1)
WEAPONS:AddWorldModel('models/weapons/csgo/w_rif_famas.mdl', weapon_famas)
WEAPONS:AddWorldModel('models/weapons/csgo/w_rif_aug.mdl', weapon_aug)
WEAPONS:AddWorldModel('models/weapons/csgo/w_rif_scar17.mdl', weapon_scar)
WEAPONS:AddWorldModel('models/weapons/csgo/w_shot_nova.mdl', weapon_nova)
WEAPONS:AddWorldModel('models/weapons/csgo/w_shot_xm1014.mdl', weapon_xm1014)
WEAPONS:AddWorldModel('models/weapons/csgo/w_shot_sawedoff.mdl', weapon_sawedoff)
WEAPONS:AddWorldModel('models/weapons/csgo/w_shot_mag7.mdl', weapon_mag7)
WEAPONS:AddWorldModel('models/weapons/csgo/w_snip_ssg08.mdl', weapon_scout)
WEAPONS:AddWorldModel('models/weapons/csgo/w_snip_awp.mdl', weapon_awp)
WEAPONS:AddWorldModel('models/weapons/csgo/w_snip_g3sg1.mdl', weapon_g3sg1)
WEAPONS:AddWorldModel('models/weapons/csgo/w_snip_scar20.mdl', weapon_scar20)
WEAPONS:AddWorldModel('models/weapons/csgo/w_mach_m249.mdl', weapon_m249)
WEAPONS:AddWorldModel('models/weapons/csgo/w_mach_negev.mdl', weapon_negev)
WEAPONS:AddWorldModel('models/weapons/csgo/w_eq_flashbang.mdl', weapon_frag)
WEAPONS:AddWorldModel('models/weapons/csgo/w_eq_decoy.mdl', weapon_frag)
WEAPONS:AddWorldModel('models/weapons/csgo/w_eq_smokegrenade.mdl', weapon_frag)
WEAPONS:AddWorldModel('models/weapons/csgo/w_eq_incendiarygrenade.mdl', weapon_frag)
WEAPONS:AddWorldModel('models/weapons/csgo/w_eq_fraggrenade.mdl', weapon_he)
WEAPONS:AddWorldModel('models/weapons/csgo/w_eq_molotov.mdl', weapon_molotov)
WEAPONS:AddWorldModel('models/weapons/csgo/w_eq_taser.mdl', weapon_zeus26)
WEAPONS:AddWorldModel('models/weapons/csgo/w_ied.mdl', weapon_c4)

-- Counter-Strike: Global Offensive (ARC9)
WEAPONS:AddWorldModel('models/weapons/csgo/w_rif_scar.mdl', weapon_scar)
WEAPONS:AddWorldModel('models/weapons/csgo/w_eq_smoke_grenade.mdl', weapon_frag)
WEAPONS:AddWorldModel('models/weapons/csgo/w_eq_incendiary.mdl', weapon_frag)
WEAPONS:AddWorldModel('models/weapons/csgo/w_eq_c4.mdl', weapon_c4)
WEAPONS:AddClass('arc9_go_famas', weapon_famas)
WEAPONS:AddClass('arc9_go_galilar', weapon_galil)
WEAPONS:AddClass('arc9_go_elite_single', weapon_elite_single)
WEAPONS:AddClass('arc9_go_cz75', weapon_cz75)
WEAPONS:AddClass('arc9_go_glock', weapon_glock)
WEAPONS:AddClass('arc9_go_r8', weapon_magnum)
WEAPONS:AddClass('arc9_go_tec9', weapon_tec9)
WEAPONS:AddClass('arc9_go_usp', weapon_usp_silenced)
WEAPONS:AddClass('arc9_go_mp7', weapon_smg1)
WEAPONS:AddClass('arc9_go_bizon', weapon_ppbizon)
WEAPONS:AddClass('arc9_go_mag7', weapon_mag7)
WEAPONS:AddClass('arc9_go_nova', weapon_nova)
WEAPONS:AddClass('arc9_go_sawedoff', weapon_sawedoff)
WEAPONS:AddClass('arc9_go_xm1014', weapon_xm1014)
WEAPONS:AddClass('arc9_go_scar20', weapon_scar20)
WEAPONS:AddClass('arc9_go_negev', weapon_negev)
WEAPONS:AddClass('arc9_go_zeus', weapon_zeus26)

GTA3HUD.VC.WEAPONS = WEAPONS -- export weapon icons database
