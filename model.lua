local model = {}

function blame:NewModel()
	local self = new(model)
	self.entries = {}
	return self
end

function blame:NewModelEntry(count, name, desc, class)
	name = name or "UNKNOWN"
	name = string.sub(name, 1, 12)

	count = math.min(count or 0, 999)
	desc = desc or ""
	class = class or "PRIEST"

	return {
		count = count,
		name = name,
		description = desc,
		class = class
	}
end

function model:Clear()
	self.entries = {}
end

function model:Set(idx, entry)
	if not idx or not entry then
		return
	end

	self.entries[idx] = entry
end

function model:Count()
	return table.getn(self.entries)
end

function model:Get(idx)
	return self.entries[idx]
end

function model:All()
	return self.entries
end