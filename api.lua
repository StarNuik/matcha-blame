-- Namespace
api = {
	on_update = {},
	on_event = {},
	bus = blame.new_event_bus(),
}

api_event = {
	UPDATE = "WOW_UPDATE",
	UNIT_AURA = "UNIT_AURA",
	UNIT_FLAGS = "UNIT_FLAGS",
	UNIT_HEALTH = "UNIT_HEALTH",
	UNIT_COMBAT = "UNIT_COMBAT",
	UNIT_FACTION = "UNIT_FACTION",
	UNIT_CASTEVENT = "UNIT_CASTEVENT",
	UNIT_HAPPINESS = "UNIT_HAPPINESS",
	UNIT_MODEL_CHANGED = "UNIT_MODEL_CHANGED",
	UNIT_PORTRAIT_UPDATE = "UNIT_PORTRAIT_UPDATE",
	PLAYER_TARGET_CHANGED = "PLAYER_TARGET_CHANGED",
	UPDATE_MOUSEOVER_UNIT = "UPDATE_MOUSEOVER_UNIT",
}

local function handle_event()
	api.bus.Fire(event, arg1)
end

local function init_frame()
	local f = CreateFrame("Frame")
	
	f:SetScript("OnUpdate", function() api.bus.Fire(api_event.UPDATE) end)
	f:SetScript("OnEvent", function() handle_event() end)

	register = {
		api_event.UNIT_AURA,
		api_event.UNIT_FLAGS,
		api_event.UNIT_HEALTH,
		api_event.UNIT_COMBAT,
		api_event.UNIT_FACTION,
		api_event.UNIT_CASTEVENT,
		api_event.UNIT_HAPPINESS,
		api_event.UNIT_MODEL_CHANGED,
		api_event.UNIT_PORTRAIT_UPDATE,
		api_event.PLAYER_TARGET_CHANGED,
		api_event.UPDATE_MOUSEOVER_UNIT,
	}

	for _, e in ipairs(register) do
		f:RegisterEvent(e)
	end
end

init_frame()

function api.Subscribe(key, listener)
	api.bus.Subscribe(key, listener)
end

function api.Fire(key, ...)
	api.bus.Fire(key, unpack(arg))
end

function api.GetMobTarget(unit_id)
	local exists, guid = UnitExists(unit_id .. "target")
	if not exists then
		return nil
	end
	if api.IsEnemyMob(guid) then
		return nil
	end
	return guid
end

function api.IsEnemyMob(unit_id)
	return api.as_bool(UnitExists(unit_id)
		and not UnitIsDead(unit_id)
		and not UnitIsPlayer(unit_id)
		and UnitCanAttack(unit_id, "player")
	)
end

function api.UnitGuid(unit_id)
	local _, guid = UnitExists(unit_id)
	return guid
end

function api.UnitName(unit_id)
	local name, _ = UnitName(unit_id)
	return name
end

function api.IsUnitVisible(unit_id)
	return api.as_bool(UnitIsVisible(unit_id))
end

function api.IsInCombat(unit_id)
	return api.as_bool(UnitAffectingCombat(unit_id)
		and not UnitIsDead(unit_id)
	)
end

function api.as_bool(value)
	if value then
		return true
	else
		return false
	end
end
