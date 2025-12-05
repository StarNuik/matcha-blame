-- Import
local view = blame.view
-- Prototype
local list_item = {}

function view.NewListItem(parent)
	return blame.new2(list_item, parent)
end

function list_item:ctor(parent)
	local text = parent:CreateFontString(nil, "OVERLAY", "GameFontWhite")

	text:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)
	text:SetWidth(parent:GetWidth())
	text:SetHeight(view.LIST_ENTRY_HEIGHT)
	text:SetText("Empty entry")
	text:SetJustifyH("LEFT")
	text:SetShadowColor(0, 0, 0)
	text:SetShadowOffset(1, -1)
	view.set_font(text, view.LIST_ENTRY_FONT_SIZE)
	-- text:Hide()

	self.text = text
	return self
end

function list_item:Show()
	self.text:Show()
end

function list_item:Hide()
	self.text:Hide()
end

function list_item:SetText(text)
	self.text:SetText(text)
end