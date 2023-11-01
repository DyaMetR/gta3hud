--[[------------------------------------------------------------------
  Override API.

  Allows addon developers and server owners to submit partial or
  complete overrides of the clients' settings.

  > GTA3HUD.override.Submit(id, settings)
    - Apply a settings override. The settings table has the following structure:
      > name: Name of the HUD variant.
        - if the HUD variant is not the same across all overrides, the different
        ones will be discarded once the first override loads in.
        - this will also decide whether server and client settings work, as if
        any of those two have different HUD variants from the first override
        loaded they will also get discarded.
      > properties: Values of the properties to override.

  > GTA3HUD.override.Remove(id)
    - Reverts an override.

  WARNING: Do not submit overrides in loops or paint functions as
  reloading the scheme is a costly procedure. It's going to lag. A lot.

  Code taken from Half-Life 2 HUD's overrides.
  https://github.com/DyaMetR/hl2hud/blob/main/lua/autorun/hl2hud/override.lua
]]--------------------------------------------------------------------

if SERVER then return end

GTA3HUD.override = {} -- namespace

--[[------------------------------------------------------------------
  Adds the given settings override to the list.
  @param {string} override identifier
  @param {table} settings
]]--------------------------------------------------------------------
function GTA3HUD.override.Submit(id, settings)
  GTA3HUD.settings.overrides[id] = scheme
  GTA3HUD.settings.Reload()
end

--[[------------------------------------------------------------------
  Removes a settings override from the list.
  @param {string} override identifier
]]--------------------------------------------------------------------
function GTA3HUD.override.Remove(id)
  GTA3HUD.settings.overrides[id] = nil
  GTA3HUD.settings.Reload()
end

--[[------------------------------------------------------------------
  Returns an override's data.
  @param {string} override identifier
  @return {table} settings
]]--------------------------------------------------------------------
function GTA3HUD.override.Get(id)
  return GTA3HUD.settings.overrides[id]
end
