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
	ADDON_LOADED = "ADDON_LOADED",
}

api_class = {
	DRUID = "DRUID",
	HUNTER = "HUNTER",
	MAGE = "MAGE",
	PALADIN = "PALADIN",
	PRIEST = "PRIEST",
	ROGUE = "ROGUE",
	SHAMAN = "SHAMAN",
	WARLOCK = "WARLOCK",
	WARRIOR = "WARRIOR",
	PET = "PET",
	NPC = "NPC",
	ENEMY = "ENEMY",
}

local function handle_event()
	api.bus.Fire(event, arg1)
end

local function init_frame()
	local f = CreateFrame("Frame")
	
	f:SetScript("OnUpdate", function() api.bus.Fire(api_event.UPDATE) end)
	f:SetScript("OnEvent", function() handle_event() end)

	for k, v in pairs(api_event) do
		if k == "UPDATE" then
			-- continue
		else
			f:RegisterEvent(v)
		end
	end
end

init_frame()

function api.Subscribe(key, listener)
	api.bus.Subscribe(key, listener)
end

function api.Fire(key, ...)
	api.bus.Fire(key, unpack(arg))
end

function api.UnitClass(unit_id)
	if api.IsNpc(unit_id) then
		return api_class.NPC
	end
	if api.IsPet(unit_id) then
		if api.IsDemon(unit_id) then
			return api_class.WARLOCK
		else
			return api_class.HUNTER
		end
	end
	if api.IsEnemy(unit_id) then
		return api_class.ENEMY
	end
	_, class = UnitClass(unit_id)
	return api_class[class]
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

function api.CanCache(unit_id)
	return api.as_bool(UnitName(unit_id) ~= "Unknown")
end

function api.IsPet(unit_id) -- procs on Mind Control? oh well...
	return api.as_bool(not UnitIsPlayer(unit_id) and UnitPlayerControlled(unit_id))
end

function api.IsDemon(unit_id)
	return UnitCreatureType(unit_id) == "Demon"
end

function api.IsNpc(unit_id)
	return api.as_bool(not UnitIsPlayer(unit_id) and not UnitPlayerControlled(unit_id))
end

function api.IsEnemy(unit_id)
	return api.as_bool(UnitCanAttack(unit_id, "player"))
end

function api.IsEnemyMob(unit_id)
	return api.IsEnemy(unit_id) and api.IsNpc(unit_id)
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
