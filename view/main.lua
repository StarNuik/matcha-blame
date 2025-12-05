-- Import
local view = blame.view
-- Prototype
local view_obj = {}

function view.New()
	return blame.new2(view_obj)
end

function view_obj:ctor()
	local ctr = view.NewContainer(UIParent)
	local h = view.NewHeader(ctr.frame)
	local list = view.NewList(ctr.frame)
	local pool = view.NewPool(list.frame)
	-- local test = view.NewListItem(list.frame)
	
	self:bind(ctr, h, list)
	pool:Resize(2)

	local items = pool:AllActive()
	items[1]:SetText("meow")
	items[2]:SetText("woof")

	self.ctr = ctr
	self.h = h
	self.list = list
	
	return self
end

function view_obj:bind(ctr, h, list)
	h.OnDragStart:Subscribe(function() ctr:DragStart() end)
	h.OnDragStop:Subscribe(function() ctr:DragStop() end)

	ctr.OnHover:Subscribe(function() list:SetHover() end)
	ctr.OnUnhover:Subscribe(function() list:SetUnhover() end)
end