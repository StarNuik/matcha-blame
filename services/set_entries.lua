function blame.NewSetEntries(model)
	local self = {}

	api.Subscribe(svc_event.UNIT_ADDED, function(unit_id)
		model.entries = {}

		local dest = model.entries
		local records = model.aggro_records

		for idx = len(records), 1, -1 do
			local record = records[idx]
			local name = api.UnitName(record.guid)
			append(dest, name)
		end

		api.Fire(view_event.MODEL_CHANGED, len(dest))
	end)

	return self
end