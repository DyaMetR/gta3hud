
if SERVER then return end

local PANEL = {}

function PANEL:Populate(properties, settings)
  local parameters = vgui.Create('GTA3HUD_PanelList', self)
  parameters:SetPaintBackground(false)
  parameters:Dock(FILL)
  parameters:DockMargin(4, 0, 0, 0)

    for id, parameter in SortedPairsByMemberValue(properties, 'i') do
      if id == 'colour' then continue end
      local _, control = parameters:AddLine(self:GetParameterDerma(parameter))
      control:SetParameter(parameter)
      control:SetValue(settings[id])
      control:Dock(TOP)
      control.OnValueChanged = function(_, value)
        settings[id] = value
      end
      control.OnValueReset = function()
        local default = parameter.default
        if istable(default) then default = table.Copy(default) end
        settings[id] = default
        control:SetValue(default)
      end
    end

  local colour = vgui.Create('Panel', self)
  colour:SetWide(256)
  colour:Dock(RIGHT)
  colour:DockMargin(4, 0, 0, 0)

    local label = vgui.Create('DLabel', colour)
    label:SetTextColor(self:GetSkin().Colours.Label.Dark)
    label:SetText(properties.colour.name)
    label:Dock(TOP)
    label:DockMargin(5, 2, 0, 0)

    local mixer = vgui.Create('DColorMixer', colour)
    mixer:SetColor(settings.colour)
    mixer:DockMargin(0, 2, 0, 0)
    mixer:Dock(FILL)
    mixer.ValueChanged = function(_, value) settings.colour = value end

    local reset = vgui.Create('DImageButton', colour)
    reset:SetPos(colour:GetWide() - 20, 4)
    reset:SetSize(16, 16)
    reset:SetImage('icon16/arrow_refresh.png')
    reset:SetTooltip('#gta3hud.menu.reset')
    reset.DoClick = function() mixer:SetColor(properties.colour.default) end

  self:SetTall(256)
end

vgui.Register('GTA3HUD_Element', PANEL, 'GTA3HUD_Settings')
