function blame.NewAddAggroRecord(model)

	local function add_aggro_record(guid)
		local target_guid = api.GetMobTarget(guid)
		if not target_guid then
			return
		end

		local record = model.NewRecord(target_guid, time())
		append(model.aggro_records, record)
		
		local idx_last = len(model.aggro_records)
		api.Fire(svc_event.RECORD_ADDED, idx_last)
	end

	api.Subscribe(svc_event.AGGRO_ADDED, add_aggro_record)

	return {}
end
