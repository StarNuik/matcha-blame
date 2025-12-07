-- Import
local view = blame.view

function view.New(model)
	local self = {}

	local ctr = view.NewContainer(UIParent)
	local h = view.NewHeader(ctr.frame)
	local list = view.NewList(ctr.frame)
	local pool = view.NewPool(list.frame, model)
	local flex = view.NewFlex(list.frame, function() return pool.AllActive() end)
	
	self.ctr = ctr
	self.h = h
	self.list = list
	self.pool = pool
	self.flex = flex
	
	return self
end
