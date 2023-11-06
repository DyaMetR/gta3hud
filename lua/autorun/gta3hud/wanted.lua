
local enabled = CreateConVar('gta3hud_wantedsystem', 1, { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED }, 'Enables the basic wanted system. Keeps track to the violence done against human NPCs or other players.')
local NWVAR_WANTED = 'gta3hud_wanted'

GTA3HUD.wanted = {} -- namespace

if SERVER then

  local pvp = CreateConVar('gta3hud_wantedsystempvponly', 0, { FCVAR_ARCHIVE }, 'Players will only be wanted if they hurt other players.')
  local expire = CreateConVar('gta3hud_wantedsystemexpire', 180, { FCVAR_ARCHIVE }, 'How long does it take for players to lose their wanted status after they stop committing crimes.')

  local HOOK = GTA3HUD.hookname .. '_wantedsystem'
  local TIMER = HOOK .. '_%s'

  local PENALTY_DAMAGE_MULTIPLIER = 0.05

  -- maximum wanted level
  GTA3HUD.wanted.MAX_LEVEL          = 100

  -- penalty types
  GTA3HUD.wanted.PENALTY_MACHINE    = 1
  GTA3HUD.wanted.PENALTY_HUMAN      = 3
  GTA3HUD.wanted.PENALTY_AUTHORITY  = 6
  GTA3HUD.wanted.PENALTY_PLAYER     = 8
  GTA3HUD.wanted.PENALTY_VEHICLE    = 40
  GTA3HUD.wanted.PENALTY_STRIDER    = 60

  -- wanted level added when killing these entities
  local KILL_PENALTY = {
    player = GTA3HUD.wanted.PENALTY_PLAYER,
    npc_alyx = GTA3HUD.wanted.PENALTY_HUMAN,
    npc_barney = GTA3HUD.wanted.PENALTY_HUMAN,
    npc_breen = GTA3HUD.wanted.PENALTY_AUTHORITY,
    npc_citizen = GTA3HUD.wanted.PENALTY_HUMAN,
    npc_combine_camera = GTA3HUD.wanted.PENALTY_MACHINE,
    npc_combine_s = GTA3HUD.wanted.PENALTY_AUTHORITY,
    npc_combinedropship = GTA3HUD.wanted.PENALTY_VEHICLE,
    npc_combinegunship = GTA3HUD.wanted.PENALTY_VEHICLE,
    npc_cscanner = GTA3HUD.wanted.PENALTY_MACHINE,
    npc_dog = GTA3HUD.wanted.PENALTY_HUMAN,
    npc_eli = GTA3HUD.wanted.PENALTY_HUMAN,
    npc_fisherman = GTA3HUD.wanted.PENALTY_HUMAN,
    npc_gman = GTA3HUD.wanted.PENALTY_HUMAN,
    npc_helicopter = GTA3HUD.wanted.PENALTY_VEHICLE,
    npc_hunter = GTA3HUD.wanted.PENALTY_AUTHORITY * 2,
    npc_kleiner = GTA3HUD.wanted.PENALTY_HUMAN,
    npc_monk = GTA3HUD.wanted.PENALTY_HUMAN,
    npc_mossman = GTA3HUD.wanted.PENALTY_HUMAN,
    npc_metropolice = GTA3HUD.wanted.PENALTY_AUTHORITY,
    npc_manhack = GTA3HUD.wanted.PENALTY_MACHINE,
    npc_sniper = GTA3HUD.wanted.PENALTY_AUTHORITY,
    npc_stalker = GTA3HUD.wanted.PENALTY_HUMAN,
    npc_strider = GTA3HUD.wanted.PENALTY_STRIDER,
    npc_turret_ceiling = GTA3HUD.wanted.PENALTY_MACHINE,
    npc_turret_floor = GTA3HUD.wanted.PENALTY_MACHINE,
    npc_turret_ground = GTA3HUD.wanted.PENALTY_MACHINE
  }

  -- damage applied to these entities in order to get their wanted level penalty
  local DAMAGE_EXCEPTION = {
    npc_helicopter = 600,
    npc_strider = 350,
    npc_combinegunship = 100
  }

  --[[------------------------------------------------------------------
    Fetches the penalty to apply for assaulting the given entity.
    @param {Entity} victim
    @return {number} penalty
  ]]--------------------------------------------------------------------
  local function fetchPenalty(victim)
    local penalty = hook.Run('GTA3HUD_GetAttackWantedLevel', victim)
    if penalty == false then return end
    if not isnumber(penalty) then return KILL_PENALTY[victim:GetClass()] end
    return penalty
  end

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
    if not victim:IsPlayer() and not victim:IsNPC() then return end
    if victim:IsNPC() and pvp:GetBool() then return end
    hit[victim] = victim:Health()
  end)

  -- [[ Add up to one star if we hurt NPCs (without killing them) ]] --
  hook.Add('PostEntityTakeDamage', HOOK, function(victim, dmg, took)
    if not hit[victim] then return end
    local attacker = dmg:GetAttacker()
    if not IsValid(victim) or not IsValid(attacker) then hit[victim] = nil return end

    -- fetch penalty
    local penalty = fetchPenalty(victim)
    if not penalty then hit[victim] = nil return end

    -- for exceptions, it will count the damage instead of the kill to apply the penalty
    local damage = math.min(hit[victim] - victim:Health(), math.max(victim:Health(), 0)) -- find the real damage done to this entity
    if DAMAGE_EXCEPTION[victim:GetClass()] and took then
      GTA3HUD.wanted.Add(attacker, penalty * (damage / DAMAGE_EXCEPTION[victim:GetClass()]))
    else -- otherwise, only raise one star when assaulting without killing
      if attacker:GetNW2Int(NWVAR_WANTED) >= 1 then hit[victim] = nil return end
      GTA3HUD.wanted.Add(attacker, math.min(penalty * PENALTY_DAMAGE_MULTIPLIER * damage, math.pow(10 / 6, 2)))
    end

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
    local penalty = fetchPenalty(npc)
    if not penalty or DAMAGE_EXCEPTION[npc:GetClass()] then return end
    GTA3HUD.wanted.Add(attacker, penalty)
  end)

  -- [[ Add wanted level after killing a player ]] --
  hook.Add('PlayerDeath', HOOK, function(victim, _, attacker)
    if not enabled:GetBool() then return end
    if not IsValid(victim) or not IsValid(attacker) or attacker == victim then return end
    local penalty = fetchPenalty(victim)
    if not penalty or victim.gta3hud_wanted > 0 then return end -- allow killing wanted players
    GTA3HUD.wanted.Add(attacker, penalty)
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
    _player.gta3hud_wanted = math.Clamp(amount, 0, GTA3HUD.wanted.MAX_LEVEL)
    _player:SetNW2Int(NWVAR_WANTED, math.floor(6 * math.sqrt(_player.gta3hud_wanted / GTA3HUD.wanted.MAX_LEVEL)))
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
