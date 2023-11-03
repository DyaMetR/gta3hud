
if SERVER then return end

-- originally all textures were half the size
-- but they were scaled in order for the HUD to not look tiny on the default scale

-- [[ Radar center ]] --
GTA3HUD.LCS.RADAR_CENTER = Material('gta3hud/lcs/radar_centre.png')

-- [[ HUD numbers ]] --
local HUD_ATLAS = GTA3HUD.draw.Atlas(Material('gta3hud/lcs/hudnumbers.png'), 256, 128)
HUD_ATLAS:Cursor(0, 0, 32, 34):Bulk({
  '0', '1', '2', '3', '4', '5', '6', '7',
  '8', '9', ':', '$', 'star'
}, nil, 32)
HUD_ATLAS:Add('-', 0, 68, 32, 34)
GTA3HUD.LCS.HUDATLAS = HUD_ATLAS

-- create font
local HUDNUMBERS = HUD_ATLAS:Font()
HUDNUMBERS:Bulk({'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '$', '-'}, 26)
HUDNUMBERS:Add(':', 18)
GTA3HUD.LCS.HUDNUMBERS = HUDNUMBERS

-- [[ Big text ]] --
local BIGATLAS = GTA3HUD.draw.Atlas(Material('gta3hud/lcs/bigtext.png'), 256, 256)
local BIGTEXT_HEIGHT = 39
local cursor = BIGATLAS:Cursor(nil, nil, nil, 40)
cursor:Add(' ', 7, BIGTEXT_HEIGHT)
cursor:Skip(1)
cursor:Add('!', 8, BIGTEXT_HEIGHT)
cursor:Skip(1)
cursor:Add('$', 18, BIGTEXT_HEIGHT)
cursor:Skip(1)
cursor:Add('&', 20, BIGTEXT_HEIGHT)
cursor:Add('\'', 8, BIGTEXT_HEIGHT)
cursor:Skip(2)
cursor:Bulk({'(', ')'}, 18, BIGTEXT_HEIGHT)
cursor:Skip(2)
cursor:Add(',', 7, BIGTEXT_HEIGHT)
cursor:Skip(2)
cursor:Add('-', 10, BIGTEXT_HEIGHT)
cursor:Skip(1)
cursor:Add('.', 8, BIGTEXT_HEIGHT)
cursor:Bulk({'/', '0', '1', '2', '3', '4'}, 18, BIGTEXT_HEIGHT, nil, nil, nil, { ['1'] = { w = 16 }, ['4'] = { w = 20 } }, 1)
cursor:Skip(11)
cursor:Bulk({'5', '6', '7', '8', '9'}, 18, BIGTEXT_HEIGHT, nil, nil, nil, nil, 1)
cursor:Add(':', 8, BIGTEXT_HEIGHT)
cursor:Skip(1)
cursor:Bulk({'?', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'}, 18, BIGTEXT_HEIGHT, nil, nil, nil, nil, 1)
cursor:Add('i', 8, BIGTEXT_HEIGHT)
cursor:Skip(1)
cursor:Bulk({'j', 'k'}, 18, BIGTEXT_HEIGHT, nil, nil, nil, nil, 1)
cursor:Add('l', 14, BIGTEXT_HEIGHT)
cursor:Skip(1)
cursor:Add('m', 28, BIGTEXT_HEIGHT)
cursor:Skip(1)
cursor:Bulk({'n', 'o', 'p', 'q', 'r', 's'}, 18, BIGTEXT_HEIGHT, nil, nil, nil, nil, 1)
cursor:Add('t', 20, BIGTEXT_HEIGHT)
cursor:Skip(11)
cursor:Add('u', 19, BIGTEXT_HEIGHT)
cursor:Add('v', 21, BIGTEXT_HEIGHT)
cursor:Add('w', 33, BIGTEXT_HEIGHT)
cursor:Bulk({'x', 'y', 'z', '¿'}, 19, BIGTEXT_HEIGHT)
cursor:Skip(1)
cursor:Bulk({'à', 'á', 'â', 'ä'}, 19, BIGTEXT_HEIGHT)
cursor:Skip(29)
cursor:Add('æ', 31, BIGTEXT_HEIGHT)
cursor:Bulk({'ç', 'è', 'é', 'ê'}, 19, BIGTEXT_HEIGHT)
cursor:Bulk({'ì', 'í'}, 10, BIGTEXT_HEIGHT)
cursor:Skip(4)
cursor:Add('î', 10, BIGTEXT_HEIGHT)
cursor:Skip(4)
cursor:Add('ï', 10, BIGTEXT_HEIGHT)
cursor:Bulk({'ñ', 'ò', 'ó', 'ô', 'ö'}, 19, BIGTEXT_HEIGHT)
cursor:Skip(6)
cursor:Bulk({'ù', 'ú', 'û', 'ü', 'ß'}, 19, BIGTEXT_HEIGHT)
cursor:Add('¡', 9, BIGTEXT_HEIGHT)
GTA3HUD.LCS.BIGATLAS = BIGATLAS -- export atlas

-- create font
local BIGTEXT = BIGATLAS:Font()
BIGTEXT:Import()
BIGTEXT:Add('4', 19) -- 4 is an exception
GTA3HUD.LCS.BIGTEXT = BIGTEXT -- export font

-- [[ Game text ]] --
local GAMEATLAS = GTA3HUD.draw.Atlas(Material('gta3hud/lcs/gametext.png'), 512, 512)
local cursor = GAMEATLAS:Cursor(nil, nil, nil, 46)
cursor:Add(' ', 12)
cursor:Skip(2)
cursor:Add('!', 10)
cursor:Skip(2)
cursor:Add('"', 16)
cursor:Skip(2)
cursor:Add('#', 24)
cursor:Skip(2)
cursor:Add('$', 26)
cursor:Skip(2)
cursor:Add('%', 38)
cursor:Skip(2)
cursor:Add('&', 34)
cursor:Skip(2)
cursor:Add('\'', 8)
cursor:Skip(2)
cursor:Bulk({'(', ')'}, 14)
cursor:Skip(2)
cursor:Bulk({'*', '+'}, 24)
cursor:Skip(4)
cursor:Add(',', 10)
cursor:Skip(2)
cursor:Add('-', 18)
cursor:Skip(2)
cursor:Add('.', 8)
cursor:Skip(2)
cursor:Add('/', 16)
cursor:Skip(2)
cursor:Bulk({'0', '1', '2', '3', '4', '5'}, 26, nil, nil, nil, nil, nil, 2)
cursor:Skip(18)
cursor:Bulk({'6', '7', '8', '9'}, 26, nil, nil, nil, nil, nil, 2)
cursor:Skip(2)
cursor:Bulk({':', ';'}, 8, nil, nil, nil, nil, nil, 6)
cursor:Skip(28)
cursor:Add('=', 24)
cursor:Skip(30)
cursor:Add('?', 24)
cursor:Skip(2)
cursor:Add('@', 32)
cursor:Skip(2)
cursor:Add('A', 30)
cursor:Skip(2)
cursor:Add('B', 26)
cursor:Skip(4)
cursor:Add('C', 28)
cursor:Skip(4)
cursor:Add('D', 28)
cursor:Skip(2)
cursor:Add('E', 24)
cursor:Skip(4)
cursor:Add('F', 22)
cursor:Skip(4)
cursor:Add('G', 30)
cursor:Skip(22)
cursor:Add('H', 26)
cursor:Skip(4)
cursor:Add('I', 10)
cursor:Skip(4)
cursor:Add('J', 24)
cursor:Skip(2)
cursor:Add('K', 28)
cursor:Add('L', 24)
cursor:Skip(2)
cursor:Add('M', 36)
cursor:Skip(6)
cursor:Add('N', 28)
cursor:Skip(2)
cursor:Add('O', 30)
cursor:Skip(4)
cursor:Add('P', 24)
cursor:Skip(2)
cursor:Add('Q', 30)
cursor:Skip(4)
cursor:Bulk({'R', 'S'}, 26, nil, nil, nil, nil, nil, 2)
cursor:Skip(2)
cursor:Add('T', 26)
cursor:Skip(2)
cursor:Add('U', 28)
cursor:Skip(4)
cursor:Add('V', 30)
cursor:Skip(2)
cursor:Add('W', 42)
cursor:Skip(30)
cursor:Add('X', 28)
cursor:Skip(2)
cursor:Add('Y', 30)
cursor:Skip(2)
cursor:Add('Z', 26)
cursor:Skip(2)
cursor:Add('[', 14)
cursor:Skip(2)
cursor:Add('\\', 14)
cursor:Add(']', 14)
cursor:Skip(4)
cursor:Add('^', 20)
cursor:Skip(2)
cursor:Add('_', 24)
cursor:Add('`', 12)
cursor:Skip(2)
cursor:Bulk({'a', 'b', 'c', 'd', 'e'}, 22, nil, nil, nil, nil, nil, 2)
cursor:Skip(2)
cursor:Add('f', 18)
cursor:Bulk({'g', 'h'}, 22, nil, nil, nil, nil, nil, 2)
cursor:Add('i', 10)
cursor:Skip(2)
cursor:Add('j', 12)
cursor:Skip(2)
cursor:Add('k', 20)
cursor:Skip(2)
cursor:Add('l', 10)
cursor:Skip(2)
cursor:Add('m', 30)
cursor:Skip(2)
cursor:Add('n', 22)
cursor:Skip(10)
cursor:Bulk({'o', 'p', 'q'}, 22, nil, nil, nil, nil, nil, 2)
cursor:Add('r', 18)
cursor:Skip(2)
cursor:Add('s', 22)
cursor:Skip(4)
cursor:Add('t', 20)
cursor:Skip(2)
cursor:Bulk({'u', 'v'}, 22, nil, nil, nil, nil, nil, 2)
cursor:Add('w', 32)
cursor:Skip(2)
cursor:Bulk({'x', 'y'}, 24)
cursor:Skip(2)
cursor:Add('z', 20)
cursor:Skip(2)
cursor:Add('{', 18)
cursor:Add('|', 10)
cursor:Skip(2)
cursor:Add('}', 18)
cursor:Add('~', 24)
cursor:Skip(4)
cursor:Add('¡', 10)
cursor:Skip(4)
cursor:Add('ç', 22)
cursor:Skip(4)
cursor:Add('£', 28)
cursor:Skip(30)
cursor:Add('¥', 26)
cursor:Skip(80)
cursor:Add('ª', 14)
cursor:Skip(130)
cursor:Add('´', 12)
cursor:Skip(48)
cursor:Add('º', 14)
cursor:Skip(22)
cursor:Add('¿', 24)
cursor:Skip(2)
cursor:Bulk({'À', 'Á', 'Â', 'Ã', 'Ä'}, 30, nil, nil, nil, nil, nil, 2)
cursor:Skip(24)
cursor:Add('Å', 30)
cursor:Skip(2)
cursor:Add('Æ', 40)
cursor:Skip(2)
cursor:Add('Ç', 28)
cursor:Skip(2)
cursor:Bulk({'È', 'É', 'Ê', 'Ë'}, 24, nil, nil, nil, nil, nil, 4)
cursor:Add('Ì', 14)
cursor:Skip(4)
cursor:Add('Í', 14)
cursor:Skip(2)
cursor:Add('Î', 16)
cursor:Skip(2)
cursor:Add('Ï', 14)
cursor:Skip(2)
cursor:Add('Đ', 30)
cursor:Skip(2)
cursor:Add('Ñ', 30)
cursor:Skip(2)
cursor:Bulk({'Ò', 'Ó', 'Ô', 'Õ', 'Ö'}, 30, nil, nil, nil, nil, nil, 2)
cursor:Skip(34)
cursor:Bulk({'Ø', 'Ù', 'Ú', 'Û', 'Ü', 'Ý'}, 30, nil, nil, nil, nil, nil, 2)
cursor:Skip(26)
cursor:Add('ß', 22)
cursor:Skip(2)
cursor:Bulk({'à', 'á', 'â', 'ã', 'ä', 'å'}, 22, nil, nil, nil, nil, nil, 2)
cursor:Add('æ', 34)
cursor:Skip(2)
cursor:Bulk({'ç', 'è'}, 22, nil, nil, nil, nil, nil, 2)
cursor:Skip(12)
cursor:Bulk({'é', 'ê', 'ë'}, 22, nil, nil, nil, nil, nil, 2)
cursor:Add('ì', 14)
cursor:Skip(2)
cursor:Add('í', 12)
cursor:Skip(2)
cursor:Bulk({'î', 'ï'}, 18)
cursor:Bulk({'đ', 'ñ', 'ò', 'ó', 'ô', 'õ', 'ö'}, 22, nil, nil, nil, nil, nil, 2)
cursor:Skip(30)
cursor:Bulk({'ø', 'ù', 'ú', 'û', 'ü'}, 22, nil, nil, nil, nil, nil, 2)
cursor:Skip(2)
cursor:Add('ý', 22)
GTA3HUD.LCS.GAMEATLAS = GAMEATLAS -- export atlas

-- create font
local GAMETEXT = GAMEATLAS:Font()
GAMETEXT:Import()
GTA3HUD.LCS.GAMETEXT = GAMETEXT -- export font

-- [[ HUD Numbers ]] --
--[[local HUDNUMBERS = GTA3HUD.draw.Atlas(Material('gta3hud/lcs/hudnumbers.png'), 256, 128)
GTA3HUD.LCS.HUDNUMBERS = HUDNUMBERS -- export atlas

-- digits
for i=0, 9 do
  local x, y = 32 * i, 0
  if i >= 8 then
    x = 32 * (i - 8)
    y = 34
  end
  HUDNUMBERS:Add(tostring(i), x, y, 26, 32)
end

-- icons
HUDNUMBERS:Add('$', 96, 34, 26, 32)
HUDNUMBERS:Add(':', 64, 34, 26, 32)
HUDNUMBERS:Add('star', 128, 34, 32, 32)]]

-- [[ Big text ]] --
--[[local BIGTEXT = GTA3HUD.draw.Atlas(Material('gta3hud/lcs/bigtext.png'), 256, 256)
GTA3HUD.LCS.BIGTEXT = BIGTEXT -- export atlas

-- alphabet
local x, y = 123, 0
local SPLIT = { 7, 20 }
local EXCEPTIONS = { i = 8, l = 14, m = 31, t = 21, v = 22, w = 31 }
for i, letter in pairs(GTA3HUD.util.LOWERCASE) do
  local w = EXCEPTIONS[letter] or 19
  BIGTEXT:Add(letter, x, 42 + y * 40, w, 38)
  x = x + w
  if table.HasValue(SPLIT, i) then
    x = 0
    y = y + 1
  end
end

-- characters
BIGTEXT:Add('!', 8, 2, 8, 38)]]

-- [[ Game text ]] --
--[[local GAMETEXT = GTA3HUD.draw.Atlas(Material('gta3hud/lcs/gametext.png'), 256, 256)
GTA3HUD.LCS.GAMETEXT = GAMETEXT -- export atlas

-- digits
local x, y = 163, 2
for i=0, 9 do
  GAMETEXT:Add(tostring(i), x, y, 13, 16)
  x = x + 14
  if i == 5 then -- go to next row
    x = 0
    y = y + 23
  end
end

-- characters
GAMETEXT:Add(' ', 0, 0, 2, 16)
GAMETEXT:Add('-', 141, 2, 7, 16)
GAMETEXT:Add('|', 156, 93, 5, 21)]]
