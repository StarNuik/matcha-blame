local model = blame.model

blame.view = {}
blame.SetEnv(blame.view)

LIST_SPACING = 0
LIST_ENTRY_FONT_SIZE = 12
LIST_ENTRY_HEIGHT = LIST_ENTRY_FONT_SIZE + 2

HEADER_OPACITY = .7
HEADER_FONT_SIZE = 16
HEADER_HEIGHT = HEADER_FONT_SIZE + 2
HEADER_COLOR  = {r = 1., g = .8, b = .4}

CONTAINER_DEFAULT_OPACITY = 0.
CONTAINER_FOCUS_OPACITY = .7
CONTAINER_SIZE = {
	width = 200,
	height = HEADER_HEIGHT,
}

FONT_PATH = "Interface\\AddOns\\Blame\\Fonts\\UbuntuMono-Regular.ttf"
BACKDROP = { 
  bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
--  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  tile = true, tileSize = 16, edgeSize = 8,
  insets = { left = 0, right = 0, top = 0, bottom = 0 },
}

local function set_font(font_string, height, ...)
	font_string:SetFont(FONT_PATH, height, arg)
end

local function wrap_text_with_color(text, colorHexString)
	return string.format("|c%s%s|r", colorHexString, text)
end

local pool = {}
local active = {}
local container = {}
local entry_parent = {}
local header = {}

function Header(parent)
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


function CountActive()
	return table.getn(active)
end

function CountPool()
	return table.getn(pool)
end

function CountModel()
	return model.Count()
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

function Update()
	-- for k, v in pairs(self) do
	-- 	print(k .. ": " .. tostring(v))
	-- end
	local active_count = CountActive()
	local model_count = CountModel()
	if model_count > active_count then
		ExpandActive()
	elseif model_count < active_count then
		ShrinkActive()
	end
	Resize()
	UpdateView()
end

function ExpandActive()
	local curr_count = CountActive()
	local req_count = CountModel()
	local pool_count = CountPool()
	local total_count = pool_count + curr_count

	if req_count > total_count then
		ExpandPool(req_count - total_count)
	end

	local to_show = req_count - curr_count
	for _ = 1, to_show do
		local item = pop(pool)
		push(active, item)

		local last_idx = CountActive() - 1
		local rel_to = active[last_idx]
		if last_idx == 0 then
			rel_to = header
		end
		ShowItem(item, rel_to)
	end
end

function ExpandPool(count)
	for _ = 1, count do
		local item = NewItem(entry_parent)
		push(pool, item)
	end
end

function ShrinkActive()
	local curr_count = CountActive()
	local req_count = CountModel()

	local to_hide = curr_count - req_count
	for _ = 1, to_hide do
		local item = pop(active)
		HideItem(item)
		push(pool, item)
	end
end

function UpdateView()
	for idx, model_entry in pairs(model.All()) do
		local view_entry = active[idx]
		UpdateEntry(view_entry, model_entry)
	end
end

function ShowItem(item, rel_to)
	item:SetPoint("TOPLEFT", rel_to, "BOTTOMLEFT", 0, -LIST_SPACING)
	item:Show()
end

function UpdateEntry(view_entry, model_entry)
	local color = CLASS_COLORS[model_entry.class]
	local name = wrap_text_with_color(model_entry.name, color)

	local count = model_entry.count
	local desc = model_entry.description

	local text = string.format("%3d | %-24s | %s", count, name, desc)
	view_entry:SetText(text)
end

function HideItem(entry)
	entry:Hide()
end

-- Layout
function Resize()
	local active_count = CountActive()
	local list_height = LIST_ENTRY_HEIGHT * active_count + LIST_SPACING * active_count
	container:SetHeight(HEADER_HEIGHT + list_height)
	entry_parent:SetHeight(list_height)
end

function Container()
	local f  = CreateFrame("Frame", "Blame_Container", UIParent)
	f:SetWidth(CONTAINER_SIZE.width)
	f:SetHeight(CONTAINER_SIZE.height)
	f:SetPoint("CENTER", 0, 0)

	f:SetMovable(true)
	f:EnableMouse(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function() this:StartMoving() end)
	f:SetScript("OnDragStop", function() this:StopMovingOrSizing() end)
	f:SetScript("OnUpdate", function() if OnUpdate then OnUpdate() end end)
	return f
end

function RegisterColorChange(container, list_container)
	local set_opacity = function(alpha)
		return function()
			list_container:SetBackdropColor(0, 0, 0, alpha)
		end
	end
	container:SetScript("OnEnter", set_opacity(CONTAINER_FOCUS_OPACITY))
	container:SetScript("OnLeave", set_opacity(CONTAINER_DEFAULT_OPACITY))
end

function ListContainer(parent)
	local f = CreateFrame("Frame", "$parent_ListContainer", parent)
	f:SetPoint("TOPLEFT", parent, 0, -HEADER_HEIGHT)
	f:SetWidth(parent:GetWidth())
	f:SetHeight(parent:GetHeight() - HEADER_HEIGHT)
	f:SetBackdrop(BACKDROP)
	f:SetBackdropColor(.0, .0, .0, CONTAINER_DEFAULT_OPACITY)
	return f
end

function NewItem(parent)
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

function Init()
	container = Container()
	container:SetScript("OnUpdate", function() Update() end)

	entry_parent = ListContainer(container)

	entry_parent = Header(container)

	RegisterColorChange(container, entry_parent)
	Resize()
	ExpandPool(5)
end