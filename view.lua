local LIST_SPACING = 0
local CONTAINER_DEFAULT_OPACITY = 0.
local CONTAINER_FOCUS_OPACITY = .7
local HEADER_OPACITY = .7
local HEADER_FONT_SIZE = 16
local HEADER_HEIGHT = HEADER_FONT_SIZE + 2
local HEADER_COLOR  = {r = 1., g = .8, b = .4}
local LIST_ENTRY_FONT_SIZE = 12
local LIST_ENTRY_HEIGHT = LIST_ENTRY_FONT_SIZE + 2
local FONT_PATH = "Interface\\AddOns\\matcha-blame\\Fonts\\UbuntuMono-Regular.ttf"
local CONTAINER_SIZE = {
	width = 160,
	height = HEADER_HEIGHT,
}
local BACKDROP = { 
  bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
--  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  tile = true, tileSize = 16, edgeSize = 8,
  insets = { left = 0, right = 0, top = 0, bottom = 0 },
}
local CLASS_COLORS = {
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

local function set_font(font_string, height, ...)
	font_string:SetFont(FONT_PATH, height, arg)
end

local function wrap_text_with_color(text, colorHexString)
	return string.format("|c%s%s|r", colorHexString, text)
end

local function time_to_str(time)
	local now = _G.time()
	local delta = now - time
	if delta <= 60 then
		return delta .. "s"
		-- return "<1m"
	end
	if delta <= 60 * 60 then
		return floor(delta / 60) .. "m"
	end
	if delta <= 60 * 60 * 24 then
		return floor(delta / 60 / 60) .. "h"
	end
	return "long ago"
end

local view = {}

function view:Init()
	local frame = self:Container()
	frame:SetScript("OnUpdate", function() self:Update() end)
	self.frame = frame

	local entry_parent = self:ListContainer(frame)
	self.entry_parent = entry_parent

	local h = self:Header(frame)
	self.header = h

	self:RegisterColorChange(frame, entry_parent)
	self:Resize()
	self:ExpandPool(5)
	return self
end

function blame:NewView(model)
	local self = new(view)
	self.model = model
	self.pool = {}
	self.active = {}

	self:Init()

	return self
end

function view:CountActive()
	return table.getn(self.active)
end

function view:CountPool()
	return table.getn(self.pool)
end

function view:CountModel()
	return table.getn(self.model.entries)
end

local function pop(list)
	local idx = table.getn(list)
	local item = list[idx]
	list[idx] = nil
	return item
end

local function push(list, item)
	local idx = table.getn(list)
	list[idx + 1] = item
end

local function len(list)
	return table.getn(list)
end

function view:Update()
	-- for k, v in pairs(self) do
	-- 	print(k .. ": " .. tostring(v))
	-- end
	local active_count = self:CountActive()
	local model_count = self:CountModel()
	if model_count > active_count then
		self:ExpandActive()
	elseif model_count < active_count then
		self:ShrinkActive()
	end
	self:Resize()
	self:UpdateView()
end

function view:ExpandActive()
	local curr_count = self:CountActive()
	local req_count = self:CountModel()
	local pool_count = self:CountPool()
	local total_count = pool_count + curr_count

	if req_count > total_count then
		self:ExpandPool(req_count - total_count)
	end

	local to_show = req_count - curr_count
	for _ = 1, to_show do
		local item = pop(self.pool)
		push(self.active, item)

		local last_idx = self:CountActive() - 1
		local rel_to = self.active[last_idx]
		if last_idx == 0 then
			rel_to = self.header
		end
		self:ShowItem(item, rel_to)
	end
end

function view:ExpandPool(count)
	for _ = 1, count do
		local item = self:NewItem(self.entry_parent)
		push(self.pool, item)
	end
end

function view:ShrinkActive()
	local curr_count = self:CountActive()
	local req_count = self:CountModel()

	local to_hide = curr_count - req_count
	for _ = 1, to_hide do
		local item = pop(self.active)
		self:HideItem(item)
		push(self.pool, item)
	end
end

function view:UpdateView()
	for idx, model_entry in pairs(self.model:All()) do
		local view_entry = self.active[idx]
		self:UpdateEntry(view_entry, model_entry)
	end
end

function view:ShowItem(item, rel_to)
	item:SetPoint("TOPLEFT", rel_to, "BOTTOMLEFT", 0, -LIST_SPACING)
	item:Show()
end

function view:UpdateEntry(view_entry, model_entry)
	local color = CLASS_COLORS[model_entry.class]
	local name = wrap_text_with_color(model_entry.name, color)

	local count = model_entry.count
	local desc = time_to_str(model_entry.time)

	local text = string.format("%3d | %-24s | %s", count, name, desc)
	view_entry:SetText(text)
end

function view:HideItem(entry)
	entry:Hide()
end

-- Layout
function view:Resize()
	local active_count = self:CountActive()
	local list_height = LIST_ENTRY_HEIGHT * active_count + LIST_SPACING * active_count
	self.frame:SetHeight(HEADER_HEIGHT + list_height)
	self.entry_parent:SetHeight(list_height)
end

function view:Container()
	local f  = CreateFrame("Frame", "Blame_Container", UIParent)
	f:SetWidth(CONTAINER_SIZE.width)
	f:SetHeight(CONTAINER_SIZE.height)
	f:SetPoint("CENTER", 0, 0)

	f:SetMovable(true)
	f:EnableMouse(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function() this:StartMoving() end)
	f:SetScript("OnDragStop", function() this:StopMovingOrSizing() end)
	f:SetScript("OnUpdate", function() if self.OnUpdate then self.OnUpdate() end end)
	return f
end

function view:RegisterColorChange(container, list_container)
	local set_opacity = function(alpha)
		return function()
			list_container:SetBackdropColor(0, 0, 0, alpha)
		end
	end
	container:SetScript("OnEnter", set_opacity(CONTAINER_FOCUS_OPACITY))
	container:SetScript("OnLeave", set_opacity(CONTAINER_DEFAULT_OPACITY))
end

function view:ListContainer(parent)
	local f = CreateFrame("Frame", "$parent_ListContainer", parent)
	f:SetPoint("TOPLEFT", parent, 0, -HEADER_HEIGHT)
	f:SetWidth(parent:GetWidth())
	f:SetHeight(parent:GetHeight() - HEADER_HEIGHT)
	f:SetBackdrop(BACKDROP)
	f:SetBackdropColor(.0, .0, .0, CONTAINER_DEFAULT_OPACITY)
	return f
end

function view:NewItem(parent)
	local text = parent:CreateFontString(nil, "OVERLAY", "GameFontWhite")
	-- text:SetPoint("TOPLEFT", rel_to, "BOTTOMLEFT", 0, -LIST_SPACING)
	text:SetWidth(parent:GetWidth())
	text:SetHeight(LIST_ENTRY_HEIGHT)
	text:SetText("Empty entry")
	text:SetJustifyH("LEFT")
	text:SetShadowColor(0, 0, 0)
	text:SetShadowOffset(1, -1)
	set_font(text, LIST_ENTRY_FONT_SIZE)
	text:Hide()
	return text
end

function view:Header(parent)
	local f = CreateFrame("Frame", "$parent_Header", parent)
	f:SetHeight(HEADER_HEIGHT)
	f:SetWidth(parent:GetWidth())
	f:SetBackdrop(BACKDROP)
	f:SetBackdropColor(.0, .0, .0, HEADER_OPACITY)
	f:SetPoint("TOPLEFT", parent, 0, 0)

	local text = f:CreateFontString(nil, "OVERLAY", "GameFontWhite")
	text:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)
	text:SetHeight(f:GetHeight())
	text:SetWidth(f:GetWidth())
	text:SetText("Blame")
	text:SetTextColor(HEADER_COLOR.r, HEADER_COLOR.g, HEADER_COLOR.b)
	text:SetJustifyV("MIDDLE")
	set_font(text, HEADER_FONT_SIZE)
	return f
end