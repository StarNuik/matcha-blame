-- Import
local view = blame.view
-- Prototype
local list = {}

function view.NewList(parent)
	local self = {}
	
	local f = CreateFrame("Frame", "$parent_List", parent)
	f:SetPoint("TOP", 0, -view.HEADER_HEIGHT)
	f:SetWidth(parent:GetWidth())
	f:SetHeight(1)
	f:SetBackdrop(view.BACKDROP)
	f:SetBackdropColor(.0, .0, .0, view.CONTAINER_DEFAULT_OPACITY)
	
	api.Subscribe(view_event.HOVER_ON, function()
		f:SetBackdropColor(0, 0, 0, view.CONTAINER_HOVER_OPACITY)
	end)
	api.Subscribe(view_event.HOVER_OFF, function()
		f:SetBackdropColor(0, 0, 0, view.CONTAINER_DEFAULT_OPACITY)
	end)

	self.frame = f
	return self
end
