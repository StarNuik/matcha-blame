-- Import
local view = blame.view

function view.NewCloseButton(parent)
	local self = {}

	local f = CreateFrame("Button", "$parent_CloseButton", parent)
	f:SetHeight(view.HEADER_HEIGHT)
	f:SetWidth(view.HEADER_HEIGHT)
	f:SetNormalTexture(view.CLOSE_ICON_PATH)
	f:SetPoint("RIGHT", parent, 0, 0)
	f:SetScript("OnClick", function() api.Fire(view_event.INPUT_CLOSE) end)

	self.frame = f
	return self
end
