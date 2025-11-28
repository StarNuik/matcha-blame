blame.visible_units = {}
blame.SetEnv(blame.visible_units)

local units = {}


local function Remove(guid)
	table.delete(units, guid)
end

local function Add(unit_id)
	local exists, guid = UnitExists(unit_id)
	if not guid then
		print("no guid: " .. tostring(unit_id) .. ", " .. tostring(guid))
		return
	end

	if not exists then
		Remove(guid)
	end

	units[guid] = true
end

function Init()
	-- https://github.com/shagu/ShaguScan/blob/master/core.lua
	local f = CreateFrame("Frame")
	
	f:SetScript("OnEvent", function() Add(arg1) end)
	
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


function Get()
	return units
end

local function ShouldPurge(guid)
	return not UnitIsVisible(guid)
end

function Update()
	for guid, _ in pairs(units) do
		if ShouldPurge(guid) then
			Remove(guid)
		end
	end
end
