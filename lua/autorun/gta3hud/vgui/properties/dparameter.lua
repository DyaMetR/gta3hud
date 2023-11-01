
if SERVER then return end

local PANEL = {}

function PANEL:Init()
	local reset = vgui.Create('DImageButton', self)
	reset:Dock(RIGHT)
	reset:DockMargin(2, 4, 4, 4)
	reset:SetWide(16)
	reset:SetImage('icon16/arrow_refresh.png')
	reset:SetTooltip('#gta3hud.menu.reset')
	reset.DoClick = function() self:OnValueReset() end
end

--[[------------------------------------------------------------------
	Initializes the panel based on the given parameter.
	@param {table} parameter
]]--------------------------------------------------------------------
function PANEL:SetParameter(parameter) end

--[[------------------------------------------------------------------
	Sets the value on the control.
  @param {any} value
]]--------------------------------------------------------------------
function PANEL:SetValue(value) end

--[[------------------------------------------------------------------
	Called when the value changes.
  @param {any} value
]]--------------------------------------------------------------------
function PANEL:OnValueChanged(value) end

--[[------------------------------------------------------------------
	Called when the reset button is pressed.
]]--------------------------------------------------------------------
function PANEL:OnValueReset() end

vgui.Register('GTA3HUD_Parameter', PANEL, 'GTA3HUD_PanelList_Line')
