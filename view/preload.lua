-- Import
local view = blame.view

view.HEADER_TEXT = "|cffF5CF27Blame|r"
view.LIST_SPACING = 0
view.CONTAINER_DEFAULT_OPACITY = 0.4
view.CONTAINER_FOCUS_OPACITY = .83
view.HEADER_OPACITY = 1
view.HEADER_FONT_SIZE = 16
view.HEADER_HEIGHT = view.HEADER_FONT_SIZE + 2
view.HEADER_COLOR  = {r = 1., g = .8, b = .4}
view.LIST_ENTRY_FONT_SIZE = 12
view.LIST_ENTRY_HEIGHT = view.LIST_ENTRY_FONT_SIZE + 2
view.FONT_PATH = "Interface\\AddOns\\matcha-blame\\Fonts\\UbuntuMono-Regular.ttf"
view.CONTAINER_SIZE = {
	width = 160,
	height = view.HEADER_HEIGHT,
}
view.BACKDROP = { 
  bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
--  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  tile = true, tileSize = 16, edgeSize = 8,
  insets = { left = 0, right = 0, top = 0, bottom = 0 },
}
view.CLASS_COLORS = {
	DRUID = "FFFF7C0A",
	HUNTER = "FFAAD372",
	MAGE = "FF3FC7EB",
	PALADIN = "FFF48CBA",
	PRIEST = "FFFFFFFF",
	ROGUE = "FFFFF468",
	SHAMAN = "FF0070DD",
	WARLOCK = "FF8788EE",
	WARRIOR = "FFC69B6D",
	NPC = "FF909090",
	ENEMY = "FFFF3030",
}

function view.set_font(font_string, height, ...)
	font_string:SetFont(view.FONT_PATH, height, arg)
end

function view.wrap_text_with_color(text, colorHexString)
	return string.format("|c%s%s|r", colorHexString, text)
end

function view.time_to_str(time)
	local now = _G.time()
	local delta = now - time
	if delta <= 60 then
		-- return delta .. "s"
		return "<1m"
	end
	if delta <= 60 * 60 then
		return floor(delta / 60) .. "m"
	end
	if delta <= 60 * 60 * 24 then
		return floor(delta / 60 / 60) .. "h"
	end
	return "long ago"
end