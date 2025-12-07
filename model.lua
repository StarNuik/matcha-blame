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

	return self
end