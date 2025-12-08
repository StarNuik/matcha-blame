local class_colors = {
	DRUID = "ffFF7C0A",
	HUNTER = "ffAAD372",
	MAGE = "ff3FC7EB",
	PALADIN = "ffF48CBA",
	PRIEST = "ffFFFFFF",
	ROGUE = "ffFFF468",
	SHAMAN = "ff0070DD",
	WARLOCK = "ff8788EE",
	WARRIOR = "ffC69B6D",
	PET = "ff999999",
	NPC = "ff999999",
	ENEMY = "ffC41E3A",
}



function blame.NewSetEntries(model)
	local private = {}

	api.Subscribe(svc_event.GROUP_UPDATED, function(unit_id) private.update_entries(unit_id) end)
	api.Subscribe(svc_event.MODEL_CHANGED, function(unit_id) private.update_entries(unit_id) end)

	function private.update_entries(unit_id)
		model.entries = {}

		local dest = model.entries
		local groups = model.record_groups
		
		local limit = math.max(1, len(groups) - model.list_limit + 1) 

		for idx = len(groups), limit, -1 do
			local group = groups[idx]
			local text = private.group_to_string(group)
			append(dest, text)
		end

		api.Fire(view_event.MODEL_ENTRIES_CHANGED, len(dest))
		-- api.Fire(view_event.MODEL_CHANGED)
	end

	function private.group_to_string(group)
		local guid = group.guid
		local cache = model.units_cache[guid]
		if cache then
			return private.format(group.count, cache.name, cache.class, group.last_time) 
		else
			return private.format(group.count, nil, nil, group.last_time)
		end
	end

	function private.format(count, name, class, time)
		local name = name or "Unknown"
		local class = class or api_class.NPC
		local time = private.time_str(time)

		local name_color = class_colors[class]
		name = private.cut_name(name)
		name = private.wrap_text_with_color(name, name_color)
		return string.format("%3d | %-24s | %s", count, name, time)
	end

	function private.cut_name(name)
		return string.sub(name, 1, 12)
	end

	function private.time_str(time)
		local now = _G.time()
		local delta = now - time
		if delta <= 60 then
			-- return delta .. "s"
			return "<1m"
		end
		if delta <= 60 * 60 then
			return floor(delta / 60) .. "m"
		end
		if delta <= 60 * 60 * 24 then
			return floor(delta / 60 / 60) .. "h"
		end
		return ">1d"
	end

	function private.wrap_text_with_color(text, hex_string)
		return string.format("|c%s%s|r", hex_string, text)
	end

	return self
end