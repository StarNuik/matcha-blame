-- Namespace
api = {
	on_update = {},
	on_event = {},
}

function api:IsEnemyMob(unit_id)
	return api:as_bool(UnitExists(unit_id)
		and not UnitIsDead(unit_id)
		and not UnitIsPlayer(unit_id)
		and UnitCanAttack(unit_id, "player")
	)
end

function api:UnitGuid(unit_id)
	_, guid = UnitExists(unit_id)
	return guid
end

function api:IsUnitVisible(unit_id)
	return api:as_bool(UnitIsVisible(unit_id))
end

function api:IsInCombat(unit_id)
	return api:as_bool(UnitAffectingCombat(unit_id)
		and not UnitIsDead(unit_id)
	)
end

function api:OnUpdate(callback)
	table.insert(self.on_update, callback)
end

function api:OnEvent(event_key, callback)
	if not self.on_event[event_key] then
		self.on_event[event_key] = {}
	end
	table.insert(self.on_event[event_key], callback)

	local f = self:get_frame()
	f:RegisterEvent(event_key)
end

function api:as_bool(value)
	if value then
		return true
	else
		return false
	end
end

function api:get_frame()
	if self.frame then
		return self.frame
	end
	
	local f = CreateFrame("Frame")
	
	f:SetScript("OnUpdate", function() self:handle_update() end)
	f:SetScript("OnEvent", function() self:handle_event() end)
	
	self.frame = f
	return f
end

function api:handle_update()
	for _, callback in ipairs(self.on_update) do
		callback()
	end
end

function api:handle_event()
	if not self.on_event[event] then
		return
	end
	local list = self.on_event[event]
	for _, callback in ipairs(list) do
		callback()
	end
end