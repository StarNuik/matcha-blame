-- Import
local view = blame.view
-- Prototype
local view_obj = {}

function view.New(...)
	return blame.new2(view_obj, unpack(arg))
end

function view_obj:ctor(model)
	local ctr = view.NewContainer(UIParent)
	local h = view.NewHeader(ctr.frame)
	local list = view.NewList(ctr.frame)
	local pool = view.NewPool(list.frame)
	local flex = view.NewFlex(list.frame, function() return pool:AllActive() end)
	
	self:bind(ctr, h, list, flex, pool)
	self:bind_model(model, list, pool)

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

		local height = list.frame:GetHeight()
		-- list.frame:SetHeight(height)
		ctr:SetHeight(height)
	end)
end

function view_obj:bind_model(model, list, pool)
	api.Subscribe(view_event.EXTERNAL_UPDATE, function()
		if model.hide_list then
			list.frame:Hide()
		else
			list.frame:Show()
		end

		local target_count = blame.len(model.entries)
		pool:Resize(target_count)

		for idx, entry in ipairs(model.entries) do
			pool:SetText(idx, entry)
		end
	end)
end