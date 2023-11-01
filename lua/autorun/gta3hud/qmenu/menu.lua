
if SERVER then return end

local URL_STEAMWORKSHOP = 'https://steamcommunity.com/sharedfiles/filedetails/?id=3068556242'
local URL_GITHUB = 'https://github.com/DyaMetR/gta3hud'

local MIN_W, MIN_H = 640, 480
local W, H = .6, .7

--[[------------------------------------------------------------------
  Creates the customization menu.
]]--------------------------------------------------------------------
concommand.Add('gta3hud_menu', function()

  local cache = GTA3HUD.settings.Copy(GTA3HUD.settings.Get())

  -- [[ Window ]] --
  local frame = vgui.Create('GTA3HUD_Frame')
  frame:SetTitle('#gta3hud.menu')
  frame:SetSize(MIN_W, math.max(ScrH() * H, MIN_H))
  frame:Center()
  frame:MakePopup()
  frame.Apply = function()
    GTA3HUD.settings.Apply(cache)
    GTA3HUD.settings.Save()
  end

    -- [[ Menu bar ]] --
    local file = frame:AddMenu('#gta3hud.menu.menubar.file')

      -- New
      local new, parent = file:AddSubMenu('#gta3hud.menu.menubar.file.new', function() end)
      parent:SetIcon('icon16/page_add.png')
      new:SetDeleteSelf(false)

        for id, _ in SortedPairsByMemberValue(GTA3HUD.hud.All(), 'i') do
          new:AddOption(id)
        end

      -- Load
      local load, parent = file:AddSubMenu('#gta3hud.menu.menubar.file.open')
      parent:SetIcon('icon16/folder_page.png')
      load:SetDeleteSelf(false)
      frame.LoadPresets = function()
        load:Clear()
        for name, data in SortedPairs(GTA3HUD.settings.Presets()) do
          load:AddOption(name, function()
            cache.name = nil
            table.Empty(cache.properties)
            GTA3HUD.settings.Merge(cache, data.settings)
            frame.variant:SetText(data.settings.name)
            frame.properties:Refresh()
          end)
        end
      end
      frame:LoadPresets()

      -- Save As...
      file:AddOption('#gta3hud.menu.menubar.file.save_as', function()
        Derma_StringRequest('#gta3hud.menu.menubar.file.save_as', '#gta3hud.menu.save_as.filename', '', function(value)
          if GTA3HUD.settings.HasIllegalCharacters(value) then
            Derma_Message('#gta3hud.menu.save_as.format_error', '#gta3hud.menu.menubar.file.save_as', '#gta3hud.menu.save_as.ok')
          else
            local preset = GTA3HUD.settings.Preset(value)
            if preset and preset.engine then Derma_Message('#gta3hud.menu.save_as.duplicate_error', '#gta3hud.menu.menubar.file.save_as') return end
            if preset or GTA3HUD.settings.PresetFileExists(string.lower(value)) then
              Derma_Query('#gta3hud.menu.save_as.duplicate', '#gta3hud.menu.menubar.file.save_as', '#gta3hud.menu.save_as.yes', function()
                GTA3HUD.settings.SaveAs(value, cache)
                frame:LoadPresets()
              end, '#gta3hud.menu.save_as.no')
            else
              GTA3HUD.settings.SaveAs(value, cache)
              if GTA3HUD.toolmenu.list then GTA3HUD.toolmenu.list:AddLine(value) end
              frame:LoadPresets()
            end
          end
        end)
      end):SetIcon('icon16/disk.png')

      -- Exit
      file:AddOption('#gta3hud.menu.menubar.file.exit', function() frame:Close() end):SetIcon('icon16/cancel.png')

    local edit = frame:AddMenu('#gta3hud.menu.menubar.edit')

      -- Apply changes
      edit:AddOption('#gta3hud.menu.menubar.edit.apply', function() end):SetIcon('icon16/accept.png')
      edit.OnClick = function() frame:Apply() end

    local help = frame:AddMenu('#gta3hud.menu.menubar.help')

      -- Report bug
      local bug, parent = help:AddSubMenu('#gta3hud.menu.menubar.help.report')
      parent:SetIcon('icon16/bug.png')
      bug:SetDeleteSelf(false)

        -- ... on the Steam Workshop
        bug:AddOption('#gta3hud.menu.menubar.help.report.steam', function() gui.OpenURL(URL_STEAMWORKSHOP) end):SetIcon('gta3hud/steam16.png')

        -- ... on the GitHub repository
        bug:AddOption('#gta3hud.menu.menubar.help.report.github', function() gui.OpenURL(URL_GITHUB) end):SetIcon('gta3hud/github16.png')

      -- About
      help:AddSpacer()
      help:AddOption('#gta3hud.menu.menubar.help.about', function()
        local about = vgui.Create('GTA3HUD_About')
        about:SetTitle('#gta3hud.menu.menubar.help.about')
        about:Center()
      end):SetIcon('icon16/information.png')

    -- [[ Variant selection ]] --
    local variant = vgui.Create('DPanel', frame)
    variant:SetTall(68)
    variant:Dock(TOP)
    variant:DockPadding(5, 5, 5, 5)

      local label = vgui.Create('GTA3HUD_Label', variant)
      label:SetText('#gta3hud.menu.hud')
      label:SetHelpText('#gta3hud.menu.hud.help')
      label:Dock(TOP)
      label:DockMargin(5, 2, 0, 0)

      local select = vgui.Create('DComboBox', variant)
      select:Dock(BOTTOM)
      select:SetSortItems(false)
      select:SetValue(cache.name)
      select.OnSelect = function(self, _, option)
        cache.name = option
        cache.properties = GTA3HUD.hud.Get(option):CopySettings()
        frame.properties:Refresh()
      end
      for id, _ in SortedPairsByMemberValue(GTA3HUD.hud.All(), 'i') do
        select:AddChoice(id)
      end
      frame.variant = select

    -- [[ Properties ]] --
    local properties = vgui.Create('DCategoryList', frame)
    frame.properties = properties
    properties:Dock(FILL)
    properties:DockMargin(0, 5, 0, 0)
    properties.Refresh = function()
      properties:Clear()

      -- reserve uncategorized parameters tray
      local uncategorized = {}
      local parameters = vgui.Create('GTA3HUD_Settings', properties)

      -- categorized parameters
      for id, settings in SortedPairsByMemberValue(GTA3HUD.hud.Get(cache.name).properties, 'i') do
        if settings._category then
          local category = properties:Add(settings.name)
            local contents = vgui.Create('Panel')
              local reset = vgui.Create('DButton', contents)
              reset:Dock(TOP)
              reset:SetText('#gta3hud.menu.reset')
              reset:SetImage('icon16/arrow_refresh.png')

              if settings.Preview then
                local preview = vgui.Create('DImage', contents)
                preview:Dock(TOP)
                preview:SetTall(128)
                preview:SetMaterial(Material(string.format('gta3hud/preview%s.png', math.random(0, 1))))
                preview:SetKeepAspect(true)
                  local drawbox = vgui.Create('Panel', preview)
                  drawbox:Dock(FILL)
                  drawbox.Paint = function(self)
                    settings:Preview(self:GetWide(), self:GetTall(), cache.properties)
                  end
              end

              local controls = vgui.Create(settings.derma, contents)
              controls:Dock(TOP)
              controls:Populate(settings.properties, cache.properties[id])

              reset.DoClick = function()
                for name, parameter in pairs(settings.properties) do
                  local default = parameter.default
                  if istable(default) then default = table.Copy(default) end
                  cache.properties[id][name] = default
                end
                controls:Clear()
                controls:Populate(settings.properties, cache.properties[id])
              end
          category:SetContents(contents)
          category:SetExpanded(false)
        else
          uncategorized[id] = settings
        end
      end

      -- add uncategorized parameters
      parameters:Populate(uncategorized, cache.properties)

      -- refresh layout
      properties:InvalidateLayout()
    end
    properties:Refresh()

end)
