-- Import
local view = blame.view
-- Prototype
local header = {}

function view.NewHeader(parent)
	return blame.new2(header, parent)
end

function header:ctor(parent)
	self.OnDragStart = blame.new_event()
	self.OnDragStop = blame.new_event()
	
	local f = CreateFrame("Frame", "$parent_Header", parent)
	f:SetHeight(view.HEADER_HEIGHT)
	f:SetWidth(parent:GetWidth())
	f:SetBackdrop(view.BACKDROP)
	f:SetBackdropColor(.0, .0, .0, view.HEADER_OPACITY)
	f:SetPoint("TOPLEFT", parent, 0, 0)
	f:EnableMouse(true)
	
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function() self.OnDragStart:Fire() end)
	f:SetScript("OnDragStop", function() self.OnDragStop:Fire() end)
	
	local text = f:CreateFontString(nil, "OVERLAY", "GameFontWhite")
	text:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0)
	text:SetHeight(f:GetHeight())
	text:SetWidth(f:GetWidth())
	text:SetText(view.HEADER_TEXT)
	text:SetJustifyV("MIDDLE")
	view.set_font(text, view.HEADER_FONT_SIZE)
	
	self.frame = f
	return self
end
