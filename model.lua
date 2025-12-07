function blame.NewModel()
	local self = {
		hide_list = false,
		entries = {},
		units = {},
	}

	function self.GetEntry(idx)
		return self.entries[idx]
	end

	return self
end