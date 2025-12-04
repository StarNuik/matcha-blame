aggro = {} -- prototype

local function aggro_entry(count, time)
	return {
		count = count,
		time = time,
	}
end

function blame:NewUnitsAggro(units)
	local self = new(aggro)
	self.entries = {}
	self.chilling = {}
	self.units = units
	return self
end

local function should_track(guid)
	return UnitCanAttack("player", guid) and not UnitIsDead(guid)
end

function aggro:UpdateSingle(guid)
	if not should_track(guid) then
		return
	end

	local target_exists, target_guid = UnitExists(guid .. "target")
	if not target_exists then
		self.chilling[guid] = true
	end
	if target_exists and self.chilling[guid] then
		local curr = self.entries[target_guid]
		curr = curr or aggro_entry(0, 0)
		curr = aggro_entry(curr.count + 1, time())
		self.entries[target_guid] = curr
		self.chilling[guid] = nil
	end
end

function aggro:Update()
	for guid, _ in pairs(self.units:All()) do
		self:UpdateSingle(guid)
	end
end

function aggro:Get()
	return self.entries
end

function aggro:Clear()
	self.entries = {}
	self.chilling = {}
end


