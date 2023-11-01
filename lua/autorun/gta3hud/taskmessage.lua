
if SERVER then return end

GTA3HUD.taskmessage = {}

local DEFAULT_DISPLAY_TIME = 6

local message = {}
local stringified = ''
local time = 0

--[[------------------------------------------------------------------
  Sends a message to be displayed.
  @param {string|table} message contents
  @param {number} length of the message
]]--------------------------------------------------------------------
function GTA3HUD.taskmessage.Submit(text, length)
  if isstring(text) then text = { text } end
  message = text
  time = CurTime() + (length or DEFAULT_DISPLAY_TIME)
  stringified = ''
  for _, text in pairs(text) do -- get the full string to calculate text size
    if not isstring(text) then continue end
    stringified = stringified .. text
  end
end

--[[------------------------------------------------------------------
  Returns the current message.
  @return {table} message
]]--------------------------------------------------------------------
function GTA3HUD.taskmessage.Get()
  return message
end

--[[------------------------------------------------------------------
  Returns the raw uncoloured text.
  @return {string} string
]]--------------------------------------------------------------------
function GTA3HUD.taskmessage.GetString()
  return stringified
end

--[[------------------------------------------------------------------
  Whether the message should be displayed.
  @return {boolean} should the message be shown
]]--------------------------------------------------------------------
function GTA3HUD.taskmessage.ShouldDraw()
  return time > CurTime()
end
