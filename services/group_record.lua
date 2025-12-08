function blame.NewGroupRecord(model)
	local function group_record(idx)
		local record = model.aggro_records[idx]
		if len(model.record_groups) == 0 then
			append(model.record_groups, model.NewGroup(record))
			api.Fire(svc_event.GROUP_UPDATED, 1)
			return
		end
		
		local idx = len(model.record_groups)
		local group = model.record_groups[idx]
		if group.guid == record.guid then
			group = model.UpdateGroup(group, record)
			model.record_groups[idx] = group
			api.Fire(svc_event.GROUP_UPDATED, idx)
		else
			group = model.NewGroup(record)
			append(model.record_groups, group)
			local idx = len(model.record_groups)
			api.Fire(svc_event.GROUP_UPDATED, idx)
		end
	end

	api.Subscribe(svc_event.RECORD_ADDED, group_record)

	return {}
end