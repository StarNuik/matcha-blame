-- Namespace
api = {}

function api.IsEnemyMob(unit_id)
	return UnitExists(unit_id)
		and not UnitIsFriend(unit_id, "player")
		and not UnitIsPlayer(unit_id)
		and not UnitIsDead(unit_id)
end

function api.UnitGuid(unit_id)
	_, guid = UnitExists(unit_id)
	return guid
end

function api.IsUnitVisible(unit_id)
	if UnitIsVisible(unit_id) then
		return true
	else
		return false
	end
end
