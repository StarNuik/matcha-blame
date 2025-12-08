function blame.NewModel(saved)
	local self = {
		show = true,
		list_limit = saved.list_limit,

		entries = {}, -- list
		units = {},
		enemies = {},
		aggro_enemies = {},
		aggro_records = {},	 -- list
		record_groups = {},
		units_cache = {},
		pending_cache = {}
	}

	function self.GetEntry(idx)
		return self.entries[idx]
	end

	function self.Clear()
		self.entries = {}
		self.units = {}
		self.enemies = {}
		self.aggro_enemies = {}
		self.aggro_records = {}
		self.record_groups = {}
		-- don't clear units cache
		self.pending_cache = {}
	end

	function self.NewRecord(guid, time)
		return { guid = guid, time = time, }
	end

	function self.NewGroup(record)
		return {
			guid = record.guid,
			last_time = record.time,
			count = 1,
		}
	end

	function self.UpdateGroup(group, record)
		group.last_time = record.time
		group.count = group.count + 1
		return group
	end

	function self.NewUnitCache(name, class)
		return { name = name, class = class, }
	end

	return self
end