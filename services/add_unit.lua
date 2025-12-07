function blame.NewAddUnit(model)
	local self = {}

	local function add_arg(unit_id)
		local guid = api.UnitGuid(unit_id)
		if not guid then
			return
		end
		model.units[guid] = true
		api.Fire(svc_event.UNIT_ADDED, guid)
	end

	api.Subscribe(
		api_event.PLAYER_TARGET_CHANGED,
		function() add_arg("target") end
	)
	api.Subscribe(
		api_event.UPDATE_MOUSEOVER_UNIT,
		function() add_arg("mouseover") end
	)

	local arg_events = {
		api_event.UNIT_AURA,
		api_event.UNIT_FLAGS,
		api_event.UNIT_HEALTH,
		api_event.UNIT_COMBAT,
		api_event.UNIT_FACTION,
		api_event.UNIT_CASTEVENT,
		api_event.UNIT_HAPPINESS,
		api_event.UNIT_MODEL_CHANGED,
		api_event.UNIT_PORTRAIT_UPDATE,
	}
	for _, e in ipairs(arg_events) do
		api.Subscribe(e, add_arg)
	end

	return self
end