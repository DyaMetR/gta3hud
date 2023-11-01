
if SERVER then return end

GTA3HUD.stats = {} -- namespace

GTA3HUD.stats.STAT_TEXT     = 1
GTA3HUD.stats.STAT_PROGRESS = 2

local stats = {}

--[[------------------------------------------------------------------
  Returns all stats registered on this frame.
  @return {table} stats
]]--------------------------------------------------------------------
function GTA3HUD.stats.All()
  return stats
end

--[[------------------------------------------------------------------
  Empties the stats list for the next frame.
]]--------------------------------------------------------------------
function GTA3HUD.stats.Flush()
  table.Empty(stats)
end

--[[------------------------------------------------------------------
  Adds the given stat table to the next render queue.
  @param {table} stat table
]]--------------------------------------------------------------------
function GTA3HUD.stats.Add(stat)
  table.insert(stats, stat)
end

--[[------------------------------------------------------------------
  Runs the stats collecting hook.
]]--------------------------------------------------------------------
function GTA3HUD.stats.RunHook()
  hook.Run('GTA3HUD_GetStats', stats)
end

--[[------------------------------------------------------------------
  Creates a blank stat table.
  @param {string} label
  @param {number} default value
  @param {STAT_} stat type
  @param {Color|boolean|nil} custom colour or use alternate colour if available
  @return {table} generated stat table to feed the hook
]]--------------------------------------------------------------------
function GTA3HUD.stats.CreateStat(label, default, class, colour)
  return { type = class, label = label, value = default, colour = colour }
end

--[[------------------------------------------------------------------
  Creates a progress bar stat table.
  @param {string} label
  @param {number} default value
  @param {Color|boolean|nil} custom colour or use alternate colour if available
]]--------------------------------------------------------------------
function GTA3HUD.stats.CreateProgressBar(label, default, colour)
  return GTA3HUD.stats.CreateStat(label, default, GTA3HUD.stats.STAT_PROGRESS, colour)
end

--[[------------------------------------------------------------------
  Creates a text based stat table.
  @param {string} label
  @param {text} default value
  @param {Color|boolean|nil} custom colour or use alternate colour if available
]]--------------------------------------------------------------------
function GTA3HUD.stats.CreateTextStat(label, default, colour)
  return GTA3HUD.stats.CreateStat(label, default, GTA3HUD.stats.STAT_TEXT, colour)
end
