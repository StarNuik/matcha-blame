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
		
		local records_len = len(model.aggro_records)
		api.Fire(svc_event.RECORD_ADDED, records_len)
	end

	api.Subscribe(svc_event.AGGRO_ADDED, add_aggro_record)

	return self
end
