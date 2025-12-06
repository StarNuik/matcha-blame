function blame.NewUnitToEntry(model)
	local self = {}

	api.Subscribe(svc_event.UNIT_ADDED, function(unit_id)
		model.entries = {}
		for guid in pairs(model.units) do
			local name = api.UnitName(guid)
			model.entries = append(model.entries, name)
		end
		api.Fire(view_event.EXTERNAL_UPDATE)
	end)

	return self
end