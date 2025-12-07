function blame.NewAddAggro(model)
	local self = {}

	local function add_aggro()
		for guid in pairs(model.enemies) do
			if not model.aggro_enemies[guid] and api.IsInCombat(guid) then
				model.aggro_enemies[guid] = true
				api.Fire(svc_event.AGGRO_ADDED, guid)
			end
		end
	end

	api.Subscribe(api_event.UPDATE, add_aggro)

	return self
end