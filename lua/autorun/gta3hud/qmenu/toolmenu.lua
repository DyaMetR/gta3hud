
if SERVER then return end

GTA3HUD.toolmenu = {} -- namespace

local CATEGORY = 'Utilities'
local UID = 'gta3hud'

--[[------------------------------------------------------------------
  Helper function to add a panel with a label and a button.
  @param {Panel} parent
  @param {string} label text
  @param {string} button tooltip
  @param {function} button function
  @return {Panel} panel
  @return {DLabel} label
]]--------------------------------------------------------------------
local function AddOverrideLabel(parent, text, tooltip, click)
  local panel = vgui.Create('Panel', parent)
  panel:Dock(TOP)
  panel:SetTall(16)

    local label = vgui.Create('DLabel', panel)
    label:SetText(text)
    label:SetTextColor(label:GetSkin().Colours.Label.Dark)
    label:SizeToContents()

    local button = vgui.Create('DImageButton', panel)
    button:SetWide(16)
    button:SetImage('icon16/delete.png')
    button:Dock(RIGHT)
    button:SetTooltip(tooltip)
    button.DoClick = click

  return panel, label
end

--[[------------------------------------------------------------------
  Helper function to add the wanted system options to a panel.
  @param {Panel} panel to add to
]]--------------------------------------------------------------------
local function AddWantedSystemOptions(panel)
  panel:Help('\n' .. language.GetPhrase('gta3hud.qmenu.server.wantedsystem'))
  panel:ControlHelp('#gta3hud.qmenu.server.wantedsystem.help')
  panel:CheckBox('#gta3hud.qmenu.server.wantedsystem.enabled', 'gta3hud_wantedsystem')
  if not game.SinglePlayer() then panel:CheckBox('#gta3hud.qmenu.server.wantedsystem.pvp', 'gta3hud_wantedsystempvponly') end
  panel:NumSlider('#gta3hud.qmenu.server.wantedsystem.expiry', 'gta3hud_wantedsystemexpire', 0, 900)
  panel:ControlHelp(string.format(language.GetPhrase('gta3hud.qmenu.server.default_value'), GetConVar('gta3hud_wantedsystemexpire'):GetDefault()))
  if game.SinglePlayer() then panel:Button('#gta3hud.qmenu.server.wantedsystem.clear', 'gta3hud_wantedsystem_clear') end
end

-- populate tool menu
hook.Add('PopulateToolMenu', UID, function()

  -- user settings
  spawnmenu.AddToolMenuOption(CATEGORY, GTA3HUD.name, UID, '#spawnmenu.utilities.settings', nil, nil, function(panel)
    panel:ClearControls()

    -- parameters
    panel:CheckBox('#gta3hud.qmenu.client.enabled', 'gta3hud_enabled')
    panel:CheckBox('#gta3hud.qmenu.client.filtering', 'gta3hud_filter')
    panel:NumSlider('#gta3hud.qmenu.client.scale', 'gta3hud_scale', 0, 6)
    panel:CheckBox('#gta3hud.qmenu.client.minimap', 'gta3hud_minimap')
    panel:ControlHelp('#gta3hud.qmenu.client.minimap.help')

    -- variant quick select
    panel:Help('#gta3hud.qmenu.client.quick_swap')
    local select = vgui.Create('DComboBox')
    select:SetSortItems(false)
    select:SetValue(GTA3HUD.settings.Get().name)
    select.OnSelect = function(self, _, option)
      Derma_Query('#gta3hud.qmenu.client.quick_swap.warning.description', '#gta3hud.qmenu.client.quick_swap.warning', '#gta3hud.qmenu.client.quick_swap.accept', function()
        GTA3HUD.settings.Select(option)
      end, '#gta3hud.qmenu.client.quick_swap.cancel')
    end
    for id, _ in SortedPairsByMemberValue(GTA3HUD.hud.All(), 'i') do
      select:AddChoice(id)
    end
    panel:AddItem(select)

    -- list of presets
    local presets = vgui.Create('Panel')
    presets:SetTall(256)

      local list = vgui.Create('DListView', presets)
      list:Dock(FILL)
      list:SetMultiSelect(false)
      list:AddColumn('#gta3hud.qmenu.client.presets')
      list.DoDoubleClick = function(_, _, line)
        GTA3HUD.settings.Load(line:GetValue(1))
      end
      list.Populate = function(self)
        for preset, _ in pairs(GTA3HUD.settings.Presets()) do
          list:AddLine(preset)
        end
        list:SortByColumn(1)
      end

      local options = vgui.Create('Panel', presets)
      options:Dock(BOTTOM)

        local buttons = vgui.Create('Panel', options)
        buttons:Dock(RIGHT)
        buttons:SetSize(40)

          local load = vgui.Create('DImageButton', buttons)
          load:SetImage('icon16/cd_go.png')
          load:SetSize(16, 16)
          load:SetY(4)
          load:SetDisabled(true)
          load.DoClick = function()
            local _, line = list:GetSelectedLine()
            GTA3HUD.settings.Load(line:GetValue(1))
          end

          local delete = vgui.Create('DImageButton', buttons)
          delete:SetImage('icon16/delete.png')
          delete:SetSize(16, 16)
          delete:SetPos(20, 4)
          delete:SetEnabled(false)
          delete.DoClick = function()
            local i, line = list:GetSelectedLine()
            Derma_Query(string.format(language.GetPhrase('gta3hud.qmenu.client.presets.delete.prompt'), line:GetValue(1)), '#gta3hud.qmenu.client.presets.delete', '#gta3hud.qmenu.client.presets.delete.accept', function()
              local name = line:GetValue(1)
              GTA3HUD.settings.Delete(name)
              list:RemoveLine(i)
              load:SetEnabled(false)
              delete:SetEnabled(false)
            end, '#gta3hud.qmenu.client.presets.delete.cancel')
          end

      list.OnRowSelected = function(self, _, row)
        local tooltip = '#gta3hud.qmenu.client.presets.delete'
        delete:SetDisabled(GTA3HUD.settings.Preset(row:GetValue(1)).engine)
        if delete:GetDisabled() then tooltip = '#gta3hud.qmenu.client.presets.unremovable' end
        delete:SetTooltip(tooltip)
        if not load:GetDisabled() then return end
        load:SetEnabled(true)
        load:SetTooltip('#gta3hud.qmenu.client.presets.load')
      end
      list:Populate()

      panel:AddItem(presets)
      GTA3HUD.toolmenu.list = list

    -- menu button
    panel:Button('#gta3hud.qmenu.client.open_menu', 'gta3hud_menu')

    -- reset button
    panel:Button('#gta3hud.qmenu.client.reset', 'gta3hud_reset')

    -- add wanted system options on single player
    if game.SinglePlayer() then AddWantedSystemOptions(panel) end

    -- credits
    panel:Help('\n' .. language.GetPhrase('gta3hud.credits')) -- separator
    for i=1, #GTA3HUD.credits do
      local credit = GTA3HUD.credits[i]
      panel:Help(credit[1])
      panel:ControlHelp(credit[2])
    end
    panel:Help('\n' .. GTA3HUD.date .. '\n')
  end)

  if game.SinglePlayer() then return end

  -- server settings
  spawnmenu.AddToolMenuOption(CATEGORY, GTA3HUD.name, 'sv_' .. UID, '#spawnmenu.utilities.server_settings', nil, nil, function(panel)
    panel:ClearControls()

    -- superadmin only override
    panel:CheckBox('#gta3hud.qmenu.server.super_admin_only', 'gta3hud_superadminonly')
    panel:ControlHelp('#gta3hud.qmenu.server.super_admin_only.help')

    -- radar visibility settings
    panel:Help('\n' .. language.GetPhrase('gta3hud.qmenu.server.radar'))
    panel:ControlHelp('#gta3hud.qmenu.server.radar.help')
    panel:CheckBox('#gta3hud.qmenu.server.radar.showplayersonradar', 'gta3hud_showplayersonradar')
    panel:CheckBox('#gta3hud.qmenu.server.radar.showteamplayersonradar', 'gta3hud_showteamplayersonradar')
    panel:CheckBox('#gta3hud.qmenu.server.radar.shownpcsonradar', 'gta3hud_shownpcsonradar')

    -- wanted system
    AddWantedSystemOptions(panel)

    -- administrator settings
    panel:Help('\n' .. language.GetPhrase('gta3hud.qmenu.server.overrides'))
    panel:ControlHelp('#gta3hud.qmenu.server.overrides.help')
    local overrides = vgui.Create('Panel', panel)
    overrides:Dock(TOP)
    overrides:DockMargin(24, 4, 16, 4)
    overrides:SetTall(48)
    overrides.Refresh = function(self)
      local skin = self:GetSkin()
      self:Clear()

      if not GTA3HUD.server.default and not GTA3HUD.server.override then
        local none = vgui.Create('DLabel', self)
        none:Dock(TOP)
        none:SetText('#gta3hud.qmenu.server.overrides.none')
        none:SizeToContents()
      else
        if GTA3HUD.server.default then
          local _, label = AddOverrideLabel(self, '#gta3hud.qmenu.server.overrides.default', '#gta3hud.qmenu.server.overrides.default.reset', function() GTA3HUD.server.RemoveDefault() end)
          if GTA3HUD.server.override then label:SetTextColor(skin.Colours.Label.Default) end
        end
        if GTA3HUD.server.override then
          AddOverrideLabel(self, '#gta3hud.qmenu.server.overrides.settings', '#gta3hud.qmenu.server.overrides.settings.reset', function() GTA3HUD.server.RemoveOverride() end)
        end
      end
    end
    overrides:Refresh()
    GTA3HUD.toolmenu.overrides = overrides

    -- submit
    panel:Help('#gta3hud.qmenu.server.overrides.submit')
    panel:Button('#gta3hud.qmenu.server.overrides.submit.default', 'gta3hud_submitdefault')
    panel:Button('#gta3hud.qmenu.server.overrides.submit.settings', 'gta3hud_submitoverride')
    panel:Help('')
    panel:Button('#gta3hud.qmenu.server.overrides.reset', 'gta3hud_svreset')
  end)
end)
