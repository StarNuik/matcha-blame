-- Import
local view = blame.view
-- Prototype
local container = {}

function view.NewContainer(parent)
	return blame.new2(container, parent)
end

function container:ctor(parent)
	self.OnHover = blame.new_event()
	self.OnUnhover = blame.new_event()

	local f  = CreateFrame("Frame", "Blame_Container", parent)
	f:SetWidth(view.CONTAINER_SIZE.width)
	f:SetHeight(view.CONTAINER_SIZE.height)
	f:SetPoint("TOP", 0, 0)
	f:SetMovable(true)
	f:EnableMouse(true)

	f:SetScript("OnEnter", function() self.OnHover:Fire() end)
	f:SetScript("OnLeave", function() self.OnUnhover:Fire() end)

	self.frame = f
	return self
end

function container:DragStart()
	self.frame:StartMoving()
end

function container:DragStop()
	self.frame:StopMovingOrSizing()
end

function container:SetHeight(size_y)
	self.frame:SetHeight(view.HEADER_HEIGHT + size_y)
end