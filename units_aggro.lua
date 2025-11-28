local units = blame.visible_units

blame.units_aggro = {}
blame.SetEnv(blame.units_aggro)

local count = {}
local chilling = {}

local function ShouldTrackAggro(guid)
	return UnitIsEnemy("player", guid)
end


local function UpdateSingle(guid)
	if not ShouldTrackAggro(guid) then
		return
	end

	local target_exists, target_guid = UnitExists(guid .. "target")
	if not target_exists then
		chilling[guid] = true
	end
	if target_exists and chilling[guid] then
		count[target_guid] = count[target_guid] + 1
		_G.table.delete(chilling, guid)
	end
end

function Update()
	for guid, _ in pairs(units.Get()) do
		UpdateSingle(guid)
	end
end

function Get()
	return count
end

function Clear()
	count = {}
	chilling = {}
end


