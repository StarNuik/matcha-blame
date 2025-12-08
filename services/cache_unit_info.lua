function blame.NewCacheUnitInfo(model)
	
	local function add_unit_cache(unit_id)
		local guid = api.UnitGuid(unit_id)
		if not api.CanCache(guid) then
			model.pending_cache[guid] = true
			return
		end

		local name = api.UnitName(guid)
		local class = api.UnitClass(guid)
		local cache_record = model.NewUnitCache(name, class)
		model.units_cache[guid] = cache_record

		api.Fire(svc_event.UNIT_CACHE_ADDED, guid)
	end
	
	api.Subscribe(svc_event.RECORD_ADDED, function(idx)
		local guid = model.aggro_records[idx].guid
		
		add_unit_cache(guid)
		-- if cache and cache.class == api_class.PET then
		-- 	local _, owner_guid = add_unit_cache(guid .. "owner")
		-- 	api.Fire(svc_event.UNIT_CACHE_ADDED, owner_guid)
		-- end
	end)

	api.Subscribe(svc_event.UNIT_ADDED, function(guid)
		if not model.pending_cache[guid] then
			return
		end
		
		add_unit_cache(guid)
		model.pending_cache[guid] = nil
	end)

	return {}
end