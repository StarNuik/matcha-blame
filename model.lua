blame.model = {}
blame.SetEnv(blame.model)

function ModelEntry(count, name, desc, class)
	props.name = props.name or "UNKNOWN"
	props.name = string.sub(props.name, 1, 12)

	props.count = math.min(props.count or 0, 999)
	props.description = props.description or ""
	props.class = props.class or "PRIEST"

	return {
		count = count,
		name = name,
		description = desc,
		class = class
	}
end

local entries = {}

function Clear()
	entries = {}
end

function Set(idx, entry)
	if not idx or not entry then
		return
	end

	entries[idx] = entry
end

function Count()
	return table.getn(entries)
end

function Get(idx)
	return entries[idx]
end

function All()
	return entries
end