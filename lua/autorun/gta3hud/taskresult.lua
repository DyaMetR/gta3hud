
if SERVER then return end

GTA3HUD.taskresult = {} -- namespace

GTA3HUD.taskresult.RESULT_SUCCESS = 1
GTA3HUD.taskresult.RESULT_FAILURE = 2

local FADE_IN_TIME = 0.5
local DEFAULT_DISPLAY_TIME = 6

local length, time = 0, -1
local music = false
local category = GTA3HUD.taskresult.RESULT_SUCCESS
local lines = {}
local sound

--[[------------------------------------------------------------------
  Returns whether the animation is running.
  @return {boolean} is running
]]--------------------------------------------------------------------
function GTA3HUD.taskresult.IsRunning()
  return CurTime() < time
end

--[[------------------------------------------------------------------
  Returns how much the label should be visible.
  @return {number} opacity
]]--------------------------------------------------------------------
function GTA3HUD.taskresult.GetOpacity()
  local curtime = time - CurTime()
  if curtime < length - FADE_IN_TIME then return math.min(curtime / FADE_IN_TIME, 1) end
  return 1 - math.max((curtime - (length - FADE_IN_TIME)) / FADE_IN_TIME, 0)
end

--[[------------------------------------------------------------------
  Returns the submitted lines.
  @return {table} lines
]]--------------------------------------------------------------------
function GTA3HUD.taskresult.GetLines()
  return lines
end

--[[------------------------------------------------------------------
  Returns the type of task result.
  @return {RESULT_} type
]]--------------------------------------------------------------------
function GTA3HUD.taskresult.GetType()
  return category
end

--[[------------------------------------------------------------------
  Returns whether we should play the music.
  @return {boolean} music has to play
]]--------------------------------------------------------------------
function GTA3HUD.taskresult.ShouldMusicSound()
  return music and category == GTA3HUD.taskresult.RESULT_SUCCESS
end

--[[------------------------------------------------------------------
  Plays the given sound file and disarms the music flag.
]]--------------------------------------------------------------------
function GTA3HUD.taskresult.PlayMusic(soundpath)
  if sound and sound:IsPlaying() then sound:Stop() end
  sound = CreateSound(LocalPlayer(), soundpath)
  sound:Play()
  music = false
end

--[[------------------------------------------------------------------
  Submits a text to be displayed and arms the music flag.
  @param {string|table} line (or lines)
  @param {number|nil} time on the screen
  @param {RESULT_|nil} result type
]]--------------------------------------------------------------------
function GTA3HUD.taskresult.Submit(text, duration, result)
  if isstring(text) then text = { text } end
  if category == GTA3HUD.taskresult.RESULT_SUCCESS then music = true end
  length = duration or DEFAULT_DISPLAY_TIME
  time = CurTime() + length
  category = result or GTA3HUD.taskresult.RESULT_SUCCESS
  lines = text
end
