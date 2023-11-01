
if SERVER then return end

GTA3HUD.settings = {} -- namespace

local GAMEPATH      = 'DATA'
local DIR           = 'gta3hud'
local EXTENSION     = '.dat'
local FILE_CURRENT  = DIR .. '\\current' .. EXTENSION
local DIR_PRESETS   = DIR .. '\\presets\\'
local FILE_PRESETS  = DIR .. '\\presets\\*' .. EXTENSION

local ILLEGAL_CHARACTERS = {'\'', '/', ':', '*', '?', '"', '<', '>', '|'}

GTA3HUD.settings.overrides = {} -- settings overrides through code
GTA3HUD.settings.server = {} -- administrator submitted override
local settings = { properties = {} } -- merged settings
local client = { properties = {} } -- client settings
local presets = {} -- registered presets

--[[------------------------------------------------------------------
  Merges two configuration tables together.
  @param {table} destination table
  @param {table} settings source to merge
]]--------------------------------------------------------------------
function GTA3HUD.settings.Merge(destination, source)
  if not source.name then return end

  -- reset settings if the base is different
  if destination.name ~= source.name then
    destination.name = source.name
    destination.properties = GTA3HUD.hud.Get(destination.name):CopySettings()
  end

  -- merge layer
  for id, value in pairs(source.properties) do
    if not istable(value) then destination[id] = value continue end
    if not destination[id] then destination[id] = {} end
    for name, property in pairs(value) do
      destination[id][name] = property
    end
  end
  table.Merge(destination.properties, source.properties)
end

--[[------------------------------------------------------------------
  Merges all configuration layers into one.
  WARNING: this is a costly operation -- use only when needed.
]]--------------------------------------------------------------------
function GTA3HUD.settings.Reload()
  -- reset cached settings to default
  settings.name = GTA3HUD.hud.default
  settings.properties = GTA3HUD.hud.Get(settings.name):CopySettings()

  -- apply settings modifiers
  if GTA3HUD.server.default then GTA3HUD.settings.Merge(settings, GTA3HUD.settings.server) end
  GTA3HUD.settings.Merge(settings, client)
  if GTA3HUD.server.override then GTA3HUD.settings.Merge(settings, GTA3HUD.settings.server) end
  for _, override in pairs(GTA3HUD.settings.overrides) do GTA3HUD.settings.Merge(settings, override) end
end

--[[------------------------------------------------------------------
  Loads the given variant and wipes the previous settings.
  @param {string} variant name
]]--------------------------------------------------------------------
function GTA3HUD.settings.Select(variant)
  client.name = variant
  table.Empty(client.properties)
  GTA3HUD.settings.Save()
  GTA3HUD.settings.Reload()
end

--[[------------------------------------------------------------------
  Loads the given settings.
  @param {table} settings
]]--------------------------------------------------------------------
function GTA3HUD.settings.Apply(data)
  client.name = data.name
  client.properties = GTA3HUD.settings.Copy(data.properties)
  GTA3HUD.settings.Reload()
end

--[[------------------------------------------------------------------
  Creates a deep copy of the given settings table.
  @param {table} settings to copy
  @return {table} copy
]]--------------------------------------------------------------------
function GTA3HUD.settings.Copy(settings)
  local copy = {}
  for k, v in pairs(settings) do
    if IsColor(v) then
      v = table.Copy(v)
    else
      local tbl = v
      if istable(tbl) then
        v = {}
        for i, j in pairs(tbl) do
          if istable(j) then j = table.Copy(j) end
          v[i] = j
        end
      end
    end
    copy[k] = v
  end
  return copy
end

--[[------------------------------------------------------------------
  Returns the client settings.
  @return {table} client settings
]]--------------------------------------------------------------------
function GTA3HUD.settings.Client()
  return client
end

--[[------------------------------------------------------------------
  Loads the default variant.
]]--------------------------------------------------------------------
function GTA3HUD.settings.Reset()
  client.name = nil
  table.Empty(client.properties)
  file.Delete(FILE_CURRENT)
  GTA3HUD.settings.Reload()
end

--[[------------------------------------------------------------------
  Initializes the client configuration.
]]--------------------------------------------------------------------
function GTA3HUD.settings.Init()
  -- create configuration folder and revert to default
  if not file.Exists(FILE_CURRENT, GAMEPATH) then
    if not file.Exists(DIR, GAMEPATH) then file.CreateDir(DIR) end
    GTA3HUD.settings.Reset()
    return
  end

  -- load presets
  if file.Exists(DIR_PRESETS, GAMEPATH) then GTA3HUD.settings.FetchPresets() end

  -- load configuration from disk
  GTA3HUD.settings.Apply(util.JSONToTable(file.Read(FILE_CURRENT, GAMEPATH)))
end

--[[------------------------------------------------------------------
  Saves the current configuration to the disk.
]]--------------------------------------------------------------------
function GTA3HUD.settings.Save()
  file.Write(FILE_CURRENT, util.TableToJSON(client))
end

--[[------------------------------------------------------------------
  Whether the given text contains illegal characters.
  @param {string} text
  @return {boolean} contains illegal characters
]]--------------------------------------------------------------------
function GTA3HUD.settings.HasIllegalCharacters(text)
  local illegal = string.len(string.Trim(text)) <= 0
  for _, char in pairs(ILLEGAL_CHARACTERS) do
    if string.find(text, char) then
      illegal = true
      break
    end
  end
  return illegal
end

--[[------------------------------------------------------------------
  Registers presets found on disk.
]]--------------------------------------------------------------------
function GTA3HUD.settings.FetchPresets()
  local files = file.Find(FILE_PRESETS, GAMEPATH)
  for _, filename in pairs(files) do
    local preset = util.JSONToTable(file.Read(DIR_PRESETS .. filename))
    presets[preset.name] = preset
  end
end

--[[------------------------------------------------------------------
  Saves the given settings preset to the disk.
  @param {number} name
  @param {table} settings
]]--------------------------------------------------------------------
function GTA3HUD.settings.SaveAs(name, data)
  local preset = {
    name = name,
    filename = DIR_PRESETS .. string.lower(name) .. EXTENSION,
    settings = data
  }
  if not file.Exists(DIR_PRESETS, GAMEPATH) then file.CreateDir(DIR_PRESETS) end
  file.Write(preset.filename, util.TableToJSON(preset))
  presets[name] = preset
end

--[[------------------------------------------------------------------
  Registers an engine preset.
  @param {number} name
  @param {table} settings
]]--------------------------------------------------------------------
function GTA3HUD.settings.Register(name, data)
  presets[name] = {
    name = name,
    settings = data,
    engine = true
  }
end

--[[------------------------------------------------------------------
  Deletes the given preset from disk.
  @param {string} name
]]--------------------------------------------------------------------
function GTA3HUD.settings.Delete(name)
  if not presets[name] then return end
  if presets[name].engine then return end
  file.Delete(GTA3HUD.settings.Preset(name).filename)
  presets[name] = nil
end

--[[------------------------------------------------------------------
  Loads the given preset.
  @param {string} name
]]--------------------------------------------------------------------
function GTA3HUD.settings.Load(name)
  GTA3HUD.settings.Apply(presets[name].settings)
  GTA3HUD.settings.Save()
end

--[[------------------------------------------------------------------
  Whether a preset with the given file name exists.
  @param {string} file name
  @return {boolean} exists
]]--------------------------------------------------------------------
function GTA3HUD.settings.PresetFileExists(filename)
  return file.Exists(DIR_PRESETS .. filename .. EXTENSION, GAMEPATH)
end

--[[------------------------------------------------------------------
  Returns all registered presets.
  @return {table} presets
]]--------------------------------------------------------------------
function GTA3HUD.settings.Presets()
  return presets
end

--[[------------------------------------------------------------------
  Returns a registered preset's data.
  @return {table} preset
]]--------------------------------------------------------------------
function GTA3HUD.settings.Preset(id)
  return presets[id]
end

--[[------------------------------------------------------------------
  Returns the actual settings used.
  @return {table} settings
]]--------------------------------------------------------------------
function GTA3HUD.settings.Get()
  return settings
end
