-- Import
local view = blame.view

function view.NewPool(parent, get_entry)
	local self = {
		active = {},
		hidden = {},
		item_count = 0,
		frame = parent,
	}

	function self.AllActive()
		return self.active
	end

	api.Subscribe(view_event.MODEL_ENTRIES_CHANGED, function(count) self:resize(count) end)

	function self:resize(target_count)
		-- if target_count == len(self.active) then
		-- 	api.Fire(view_event.POOL_ASKS_UPDATE)
		-- 	return
		-- end

		self:hide_all()
		while self.item_count < target_count do
			self:expand()
		end
		self:show(target_count)

		api.Fire(view_event.POOL_CHANGED)
		api.Fire(view_event.POOL_ASKS_UPDATE)
	end

	function self:hide_all()
		local active = self.active
		for idx = len(active), 1, -1 do
			local curr = active[idx]
			table.remove(active, idx)
			append(self.hidden, curr)
			curr.Hide()
		end
	end

	function self:expand()
		local count = self.item_count
		if count == 0 then
			count = 1
		end
		for idx = 1, count do
			local parent = self.frame
			local new = view.NewListItem(parent, get_entry)
			append(self.hidden, new)
			new.Hide()
		end
		self.item_count = self.item_count + count
	end

	function self:show(count)
		if count < 1 then
			return
		end
		
		local hidden = self.hidden
		for idx = 1, count do
			local last_idx = len(hidden)
			local curr = hidden[last_idx]
			table.remove(hidden, last_idx)
			append(self.active, curr)
			curr.Show(idx)
		end
	end

	return self
end
