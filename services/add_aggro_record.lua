function blame.NewAddAggroRecord(model)
	local self = {}

	local function new_record(guid)
		return {
			guid = guid,
			time = time(),
		}
	end

	local function add_aggro_record(guid)
		local target_guid = api.GetMobTarget(guid)
		if not target_guid then
			return
		end

		local record = new_record(target_guid)
		append(model.aggro_records, record)
		api.Fire(RECORD_ADDED)
	end

	api.Subscribe(svc_event.AGGRO_ADDED, add_aggro_record)

	return self
end
