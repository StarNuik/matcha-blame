-- Import
local view = blame.view

function view.NewContainer(parent)
	local self = {}

	local f  = CreateFrame("Frame", "Blame_Container", parent)
	f:SetWidth(view.CONTAINER_SIZE.width)
	f:SetHeight(view.CONTAINER_SIZE.height)
	f:SetPoint("TOP", 0, 0)
	f:SetMovable(true)
	f:EnableMouse(true)

	f:SetScript("OnEnter", function() api.Fire(view_event.HOVER_ON) end)
	f:SetScript("OnLeave", function() api.Fire(view_event.HOVER_OFF) end)

	api.Subscribe(view_event.DRAG_ON, function() f:StartMoving() end)
	api.Subscribe(view_event.DRAG_OFF, function() f:StopMovingOrSizing() end)
	api.Subscribe(view_event.FLEX_SIZE_CHANGED, function(size_y)
		local height = view.HEADER_HEIGHT + size_y
		f:SetHeight(height)
	end)

	self.frame = f
	return self
end
