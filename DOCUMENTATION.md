# API documentation

## Hooks

### GetMoney

`GTA3HUD_GetMoney()` `CLIENT`

Called when the money is drawn. Returns the amount of money to display.

```lua
-- example: make the display show $300 always
hook.Add('GTA3HUD_GetMoney', 'some_unique_name', function()
  return 300
end)
```

### GetEntityRadarColor

`GTA3HUD_GetEntityRadarColor(Entity entity)` `CLIENT`

Called when an entity is about to be drawn on the radar. Returns the colour used to represent it. This excludes the local player.

```lua
-- example: paint ragdolls brown
local RAGDOLL_COLOUR = Color(128, 64, 0)
hook.Add('GTA3HUD_GetEntityRadarColor', 'some_unique_name', function(ent)
  if ent:GetClass() == 'prop_ragdoll' then
    return RAGDOLL_COLOUR
  end
end)
```

### IsTeamMember

`GTA3HUD_IsTeamMember(Player ply)` `CLIENT`

If team members are allowed to be drawn on the radar, this is called when deciding whether an entity is a team member or not. This excludes the local player.

```lua
-- example: consider people with armour of the same team
hook.Add('GTA3HUD_IsTeamMember', 'some_unique_name', function(ply)
  return LocalPlayer():Armor() > 0 == ply:Armor() > 0
end)
```

### DrawPlayerOnRadar

`GTA3HUD_DrawPlayerOnRadar(Player ply, boolean onRange)` `CLIENT`

Called when a player is about to be drawn on the radar. Returns whether the player should be drawn.

```lua
-- example: make admins always visible
hook.Add('GTA3HUD_DrawPlayerOnRadar', 'some_unique_name', function(ply, onRange)
  if ply:IsAdmin() then
    return true
  end
end)
```

### GetStats

`GTA3HUD_GetStats(table stats)` `CLIENT`

Called before the statistics are drawn below the HUD. Add entries to the `stats` table to add new statistics. Alternatively, you can use the function `GTA3HUD.stats.Add` instead.

```lua
-- example: show current velocity in hammer units
local stat = GTA3HUD.stats.CreateTextStat()
hook.Add('GTA3HUD_GetStats', 'some_unique_name', function(stats)
  stat.value = math.floor(LocalPlayer():GetVelocity():Length())
  table.insert(stats, stat)
end)
```

```lua
-- example: same as above, but using GTA3HUD.stats.Add
local stat = GTA3HUD.stats.CreateTextStat() -- reuse same object for optimization
hook.Add('GTA3HUD_GetStats', 'some_unique_name', function(stats)
  stat.value = math.floor(LocalPlayer():GetVelocity():Length())
  GTA3HUD.stats.Add(stat)
end)
```

### PlayerWasted

`GTA3HUD_PlayerWasted()` `CLIENT`

Called when the wasted animation is bound to start.

```lua
-- example: print a message on chat after dying
hook.Add('GTA3HUD_PlayerWasted', 'some_unique_name', function()
  LocalPlayer():ChatPrint('You got wasted!')
end)
```

### GetWantedLevel

`GTA3HUD_GetWantedLevel()` `CLIENT`

Returns the stars shown on the wanted level display.

```lua
-- example: show as many stars as kills you have
hook.Add('GTA3HUD_GetWantedLevel', 'some_unique_name', function()
  return math.min(LocalPlayer():Frags(), 6)
end)
```

### OnWantedLevelSet

`GTA3HUD_OnWantedLevelSet(Player ply, number amount)` `SERVER`

Called when the wanted level of a player is about to be set. This is **not** the stars on screen, but the progression value, which goes from 0 to 100. Return either a `boolean` to decide whether `amount` is applied or not, or a `number` to change the value set.

```lua
-- example: get immunity as an admin
hook.Add('GTA3HUD_OnWantedLevelSet', 'some_unique_name', function(ply, amount)
  if ply:IsAdmin() then
    return false
  end
end)
```

### OnWantedLevelAdded

`GTA3HUD_OnWantedLevelAdded(Player ply, number amount)` `SERVER`

Called when the wanted level of a player is about to get an addition. Works similarly to `GTA3HUD_OnWantedLevelSet` but instead of `amount` being the absolute value, it's relative.

```lua
-- example: double wanted level added if we already killed someone
hook.Add('GTA3HUD_OnWantedLevelAdded', 'some_unique_name', function(ply, amount)
  return amount * (1 + math.max(ply:Frags()))
end)
```

### GetAttackWantedLevel

`GTA3HUD_GetAttackWantedLevel(Entity victim)` `SERVER`

Called when we want to know how much wanted level progress is added when attacking or killing this entity.

```lua
-- example: if we kill breen, we get maximum wanted level
hook.Add('GTA3HUD_GetAttackWantedLevel', 'some_unique_name', function(victim)
  if victim ~= 'npc_breen' then return end
  return GTA3HUD.wanted.MAX_LEVEL
end)
```

## Adding weapon icons

Every registered HUD has a `WEAPONS` property on their export table which can be used to add weapon icons.

### Register

`WEAPONS:Register(string name, Material texture)`

Registers a texture as a potencial weapon icon. It returns the name provided.

```lua
-- example: register GTA III's crowbar icon
GTA3HUD.GTA3.WEAPONS:Register('crowbar', Material('gta3hud/gta3/weapon_crowbar.png'))
```

### AddClass

`WEAPONS:AddClass(string name, string icon)`

Assigns a registered icon to a weapon class.

```lua
-- example: assign the crowbar icon exclusively to the crowbar weapon
GTA3HUD.GTA3.WEAPONS:AddClass('weapon_crowbar', 'crowbar')
```

### AddWorldModel

`WEAPONS:AddWorldModel(string worldmodel, string icon)`

Assigns a registered icon to a weapon world model.

```lua
-- example: assign the crowbar icon to any weapon using the crowbar model
GTA3HUD.GTA3.WEAPONS:AddWorldModel('models/weapons/w_crowbar.mdl', 'crowbar')
```

### Vice City exceptions

The _Vice City_ HUD variant counts with a coloured background for the weapon indicator, which implies new functions and modifying already existing ones.

| Enumeration      | Value | Description                                                      |
|------------------|-------|------------------------------------------------------------------|
| WEAPON_NONE      | 0     | Transparent. Used with fists and the physics gun or gravity gun. |
| WEAPON_MELEE     | 1     | Light blue. Used with the crowbar, knives and swords.            |
| WEAPON_HANDGUN   | 2     | Light green. Used with pistols and revolvers.                    |
| WEAPON_SMG       | 3     | Yellow. Used with sub-machine guns.                              |
| WEAPON_SHOTGUN   | 4     | Dark green. Used with shotguns.                                  |
| WEAPON_ASSAULT   | 5     | Orange. Used with rifles.                                        |
| WEAPON_SNIPER    | 6     | Pink. Used with the crossbow and sniper rifles.                  |
| WEAPON_HEAVY     | 7     | Purple. Used with the RPG and heavy machine guns.                |
| WEAPON_THROWABLE | 8     | Dark blue. Used with grenades and other explosives.              |
| WEAPON_TOOL      | 9     | Grey. Used with the toolgun.                                     |

#### SetType

`GTA3HUD.VC.WEAPONS:SetType(string name, WEAPON_ category)`

Assigns a type to a registered weapon icon.

```lua
-- example: assign the WEAPON_MELEE type to the fists icon
GTA3HUD.VC.WEAPONS:SetType('fists', GTA3HUD.VC.WEAPON_MELEE)
```

#### SetClassType

`GTA3HUD.VC.WEAPONS:SetClassType(string class, WEAPON_ category)`

Assigns a type to a weapon class.

```lua
-- example: assign the WEAPON_SNIPER type to the magnum
GTA3HUD.VC.WEAPONS:SetClassType('weapon_357', GTA3HUD.VC.WEAPON_SNIPER)
```

#### Register

`GTA3HUD.VC.WEAPONS:Register(string name, Material texture, WEAPON_ category)`

Same as `WEAPONS:Register` but with the additional argument `category` which assigns a weapon type to this icon.

```lua
-- example: register the RPG icon as a heavy weapon
GTA3HUD.VC.WEAPONS:Register('rpg', Material('gta3hud/vc/weapon_rpg.png'), GTA3HUD.VC.WEAPON_HEAVY)
```

## Override library

The `override` library allows for developers to force a certain configuration onto players.

### Submit

`GTA3HUD.override.Submit(string id, table settings)` `CLIENT`

Submits a set of settings to be applied to override the players'. Only the present properties will be overridden, while the rest will still use the player's configuration.

If you use a different variant than the player's, then missing properties will use default values.

The structure of the `settings` table contains two members:
+   `name`: The name of the variant.
+   `properties`: HUD settings table.

**WARNING**: Do not submit overrides in loops or paint functions as reloading the scheme is a costly procedure. It's going to lag. A lot.

```lua
-- example: use San Andreas variant with a green health bar
GTA3HUD.override.Submit('some_unique_name', {
  name = GTA3HUD.SA.ID,
  properties = {
    health = {
      colour = Color(0, 200, 0)
    }
  }
})
```

### Remove

`GTA3HUD.override.Remove(string id)` `CLIENT`

Removes a previously submitted override.

```lua
-- example: remove our previously submitted override
GTA3HUD.override.Remove('some_unique_name')
```

### Get

`GTA3HUD.override.Get(string id)` `CLIENT`

Returns the configuration submitted through an override.

## Radar library

The `radar` library allows developers to add blips to players' radars.

### AddBlip

`GTA3HUD.radar.AddBlip(string id, Entity|Vector origin, boolean always, Material icon)` `CLIENT`

Adds a radar blip, which can be static or tied to an entity.

+   `id`: The name of the blip
+   `origin`: The origin of the blip, either a `Vector` for a _static position_, or an `Entity` to be tracked.
+   `always` **(optional)**: Should it be always be tracked on the radar. If `false`, it will only appear when in range.
+   `icon` **(optional)**: A `Material` to show as an icon instead of a generic blip.

```lua
-- example: mark the center of the map
GTA3HUD.radar.AddBlip('center', Vector(0, 0, 0), true)
```

### RemoveBlip

`GTA3HUD.radar.RemoveBlip(string id)` `CLIENT`

Removes a previously added radar blip.

```lua
-- example: remove radar blip from the previous example
GTA3HUD.radar.RemoveBlip('center')
```

### GetBlip

`GTA3HUD.radar.GetBlip(string id)` `CLIENT`

Returns the properties of a registered blip.

The structure of the returned table is the same as the arguments from `GTA3HUD.radar.AddBlip`.

### GetBlips

`GTA3HUD.radar.GetBlips()` `CLIENT`

Returns all registered blips.

## Statistics library

The `stats` library allows developers to add statistics below the HUD.

### CreateStat

`GTA3HUD.stats.CreateStat(string label, number|string default, STAT_ class, Color|boolean colour)` `CLIENT`

Returns a blank statistic descriptor object. It is recommended to use either `GTA3HUD.stats.CreateTextStat` or `GTA3HUD.stats.CreateProgressBar` directly.

Once created, you can change the `value` property of this descriptor to change the value displayed, and then submit it to the statistics table through `GTA3HUD.stats.Add`.

+   `label`: Text used to describe this statistic.
+   `default`: Default value. Only text based stats allow strings.
+   `class`: Statistic class. Defines how it will be drawn.

| Enumeration       | Value | Description                        |
|-------------------|-------|------------------------------------|
| STAT_TEXT         | 1     | Draws the value as text.           |
| STAT_PROGRESS     | 2     | Draws the value as a progress bar. |

+   `colour`: Colour of the statistic. Return `true` to use the HUD variant's assigned alternate colour.

The returned table contains the same structure as the arguments except for `default` being changed to `value`, so you can also dynamically change the `name`, `colour` and even `class` of the descriptor.

```lua
-- example: create a text stat which uses the default colour
GTA3HUD.stats.CreateStat('counter', 0, GTA3HUD.stats.STAT_TEXT)
```

```lua
-- example: create a progress bar which uses the alternate colour
GTA3HUD.stats.CreateStat('reputation', 0.5, GTA3HUD.stats.STAT_PROGRESS, true)
```

### CreateTextStat

`GTA3HUD.stats.CreateTextStat(string label, number|string default, Color|boolean colour)` `CLIENT`

Alias for calling `GTA3HUD.stats.CreateStat` providing the `class` argument with `GTA3HUD.stats.STAT_TEXT`.

### CreateProgressBar

`GTA3HUD.stats.CreateProgressBar(string label, number default, Color|boolean colour)` `CLIENT`

Alias for calling `GTA3HUD.stats.CreateStat` providing the `class` argument with `GTA3HUD.stats.STAT_PROGRESS`.

### Add

`GTA3HUD.stats.Add(table stat)` `CLIENT`

Adds the given statistic descriptor to the rendering queue to be drawn on the next frame. It is **highly recommended** to be called inside a `GTA3HUD_GetStats` hook.

### All

`GTA3HUD.stats.All()` `CLIENT`

Returns all statistic descriptors queued to be drawn on the next frame.

## Task message library

The `taskmessage` library allows developers to show a message on the bottom of the screen, like a _mission objective instruction_.

### Submit

`GTA3HUD.taskmessage.Submit(string|table text, number length)` `CLIENT`

Submits a message to be displayed.

+   `text`: Can either be a `string` for plain text or a `table` in case you want to change the colour of certain words.
+   `length` **(optional)**: How long does the message play for.

```lua
-- example: display a welcome message for 8 seconds
hook.Add('Initialize', 'some_unique_name', function()
  GTA3HUD.taskmessage.Submit({'Welcome to ', Color(0, 220, 255), GetHostName(), color_white, '. Enjoy your stay!'}, 8)
end)
```

## Task result library

The `taskresult` library allows developers to show a message on the center of the screen with the _mission passed_ jingle.

### Submit

`GTA3HUD.taskresult.Submit(string|table text, number duration, RESULT_ result)` `CLIENT`

Submits a text to be displayed, playing the jingle if `result` is `GTA3HUD.taskresult.RESULT_SUCCESS`.

+   `text`: Either a `string` for a single line or a `table` containing the text of each line.
+   `duration` **(optional)**: How long it stays on the screen for.
+   `result` **(optional)**: The type of task result.

| Enumeration       | Value | Description                                                            |
|-------------------|-------|------------------------------------------------------------------------|
| RESULT_SUCCESS    | 1     | Plays the "Mission passed!" jingle.                                    |
| RESULT_FAILURE    | 2     | Does not play the jingle and in some cases shows an alternate version. |

## Wanted library

The `wanted` library allows developers to utilize the _symbolic wanted system_ shipped with the addon.

### Set

`GTA3HUD.wanted.Set(Player ply, number amount)` `SERVER`

Sets the amount of wanted level progression of a player. This value goes from 0 to 100.

### Add

`GTA3HUD.wanted.Set(Player ply, number amount)` `SERVER`

Adds amount of wanted level progression to a player. This value goes from 0 to 100.

### DelayExpiration

`GTA3HUD.wanted.DelayExpiration(Player ply)` `SERVER`

Resets a player's wanted status expiration timer.
