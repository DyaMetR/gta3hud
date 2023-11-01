--[[------------------------------------------------------------------
  Texture atlas based drawing API.

  > GTA3HUD.draw.Atlas(texture)
    - Creates a blank texture atlas

  > ATLAS.Add(id, x, y, w, h)
    - Adds a sub-image from the texture to the atlas

  > ATLAS.Draw(id, x, y, colour, scale, align)
    - Draws a previously registered sub-image from the texture atlas
]]--------------------------------------------------------------------

if SERVER then return end

GTA3HUD.draw = {} -- namespace

local DEBUGEMPTY = surface.GetTextureID('debug/debugempty')
local UNKNOWN = '?'
local POLY_VERTEX = { x = 0, y = 0 }

local ATLAS = { images = {} }
local CURSOR = {}
local FONT = { glyphs = {} }

--[[------------------------------------------------------------------
  Sets the texture used by the atlas.
  @param {Texture|Material} texture or material
]]--------------------------------------------------------------------
function ATLAS:SetTexture(resource, w, h)
  local texture = {
    resource = resource,
    w = w,
    h = h
  }
  if isnumber(resource) then
    texture.func = surface.SetTexture
  else
    texture.func = surface.SetMaterial
  end
  self.texture = texture
end

--[[------------------------------------------------------------------
  Adds an image.
  @param {string} image name
  @param {number} starting x in file
  @param {number} starting y in file
  @param {number} image width
  @param {number} image height
  @return {table} image data
]]--------------------------------------------------------------------
function ATLAS:Add(id, x, y, w, h)
  local image = { x = x, y = y, w = w, h = h }
  self.images[id] = image
  return image
end

--[[------------------------------------------------------------------
  Draws the given atlas image in the given position.
  @param {string} image name
  @param {number} x
  @param {number} y
  @param {Color|nil} colour
  @param {number|nil} scale
  @param {TEXT_ALIGN_LEFT|TEXT_ALIGN_RIGHT|nil} alignment
  @param {number|nil} width offset
  @param {number|nil} height offset
  @return {number} scaled width
  @return {number} scaled height
]]--------------------------------------------------------------------
function ATLAS:Draw(id, x, y, colour, scale, align, _w, _h)
  scale = scale or 1
  local image = self.images[id]

  -- draw a debug empty image if invalid
  if not image then
    local size = 64 * scale
    if align == TEXT_ALIGN_RIGHT then x = x - size end
    surface.SetTexture(DEBUGEMPTY)
    surface.SetDrawColor(color_white)
    surface.DrawTexturedRect(x, y, size, size)
    return size, size
  end

  -- get image coordinates
  local u0, v0, u1, v1 = image.x / self.texture.w, image.y / self.texture.h, (image.x + image.w) / self.texture.w, (image.y + image.h) / self.texture.h
  local du = 0.5 / self.texture.w -- half pixel anticorrection
  local dv = 0.5 / self.texture.h -- half pixel anticorrection
  local u0, v0 = (u0 - du) / (1 - 2 * du), (v0 - dv) / (1 - 2 * dv)
  local u1, v1 = (u1 - du) / (1 - 2 * du), (v1 - dv) / (1 - 2 * dv)

  -- apply alignment
  w, h = math.floor((image.w + (_w or 0)) * scale), math.floor((image.h + (_h or 0)) * scale)
  if align == TEXT_ALIGN_RIGHT then x = x - w end

  -- draw image
  self.texture.func(self.texture.resource)
  surface.SetDrawColor(colour or color_white)
  surface.DrawTexturedRectUV(x, y, w, h, u0, v0, u1, v1)

  return w, h
end

--[[------------------------------------------------------------------
  Returns an image's size.
  @param {number} width
  @param {number} height
]]--------------------------------------------------------------------
function ATLAS:GetSize(id)
  local image = self.images[id]
  if not image then return 0, 0 end
  return image.w, image.h
end

--[[------------------------------------------------------------------
  Returns whether the given image exists in the atlas.
  @param {string} image name
  @return {boolean} exists in the atlas
]]--------------------------------------------------------------------
function ATLAS:Exists(id)
  return self.images[id] ~= nil
end

--[[------------------------------------------------------------------
  Creates a new cursor to easily chain image adding. Provide a cell
  size to enable matrix mode for grid based texture atlas.
  @param {number} horizontal margin
  @param {number} vertical margin
  @param {number} cell width
  @param {number} cell height
  @return {table} cursor
]]--------------------------------------------------------------------
function ATLAS:Cursor(x, y, w, h)
  local cursor = table.Copy(CURSOR)
  cursor.atlas = self
  cursor.x = x or 0
  cursor.y = y or 0
  cursor.w = w
  cursor.h = h
  return cursor
end

--[[------------------------------------------------------------------
  Creates an image based font from the given atlas.
  @return {table} font
]]--------------------------------------------------------------------
function ATLAS:Font()
  local font = table.Copy(FONT)
  font.atlas = self
  return font
end

--[[------------------------------------------------------------------
  Skips the cursor a position.
  @param {number|nil} pixels to skip
  @param {number|nil} when reaching eof, how many pixels do we go down
]]--------------------------------------------------------------------
function CURSOR:Skip(w, h)
  w = w or self.w or 0
  h = h or self.h or 0

  -- go to next line if needed
  if self.x + w >= self.atlas.texture.w then
    w = w - (self.atlas.texture.w - self.x)
    self.x = 0
    self.y = self.y + h
  end

  self.x = self.x + w
end

--[[------------------------------------------------------------------
  Skips to the next position if a cell width has been specified.
  @param {number} cells to skip
]]--------------------------------------------------------------------
function CURSOR:Next(times)
  times = times or 1
  for i=1, times do self:Skip() end
end

--[[------------------------------------------------------------------
  Adds the next piece of texture atlas as an image and advances the cursor.
  @param {string} name of the image
  @param {number} image width
  @param {number} image height
  @param {number} image horizontal offset
  @param {number} image vertical offset
  @param {boolean} ignore cell configuration and advance the cursor the same size as the image
  @param {number} additional pixels to skip
]]--------------------------------------------------------------------
function CURSOR:Add(name, w, h, x, y, ignore, skip)
  x = x or 0
  y = y or 0
  skip = skip or 0
  self.atlas:Add(name, self.x + x, self.y + y, w or self.w, h or self.h)
  if ignore then self:Skip(w + skip, h + skip) return end
  self:Skip((self.w or w) + skip, (self.h or h) + skip)
end

--[[------------------------------------------------------------------
  Adds a group of sprites which the same configuration.
  @param {table} names of the images
  @param {number} images width
  @param {number} images height
  @param {number} images horizontal offset
  @param {number} images vertical offset
  @param {boolean} ignore cell configuration and advance the cursor the same size as the images
  @param {table} image configuration overrides
  @param {number} additional pixels to skip
]]--------------------------------------------------------------------
function CURSOR:Bulk(names, w, h, x, y, ignore, exceptions, skip)
  skip = skip or 0
  for _, name in pairs(names) do
    if name == NULL then
      if ignore then self:Skip(w + skip, h + skip) continue end
      self:Skip((self.w or w) + skip, (self.h or h) + skip)
      continue
    end
    local exception
    if exceptions then exception = exceptions[name] end
    if not exception then self:Add(name, w, h, x, y, ignore, skip) continue end
    if isnumber(exception) then self:Add(name, exception, h, x, y, ignore, skip) continue end
    self:Add(name, exception.w or w, exception.h or h, exception.x or x, exception.y or y, exception.ignore or ignore, exception.skip or skip)
  end
end

--[[------------------------------------------------------------------
  Returns whether the given glyph is registered.
  @param {string} glyph
  @return {boolean} it exists
]]--------------------------------------------------------------------
function FONT:Exists(glyph)
  return self.glyphs[glyph] ~= nil
end

--[[------------------------------------------------------------------
  Adds a sprite as a glyph.
  @param {string} sprite name which may also act as the glyph
  @param {number|nil} width
  @param {number|nil} height
  @param {string|nil} glyph
]]--------------------------------------------------------------------
function FONT:Add(sprite, w, h, glyph)
  local u, v = self.atlas:GetSize(sprite)
  self.glyphs[glyph or sprite] = { sprite = sprite, w = w or u, h = h or v }
end

--[[------------------------------------------------------------------
  Adds a group of glyphs with the same configuration.
  @param {table} sprites (and glyphs if different from sprite name)
  @param {number|nil} width
  @param {number|nil} height
  @param {string|nil} sprite name format (only used when not providing an explicit sprite)
]]--------------------------------------------------------------------
function FONT:Bulk(sprites, w, h, format)
  for sprite, glyph in pairs(sprites) do
    if isstring(sprite) then
      self:Add(sprite, w, h, glyph)
    else
      if format then
        self:Add(string.format(format, glyph), w, h, glyph)
      else
        self:Add(glyph, w, h)
      end
    end
  end
end

--[[------------------------------------------------------------------
  Adds all images from the atlas as glyphs.
]]--------------------------------------------------------------------
function FONT:Import()
  for glyph, image in pairs(self.atlas.images) do
    self:Add(glyph, image.w, image.h)
  end
end

--[[------------------------------------------------------------------
  Returns the size of the given glyph.
  @param {string} glyph
  @return {number} glyph width
  @return {number} glyph height
]]--------------------------------------------------------------------
function FONT:GetSize(glyph)
  return self.glyphs[glyph].w, self.glyphs[glyph].h
end

--[[------------------------------------------------------------------
  Returns the size of the given text using this font.
  @param {string} text
  @param {number|nil} spacing between characters
  @param {number|nil} width offset
  @param {number|nil} height offset
  @return {number} text width
  @return {number} text height
]]--------------------------------------------------------------------
local charstring, cache, cachew, cacheh = {}, '', 0, 0 -- cached text properties
function FONT:GetTextSize(text, spacing, _w, _h)
  text = tostring(text) -- make sure we get fed an actual string
  if cache == text then return cachew, cacheh end
  spacing = spacing or 0
  _w = _w or 0
  _h = _h or 0

  local w, h = 0, 0
  local len = utf8.len(text)
  table.Empty(charstring) -- flush previous cached string
  for i=1, len do
    local char = utf8.GetChar(text, i)
    if not self:Exists(char) then
      if not self:Exists(UNKNOWN) then continue end
      char = UNKNOWN
    end
    table.insert(charstring, char)
    local glyph = self.glyphs[char]
    w = w + glyph.w + _w
    if i < len then w = w + spacing end
    if glyph.h + _h > h then h = glyph.h + _h end
  end

  -- store in cache
  cache = text
  cachew = w
  cacheh = h

  return w, h
end

--[[------------------------------------------------------------------
  Draws the given text.
  @param {string} text
  @param {number|nil} x
  @param {number|nil} y
  @param {Color|nil} colour
  @param {number|nil} spacing between characters
  @param {number|nil} scale
  @param {TEXT_ALIGN_|nil} horizontal alignment
  @param {TEXT_ALIGN_|nil} vertical alignment
  @param {table} atlas to use instead of the default
  @param {number|nil} glyph width offset
  @param {number|nil} glyph vertical offset
]]--------------------------------------------------------------------
function FONT:DrawText(text, x, y, colour, spacing, scale, align, valign, _w, _h, override)
  x = x or 0
  y = y or 0
  colour = colour or color_white
  spacing = spacing or 0
  scale = scale or 1
  align = align or TEXT_ALIGN_LEFT
  valign = valign or TEXT_ALIGN_TOP
  _w = _w or 0
  _h = _h or 0

  -- get text size
  local w, h = self:GetTextSize(text, spacing, _w, _h) -- this caches the text
  w = math.floor(w * scale)
  h = math.floor(h * scale)

  -- apply text alignment
  if align == TEXT_ALIGN_RIGHT then
    x = x - w
  elseif align == TEXT_ALIGN_CENTER then
    x = x - w * .5
  end
  if valign == TEXT_ALIGN_BOTTOM then
    y = y - h
  elseif valign == TEXT_ALIGN_CENTER then
    y = y - h * .5
  end

  -- draw glyphs
  for i, char in pairs(charstring) do
    local glyph = self.glyphs[char]
    local atlas = override or self.atlas
    atlas:Draw(glyph.sprite, x, y, colour, scale, nil, _w * (self.atlas:GetSize(glyph.sprite) / glyph.w), _h)
    x = x + (glyph.w + spacing + _w) * scale
  end
  return w, h
end

--[[------------------------------------------------------------------
  Creates a new texture atlas.
  @param {Texture|Material} texture or material
  @param {number} texture width
  @param {number} texture height
  @return {table} blank atlas
]]--------------------------------------------------------------------
function GTA3HUD.draw.Atlas(texture, w, h)
  local atlas = table.Copy(ATLAS)
  atlas:SetTexture(texture, w, h)
  return atlas
end

--[[------------------------------------------------------------------
  Draws a triangle at the given position.
  @param {number} x
  @param {number} y
  @param {number} width
  @param {number} height
  @param {boolean} is it upside down
  @param {Color} colour
]]--------------------------------------------------------------------
local triangle = {}
for i=1, 3 do triangle[i] = table.Copy(POLY_VERTEX) end
function GTA3HUD.draw.Triangle(x, y, w, h, colour, reverse)
  -- set it up
  if not reverse then
    triangle[1].x = x
    triangle[1].y = y + h
    triangle[2].x = x + w * .5
    triangle[2].y = y
    triangle[3].x = x + w
    triangle[3].y = y + h
  else
    triangle[1].x = x
    triangle[1].y = y
    triangle[2].x = x + w
    triangle[2].y = y
    triangle[3].x = x + w * .5
    triangle[3].y = y + h
  end

  -- draw it
  draw.NoTexture()
  surface.SetDrawColor(colour)
  surface.DrawPoly(triangle)
end

--[[------------------------------------------------------------------
  Draws a triangle outline at the given position.
  @param {number} x
  @param {number} y
  @param {number} width
  @param {number} height
  @param {number} thickness
  @param {boolean} is it upside down
]]--------------------------------------------------------------------
local outline = {}
for i=1, 6 do outline[i] = table.Copy(POLY_VERTEX) end
function GTA3HUD.draw.TriangleOutline(x, y, w, h, thickness, reverse)
  -- set it up
  if not reverse then
    outline[1].x = x
    outline[1].y = y + h
    outline[2].x = x
    outline[2].y = y + h - thickness
    outline[3].x = x + w * .5 - thickness * .5
    outline[3].y = y
    outline[4].x = x + w * .5 + thickness * .5
    outline[4].y = y
    outline[5].x = x + w
    outline[5].y = y + h - thickness
    outline[6].x = x + w
    outline[6].y = y + h
  else
    outline[1].x = x
    outline[1].y = y
    outline[2].x = x + w
    outline[2].y = y
    outline[3].x = x + w
    outline[3].y = y + thickness
    outline[4].x = x + w * .5 + thickness * .5
    outline[4].y = y + h
    outline[5].x = x + w * .5 - thickness * .5
    outline[5].y = y + h
    outline[6].x = x
    outline[6].y = y + thickness
  end

  -- draw it
  draw.NoTexture()
  surface.SetDrawColor(color_black)
  surface.DrawPoly(outline)
end

--[[------------------------------------------------------------------
  Draws the original icon of the given weapon.
  @param {Weapon} weapon
  @param {number} x
  @param {number} y
  @param {number} width
]]--------------------------------------------------------------------
function GTA3HUD.draw.WeaponIcon(weapon, x, y, w)
  local h = w * 5 / 7
  x, y = x - w * .5, y - h * .5
  if not weapon.DrawWeaponSelection then return end
  local bounce = weapon.BounceWeaponIcon
  local infobox = weapon.DrawWeaponInfoBox
  weapon.BounceWeaponIcon = false
  weapon.DrawWeaponInfoBox = false
  weapon:DrawWeaponSelection(x, y, w, h, 255)
  weapon.DrawWeaponInfoBox = infobox
  weapon.BounceWeaponIcon = bounce
end
