-- Prototype
local model = {}

function blame.NewModel()
	return blame.new2(model)
end

function model:ctor()
	self.hide_all = false
	self.hide_list = false
	self.entries = {}
	self.collapsed = false
	self.Changed = blame.new_event()
	return self
end

function model:ClearEntries()
	self.entries = {}
end

function model:PushEntry(text)
	table.insert(self.entries, text)
end

function model:FireChanged()
	self.Changed.Fire()
end

-- function blame.NewModelEntry(count, name, time, class)
-- 	name = name or "UNKNOWN"
-- 	name = string.sub(name, 1, 12)

-- 	count = math.min(count or 0, 999)
-- 	time = time or _G.time()
-- 	class = class or "PRIEST"

-- 	return {
-- 		count = count,
-- 		name = name,
-- 		time = time,
-- 		class = class
-- 	}
-- end

-- function model:Clear()
-- 	self.entries = {}
-- end

-- function model:Set(idx, entry)
-- 	if not idx or not entry then
-- 		return
-- 	end

-- 	self.entries[idx] = entry
-- end

-- function model:Count()
-- 	return table.getn(self.entries)
-- end

-- function model:Get(idx)
-- 	return self.entries[idx]
-- end

-- function model:All()
-- 	return self.entries
-- end