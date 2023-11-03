
local enabled = CreateConVar('gta3hud_wantedsystem', 1, { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED }, 'Enables the basic wanted system. Keeps track to the violence done against human NPCs or other players.')
local NWVAR_WANTED = 'gta3hud_wanted'

GTA3HUD.wanted = {} -- namespace

if SERVER then

  local pvp = CreateConVar('gta3hud_wantedsystempvponly', 0, { FCVAR_ARCHIVE }, 'Players will only be wanted if they hurt other players.')
  local expire = CreateConVar('gta3hud_wantedsystemexpire', 180, { FCVAR_ARCHIVE }, 'How long does it take for players to lose their wanted status after they stop committing crimes.')

  local HOOK = GTA3HUD.hookname .. '_wantedsystem'
  local TIMER = HOOK .. '_%s'

  local PENALTY_DAMAGE_MULTIPLIER = 0.05
  local PENALTY_MACHINE = 1
  local PENALTY_HUMAN = 3
  local PENALTY_AUTHORITY = 6
  local PENALTY_PLAYER = 8
  local PENALTY_VEHICLE = 40
  local PENALTY_STRIDER = 60
  local MAX_WANTED_LEVEL = 100

  local KILL_PENALTY = { -- wanted level added when killing these
    player = PENALTY_PLAYER,
    npc_alyx = PENALTY_HUMAN,
    npc_barney = PENALTY_HUMAN,
    npc_breen = PENALTY_AUTHORITY,
    npc_citizen = PENALTY_HUMAN,
    npc_combine_camera = PENALTY_MACHINE,
    npc_combine_s = PENALTY_AUTHORITY,
    npc_combinedropship = PENALTY_VEHICLE,
    npc_combinegunship = PENALTY_VEHICLE,
    npc_cscanner = PENALTY_MACHINE,
    npc_dog = PENALTY_HUMAN,
    npc_eli = PENALTY_HUMAN,
    npc_fisherman = PENALTY_HUMAN,
    npc_gman = PENALTY_HUMAN,
    npc_helicopter = PENALTY_VEHICLE,
    npc_hunter = PENALTY_AUTHORITY * 2,
    npc_kleiner = PENALTY_HUMAN,
    npc_monk = PENALTY_HUMAN,
    npc_mossman = PENALTY_HUMAN,
    npc_metropolice = PENALTY_AUTHORITY,
    npc_manhack = PENALTY_MACHINE,
    npc_sniper = PENALTY_AUTHORITY,
    npc_stalker = PENALTY_HUMAN,
    npc_strider = PENALTY_STRIDER,
    npc_turret_ceiling = PENALTY_MACHINE,
    npc_turret_floor = PENALTY_MACHINE,
    npc_turret_ground = PENALTY_MACHINE
  }
  local DAMAGE_EXCEPTION = { -- damage required to apply wanted level
    npc_helicopter = 600,
    npc_strider = 350,
    npc_combinegunship = 100
  }

  -- [[ Reset wanted level upon dying ]] --
  hook.Add('PlayerSpawn', HOOK, function(_player)
    _player:SetNW2Int(NWVAR_WANTED, 0)
    _player.gta3hud_wanted = 0 -- wanted level accumulated
  end)

  -- [[ Detect whether we hit an NPC and store its health ]] --
  local hit = {} -- entities damaged by players
  hook.Add('EntityTakeDamage', HOOK, function(victim, info)
    if not enabled:GetBool() then return end
    local attacker = info:GetAttacker()
    if not IsValid(victim) or not IsValid(attacker) or not attacker:IsPlayer() or attacker == victim then return end
    if victim:IsNPC() and pvp:GetBool() then return end
    if not KILL_PENALTY[victim:GetClass()] then return end
    hit[victim] = victim:Health()
    print(victim, hit[victim])
  end)

  -- [[ Add up to one star if we hurt NPCs (without killing them) ]] --
  hook.Add('PostEntityTakeDamage', HOOK, function(victim, dmg, took)
    if not hit[victim] then return end
    local attacker = dmg:GetAttacker()
    if not IsValid(victim) or not IsValid(attacker) then hit[victim] = nil return end
    local damage = math.min(hit[victim] - victim:Health(), math.max(victim:Health(), 0)) -- find the real damage done to this entity

    -- by default, doing damage without killing will only raise up to one star
    local penalty = math.min(KILL_PENALTY[victim:GetClass()] * PENALTY_DAMAGE_MULTIPLIER * damage, math.pow(10 / 6, 2))

    -- but for exceptions, it will count the damage instead of the kill to apply the penalty
    if DAMAGE_EXCEPTION[victim:GetClass()] and took then
      penalty = KILL_PENALTY[victim:GetClass()] * (damage / DAMAGE_EXCEPTION[victim:GetClass()])
    else
      if attacker:GetNW2Int(NWVAR_WANTED) >= 1 then return end
    end

    GTA3HUD.wanted.Add(attacker, penalty)
    hit[victim] = nil
  end)

  -- [[ Flush hit cache of removed NPCs ]] --
  hook.Add('EntityRemoved', HOOK, function(ent)
    if not hit[ent] then return end
    hit[ent] = nil
  end)

  -- [[ Add wanted level after killing an NPC ]] --
  hook.Add('OnNPCKilled', HOOK, function(npc, attacker)
    if not enabled:GetBool() or pvp:GetBool() then return end
    if not IsValid(attacker) or not attacker:IsPlayer() then return end
    if not KILL_PENALTY[npc:GetClass()] or DAMAGE_EXCEPTION[npc:GetClass()] then return end
    GTA3HUD.wanted.Add(attacker, KILL_PENALTY[npc:GetClass()])
  end)

  -- [[ Add wanted level after killing a player ]] --
  hook.Add('PlayerDeath', HOOK, function(victim, _, attacker)
    if not enabled:GetBool() then return end
    if not IsValid(victim) or not IsValid(attacker) or attacker == victim then return end
    if victim.gta3hud_wanted > 0 then return end -- allow killing wanted players
    GTA3HUD.wanted.Add(attacker, KILL_PENALTY.player)
  end)

  --[[------------------------------------------------------------------
    Sets the wanted level progress of a player.
    @param {Player} player
    @param {number} amount
  ]]--------------------------------------------------------------------
  function GTA3HUD.wanted.Set(_player, amount)
    if not enabled:GetBool() then return end
    local override = hook.Run('GTA3HUD_OnWantedLevelSet', _player, amount)
    if override ~= nil then
      if isnumber(override) then
        amount = override
      else
        if not override then return end
      end
    end
    _player.gta3hud_wanted = math.Clamp(amount, 0, MAX_WANTED_LEVEL)
    _player:SetNW2Int(NWVAR_WANTED, math.floor(6 * math.sqrt(_player.gta3hud_wanted / MAX_WANTED_LEVEL)))
    if _player.gta3hud_wanted <= 0 then timer.Remove(string.format(TIMER, _player:EntIndex())) return end
    GTA3HUD.wanted.DelayExpiration(_player)
  end

  --[[------------------------------------------------------------------
  	Adds wanted level progress to a player.
    @param {Player} player
    @param {number} amount
  ]]--------------------------------------------------------------------
  function GTA3HUD.wanted.Add(_player, amount)
    local override = hook.Run('GTA3HUD_OnWantedLevelAdded', _player, amount)
    if override ~= nil then
      if isnumber(override) then
        amount = override
      else
        if not override then return end
      end
    end
    GTA3HUD.wanted.Set(_player, (_player.gta3hud_wanted or 0) + amount)
  end

  --[[------------------------------------------------------------------
  	Resets the expiration delay.
    @param {Player} _player
  ]]--------------------------------------------------------------------
  function GTA3HUD.wanted.DelayExpiration(_player)
    local time = expire:GetInt()
    local override = hook.Run('GTA3HUD_GetWantedExpiryTime')
    if override ~= nil then
      if isnumber(override) then
        time = override
      else
        if not override then return end
      end
    end
    if time <= 0 then return end
    timer.Create(string.format(TIMER, _player:EntIndex()), expire:GetInt(), 1, function()
      if not IsValid(_player) then return end
      GTA3HUD.wanted.Set(_player, 0)
    end)
  end

  --[[------------------------------------------------------------------
    Instantly expires the player's wanted level.
  ]]--------------------------------------------------------------------
  if game.SinglePlayer() then
    concommand.Add('gta3hud_wantedsystem_clear', function(_player)
      GTA3HUD.wanted.Set(_player, 0)
    end)
  end

  return
end

--[[------------------------------------------------------------------
  Returns the current wanted level.
  @return {number} wanted level
]]--------------------------------------------------------------------
function GTA3HUD.wanted.GetWantedLevel()
  local wanted = 0
  if enabled:GetBool() then wanted = LocalPlayer():GetNW2Int(NWVAR_WANTED) end
  return hook.Run('GTA3HUD_GetWantedLevel') or wanted
end
