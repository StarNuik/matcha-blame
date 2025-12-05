-- Import
local view = blame.view
-- Prototype
local pool = {}

local function len(list)
	return table.getn(list)
end

function view.NewPool(parent)
	return blame.new2(pool, parent)
end

function pool:ctor(parent)
	self.Changed = blame.new_event()
	self.active = {}
	self.hidden = {}
	self.item_count = 0

	self.frame = parent
	return self
end

function pool:Resize(target_count)
	if target_count == len(self.active) then
		return
	end

	self:hide_all()
	while self.item_count < target_count do
		self:expand()
	end
	self:show(target_count)

	self.Changed.Fire()
end

function pool:AllActive()
	return self.active
end

function pool:hide_all()
	local active = self.active
	for idx = len(active), 1, -1 do
		local curr = active[idx]
		table.remove(active, idx)
		table.insert(self.hidden, curr)
		curr:Hide()
	end
end

function pool:show(count)
	local hidden = self.hidden
	for idx = 1, count do
		local last_idx = len(hidden)
		local curr = hidden[last_idx]
		table.remove(hidden, last_idx)
		table.insert(self.active, curr)
		curr:Show()
	end
end

function pool:expand()
	local count = self.item_count
	if count == 0 then
		count = 1
	end
	for idx = 1, count do
		local parent = self.frame
		local new = view.NewListItem(parent)
		table.insert(self.hidden, new)
		new:Hide()
	end
	self.item_count = self.item_count + count
end