
if SERVER then return end

GTA3HUD.SA.SOUND_MISSIONPASSED = 'gta3hud/sa/mission_passed.mp3'

-- [[ Weapon icons ]] --
local WEAPONS = GTA3HUD.weapons.Create()

-- register icon textures
local weapon_fists = WEAPONS:Register('fists', Material('gta3hud/sa/weapon_fists.png'))
local weapon_physcannon = WEAPONS:Register('physcannon', Material('gta3hud/sa/weapon_physcannon.png'))
local weapon_crowbar = WEAPONS:Register('crowbar', Material('gta3hud/sa/weapon_crowbar.png'))
local weapon_stunstick = WEAPONS:Register('stunstick', Material('gta3hud/sa/weapon_stunstick.png'))
local weapon_pistol = WEAPONS:Register('pistol', Material('gta3hud/sa/weapon_pistol.png'))
local weapon_357 = WEAPONS:Register('357', Material('gta3hud/sa/weapon_357.png'))
local weapon_alyxgun = WEAPONS:Register('alyxgun', Material('gta3hud/sa/weapon_alyxgun.png'))
local weapon_smg1 = WEAPONS:Register('smg1', Material('gta3hud/sa/weapon_smg1.png'))
local weapon_ar2 = WEAPONS:Register('ar2', Material('gta3hud/sa/weapon_ar2.png'))
local weapon_shotgun = WEAPONS:Register('shotgun', Material('gta3hud/sa/weapon_shotgun.png'))
local weapon_crossbow = WEAPONS:Register('crossbow', Material('gta3hud/sa/weapon_crossbow.png'))
local weapon_annabelle = WEAPONS:Register('annabelle', Material('gta3hud/sa/weapon_annabelle.png'))
local weapon_frag = WEAPONS:Register('frag', Material('gta3hud/sa/weapon_frag.png'))
local weapon_rpg = WEAPONS:Register('rpg', Material('gta3hud/sa/weapon_rpg.png'))
local weapon_slam = WEAPONS:Register('slam', Material('gta3hud/sa/weapon_slam.png'))
local weapon_bugbait = WEAPONS:Register('bugbait', Material('gta3hud/sa/weapon_bugbait.png'))
local weapon_toolgun = WEAPONS:Register('toolgun', Material('gta3hud/sa/weapon_toolgun.png'))
local weapon_knife = WEAPONS:Register('knife', Material('gta3hud/sa/weapon_knife.png'))
local weapon_glock = WEAPONS:Register('glock', Material('gta3hud/sa/weapon_glock.png'))
local weapon_usp = WEAPONS:Register('usp', Material('gta3hud/sa/weapon_usp.png'))
local weapon_usp_silenced = WEAPONS:Register('usp_silenced', Material('gta3hud/sa/weapon_usp_silenced.png'))
local weapon_p228 = WEAPONS:Register('p228', Material('gta3hud/sa/weapon_p228.png'))
local weapon_elite_single = WEAPONS:Register('elite_single', Material('gta3hud/sa/weapon_beretta.png'))
local weapon_elite = WEAPONS:Register('elites', Material('gta3hud/sa/weapon_dualies.png'))
local weapon_tec9 = WEAPONS:Register('tec9', Material('gta3hud/sa/weapon_tec9.png'))
local weapon_cz75 = WEAPONS:Register('cz75', Material('gta3hud/sa/weapon_cz75.png'))
local weapon_fiveseven = WEAPONS:Register('fiveseven', Material('gta3hud/sa/weapon_fiveseven.png'))
local weapon_deagle = WEAPONS:Register('deagle', Material('gta3hud/sa/weapon_deagle.png'))
local weapon_mac10 = WEAPONS:Register('mac10', Material('gta3hud/sa/weapon_mac10.png'))
local weapon_tmp = WEAPONS:Register('tmp', Material('gta3hud/sa/weapon_tmp.png'))
local weapon_mp5 = WEAPONS:Register('mp5', Material('gta3hud/sa/weapon_mp5.png'))
local weapon_ump45 = WEAPONS:Register('ump45', Material('gta3hud/sa/weapon_ump45.png'))
local weapon_p90 = WEAPONS:Register('p90', Material('gta3hud/sa/weapon_p90.png'))
local weapon_m3super90 = WEAPONS:Register('m3super90', Material('gta3hud/sa/weapon_m3super90.png'))
local weapon_nova = WEAPONS:Register('nova', Material('gta3hud/sa/weapon_nova.png'))
local weapon_xm1014 = WEAPONS:Register('xm1014', Material('gta3hud/sa/weapon_xm1014.png'))
local weapon_mag7 = WEAPONS:Register('mag7', Material('gta3hud/sa/weapon_mag7.png'))
local weapon_sawedoff = WEAPONS:Register('sawedoff', Material('gta3hud/sa/weapon_sawedoff.png'))
local weapon_ppbizon = WEAPONS:Register('ppbizon', Material('gta3hud/sa/weapon_ppbizon.png'))
local weapon_galil = WEAPONS:Register('galil', Material('gta3hud/sa/weapon_galil.png'))
local weapon_famas = WEAPONS:Register('famas', Material('gta3hud/sa/weapon_famas.png'))
local weapon_ak47 = WEAPONS:Register('ak47', Material('gta3hud/sa/weapon_ak47.png'))
local weapon_m4a1 = WEAPONS:Register('m4a1', Material('gta3hud/sa/weapon_m4a1.png'))
local weapon_sg552 = WEAPONS:Register('sg552', Material('gta3hud/sa/weapon_sg552.png'))
local weapon_aug = WEAPONS:Register('aug', Material('gta3hud/sa/weapon_aug.png'))
local weapon_scar = WEAPONS:Register('scar', Material('gta3hud/sa/weapon_scar.png'))
local weapon_scout = WEAPONS:Register('scout', Material('gta3hud/sa/weapon_scout.png'))
local weapon_awp = WEAPONS:Register('awp', Material('gta3hud/sa/weapon_awp.png'))
local weapon_g3sg1 = WEAPONS:Register('g3sg1', Material('gta3hud/sa/weapon_g3sg1.png'))
local weapon_sg550 = WEAPONS:Register('sg550', Material('gta3hud/sa/weapon_sg550.png'))
local weapon_scar20 = WEAPONS:Register('scar20', Material('gta3hud/sa/weapon_scar20.png'))
local weapon_m249 = WEAPONS:Register('m249', Material('gta3hud/sa/weapon_m249.png'))
local weapon_negev = WEAPONS:Register('negev', Material('gta3hud/sa/weapon_negev.png'))
local weapon_grenade = WEAPONS:Register('grenade', Material('gta3hud/sa/weapon_he.png'))
local weapon_molotov = WEAPONS:Register('molotov', Material('gta3hud/sa/weapon_molotov.png'))
local weapon_c4 = WEAPONS:Register('ied', Material('gta3hud/sa/weapon_c4.png'))
local weapon_zeus26 = WEAPONS:Register('zeus26', Material('gta3hud/sa/weapon_zeus26.png'))

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

GTA3HUD.SA.WEAPONS = WEAPONS -- export weapon icons database
