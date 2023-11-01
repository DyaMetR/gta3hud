
if SERVER then return end

GTA3HUD.fonts = {} -- namespace

local FONT_FORMAT = 'gta3hud_%s'
local PREVIEW_FONT_FORMAT = 'gta3hud_preview_%s'

local fonts = {}

--[[------------------------------------------------------------------
	Creates a scalable font.
  @param {string} name
  @param {string} font family
  @param {number} size
  @param {number|nil} weight
	@param {boolean|nil} do not generate preview font
  @return {string} font name
	@return {string|nil} preview font name
]]--------------------------------------------------------------------
function GTA3HUD.fonts.Create(name, font, size, weight, nopreview)
  fonts[name] = { font = font, size = size, weight = weight }
	local preview
	if not nopreview then
		preview = string.format(PREVIEW_FONT_FORMAT, name)
		surface.CreateFont(preview, { font = font, size = size, weight = weight })
	end
  return string.format(FONT_FORMAT, name), preview
end

--[[------------------------------------------------------------------
	Generates all registered fonts with the given scale.
  @param {number} scale
]]--------------------------------------------------------------------
function GTA3HUD.fonts.Generate(scale)
  for name, font in pairs(fonts) do
    surface.CreateFont(string.format(FONT_FORMAT, name), {
      font = font.font,
      size = font.size * scale,
      weight = font.weight
    })
  end
end
