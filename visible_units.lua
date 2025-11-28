local units = {} -- prototype

function blame:NewVisibleUnits()
	local self = new(units)
	units.set = {}

	units:Init()
	
	return units
end

function subscribe(frame, events)
	for _, e in ipairs(events) do
		frame:RegisterEvent(e)
	end
end

function list_contains(list, query)
	for _, val in ipairs(list) do
		if val == query then
			return true
		end
	end
	return false
end

function units:Init()
	-- https://github.com/shagu/ShaguScan/blob/master/core.lua
	local f = CreateFrame("Frame")

	local mouseover = {"UPDATE_MOUSEOVER_UNIT"}
	local target = {"PLAYER_TARGET_CHANGED"}
	local arg = {
		"UNIT_COMBAT",
		"UNIT_HAPPINESS",
		"UNIT_MODEL_CHANGED",
		"UNIT_PORTRAIT_UPDATE",
		"UNIT_FACTION",
		"UNIT_FLAGS",
		"UNIT_AURA",
		"UNIT_HEALTH",
		"UNIT_CASTEVENT",
	}
	subscribe(f, mouseover)
	subscribe(f, target)
	subscribe(f, arg)
	
	f:SetScript("OnEvent", function()
		if list_contains(mouseover, event) then
			self:Add("mouseover")
		end
		if list_contains(target, event) then
			self:Add("target")
		end
		if list_contains(arg, event) then
			self:Add(arg1)
		end
	end)
end

function units:Remove(guid)
	self.set[guid] = nil
end

function units:Add(unit_id)
	if not unit_id then
		return
	end

	-- print(unit_id)
	local exists, guid = UnitExists(unit_id)
	if not guid then
		-- print("no guid: " .. tostring(unit_id) .. ", " .. tostring(guid))
		return
	end

	if not exists then
		self:Remove(guid)
		return
	end

	self.set[guid] = true
end

function units:Get()
	return units.set
end

local function should_purge(guid)
	return not UnitIsVisible(guid)
end

function units:Update()
	for guid, _ in pairs(self.set) do
		if should_purge(guid) then
			self:Remove(guid)
		end
	end
end
