function blame.NewModel()
	local self = {
		show = true,
		entries = {}, -- list
		units = {},
		enemies = {},
		aggro_enemies = {},
		aggro_records = {},	 -- list
		record_groups = {},
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
	end

	return self
end