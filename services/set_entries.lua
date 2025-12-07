function blame.NewSetEntries(model)
	local self = {}

	local function group_to_string(group)
		local name = api.UnitName(group.guid)
		return tostring(group.count) .. " " .. name
	end

	api.Subscribe(svc_event.GROUP_UPDATED, function(unit_id)
		model.entries = {}

		local dest = model.entries
		local groups = model.record_groups

		for idx = len(groups), 1, -1 do
			local group = groups[idx]
			local text = group_to_string(group)
			append(dest, text)
		end

		api.Fire(view_event.MODEL_ENTRIES_CHANGED, len(dest))
		-- api.Fire(view_event.MODEL_CHANGED)
	end)

	return self
end