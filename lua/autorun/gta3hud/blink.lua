
if SERVER then return end

GTA3HUD.blink = {} -- namespace

local BLINK = {
  active = false,
  blinking = false,
  time = 0
}

--[[------------------------------------------------------------------
	Creates a new blink handler.
  @param {number} default rate
]]--------------------------------------------------------------------
function BLINK:SetRate(rate)
  self.rate = rate
end

--[[------------------------------------------------------------------
	Sets whether the blink animation should run.
  @param {boolean} should be active
]]--------------------------------------------------------------------
function BLINK:SetActive(active)
  if not active and self.active then self.blinking = false end
  self.active = active
end

--[[------------------------------------------------------------------
	Is the animation in the blinking frame.
  @return {boolean} is it blinking
]]--------------------------------------------------------------------
function BLINK:IsBlinking()
  return self.blinking
end

--[[------------------------------------------------------------------
	Runs this blinking animation.
]]--------------------------------------------------------------------
function BLINK:Run()
  if not self.active then return end
  self.time = self.time + FrameTime()
  if self.time <= self.rate then return end
  self.blinking = not self.blinking
  self.time = 0
end

--[[------------------------------------------------------------------
	Creates a new blink handler.
  @param {number} default rate
  @param {boolean} active by default
]]--------------------------------------------------------------------
function GTA3HUD.blink.Create(rate, active)
  local blink = table.Copy(BLINK)
  blink.rate = rate or 0
  blink.active = active or false
  return blink
end
