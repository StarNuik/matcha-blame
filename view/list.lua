-- Import
local view = blame.view
-- Prototype
local list = {}

function view.NewList(parent)
	return blame.new2(list, parent)
end

function list:ctor(parent)
	local f = CreateFrame("Frame", "$parent_List", parent)
	
	f:SetPoint("TOP", 0, -view.HEADER_HEIGHT)
	f:SetWidth(parent:GetWidth())
	f:SetHeight(1)
	f:SetBackdrop(view.BACKDROP)
	f:SetBackdropColor(.0, .0, .0, view.CONTAINER_DEFAULT_OPACITY)
	
	self.frame = f
	return self
end

function list:SetHover()
	self.frame:SetBackdropColor(0, 0, 0, view.CONTAINER_HOVER_OPACITY)
end

function list:SetUnhover()
	self.frame:SetBackdropColor(0, 0, 0, view.CONTAINER_DEFAULT_OPACITY)
end
