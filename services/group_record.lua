function blame.NewGroupRecord(model)
	local self = {}

	local function new_group(record)
		return {
			guid = record.guid,
			last_time = record.time,
			count = 1,
		}
	end

	local function append_group(group, record)
		group.last_time = record.time
		group.count = group.count + 1
		return group
	end

	local function group_record(idx)
		local record = model.aggro_records[idx]
		if len(model.record_groups) == 0 then
			append(model.record_groups, new_group(record))
			api.Fire(svc_event.GROUP_UPDATED, 1)
		end
		
		local idx = len(model.record_groups)
		local group = model.record_groups[idx]
		if group.guid == record.guid then
			group = append_group(group, record)
			model.record_groups[idx] = group
			api.Fire(svc_event.GROUP_UPDATED, idx)
		else
			group = new_group(record)
			append(model.record_groups, group)
			local idx = len(model.record_groups)
			api.Fire(svc_event.GROUP_UPDATED, idx)
		end
	end

	api.Subscribe(svc_event.RECORD_ADDED, group_record)

	return self
end