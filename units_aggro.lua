aggro = {} -- prototype

function blame:NewUnitsAggro(units)
	local self = new(aggro)
	self.count = {}
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
		local curr = self.count[target_guid] or 0
		self.count[target_guid] = curr + 1
		self.chilling[guid] = nil
	end
end

function aggro:Update()
	for guid, _ in pairs(self.units:Get()) do
		self:UpdateSingle(guid)
	end
end

function aggro:Get()
	return self.count
end

function aggro:Clear()
	self.count = {}
	self.chilling = {}
end


