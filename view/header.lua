-- Import
local view = blame.view

function view.NewHeader(parent)
	local self = {}

	local f = CreateFrame("Frame", "$parent_Header", parent)
	f:SetHeight(view.HEADER_HEIGHT)
	f:SetWidth(parent:GetWidth())
	f:SetBackdrop(view.BACKDROP)
	f:SetBackdropColor(.0, .0, .0, view.HEADER_OPACITY)
	f:SetPoint("TOP", parent, 0, 0)
	f:EnableMouse(true)
	
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function() api.Fire(view_event.DRAG_ON) end)
	f:SetScript("OnDragStop", function() api.Fire(view_event.DRAG_OFF) end)
	
	local text = f:CreateFontString(nil, "OVERLAY", "GameFontWhite")
	text:SetPoint("TOP", 0, 0)
	text:SetHeight(f:GetHeight())
	text:SetWidth(f:GetWidth())
	text:SetText(view.HEADER_TEXT)
	text:SetJustifyV("MIDDLE")
	view.set_font(text, view.HEADER_FONT_SIZE)
	
	self.frame = f
	return self
end
