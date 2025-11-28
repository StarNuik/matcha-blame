local units = {} -- prototype

function blame:NewVisibleUnits()
	local self = new(units)
	units.set = {}

	units:Init()
	
	return units
end

function units:Init()
	-- https://github.com/shagu/ShaguScan/blob/master/core.lua
	local f = CreateFrame("Frame")
	
	f:SetScript("OnEvent", function() self:Add(arg1) end)
	
	-- unitstr
	-- f:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	-- f:RegisterEvent("PLAYER_TARGET_CHANGED")
	-- f:RegisterEvent("PLAYER_ENTERING_WORLD")
	
	-- arg1
	f:RegisterEvent("UNIT_COMBAT")
	f:RegisterEvent("UNIT_HAPPINESS")
	f:RegisterEvent("UNIT_MODEL_CHANGED")
	f:RegisterEvent("UNIT_PORTRAIT_UPDATE")
	f:RegisterEvent("UNIT_FACTION")
	f:RegisterEvent("UNIT_FLAGS")
	f:RegisterEvent("UNIT_AURA")
	f:RegisterEvent("UNIT_HEALTH")
	f:RegisterEvent("UNIT_CASTEVENT")
end

function units:Remove(guid)
	self.set[guid] = nil
end

function units:Add(unit_id)
	-- print(unit_id)
	local exists, guid = UnitExists(unit_id)
	if not guid then
		print("no guid: " .. tostring(unit_id) .. ", " .. tostring(guid))
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
