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
	local flex = view.NewFlex(list.frame)
	local pool = view.NewPool(flex.frame)
	
	self:bind(ctr, h, list, flex, pool)
	pool:Resize(2)

	local items = pool:AllActive()
	items[1]:SetText("meow")
	items[2]:SetText("woof")

	self.ctr = ctr
	self.h = h
	self.list = list
	self.pool = pool
	self.flex = flex
	
	return self
end

function view_obj:bind(ctr, h, list, flex, pool)
	h.OnDragStart.Subscribe(function() ctr:DragStart() end)
	h.OnDragStop.Subscribe(function() ctr:DragStop() end)

	ctr.OnHover.Subscribe(function() list:SetHover() end)
	ctr.OnUnhover.Subscribe(function() list:SetUnhover() end)

	pool.Changed.Subscribe(function()
		flex:Update()

		local height = flex.frame:GetHeight()
		list.frame:SetHeight(height)
		ctr:SetHeight(height)
	end)
end