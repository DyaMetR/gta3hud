
if SERVER then return end

-- [[ GTA III PS2 ]] --
GTA3HUD.settings.Register('GTA III PS2', {
  name = GTA3HUD.GTA3.ID,
  properties = {
    armour = { x = 204 },
    weapon = { colour = Color(140, 135, 115), alternate = true }
  }
})

-- [[ GTA LCS PS2 ]] --
GTA3HUD.settings.Register('Liberty City Stories PS2', {
  name = GTA3HUD.LCS.ID,
  properties = {
    health = { alternate = true },
    armour = { alternate = true }
  }
})
