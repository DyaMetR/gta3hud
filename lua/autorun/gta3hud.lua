--[[------------------------------------------------------------------
  Grand Theft Auto 3D Universe HUD
  November 1st, 2023
  Made by DyaMetR
  * full credits found in the details below
]]--------------------------------------------------------------------

GTA3HUD = GTA3HUD or {}

-- hook name
GTA3HUD.hookname			= 'gta3hud'

if CLIENT then
  -- addon information
  GTA3HUD.name				= 'GTA 3D Universe HUD'
  GTA3HUD.version		= '1.0.2'
  GTA3HUD.date				= 'November 1st, 2023'
  GTA3HUD.credits		= { -- {name, contribution}
    {'DyaMetR', '#gta3hud.credits.author'},
    {'Rockstar Games', '#gta3hud.credits.rockstar'},
    {'Ray Larabie', 'Pricedown'},
    {'Aaron W. Beck', 'Beckett'},
    {'Paul Renner', 'Futura LT'},
    {'Morris Fuller Benton', 'Bank Gothic'},
    {'Matsilagi', '#gta3hud.credits.assetsourcing'}
  }
end

--[[------------------------------------------------------------------
  Includes a file sharedwise
  @param {string} file
]]--------------------------------------------------------------------
function GTA3HUD.include(path)
  include(path)
  if SERVER then AddCSLuaFile(path) end
end

-- include core
GTA3HUD.include('gta3hud/init.lua')
