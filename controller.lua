local model = blame.model
local units = blame.visible_units
local aggro = blame.units_aggro

blame.controller = {}
blame.SetEnv(blame.controller)

TICK_SECONDS = 0.1

local until_tick = 0
local tick = 0

local function UnitProps(guid, aggro_count)
	local name = UnitName(guid)
	local level = UnitLevel(guid)
	local _, class = UnitClass(guid)
	if not UnitIsFriend(guid, "player") then
		class = "ENEMY"
	elseif not UnitPlayerControlled(guid) then
		class = "MOB"
	end
	return model.ModelEntry(aggro_count, name, nil, class)
end

local function Tick()
	model.Clear()
	units.Update()
	aggro.Update()
	local idx = 1
	for guid, val in pairs(aggro.Get()) do
		model.Set(idx, UnitProps(guid, val))
		idx = idx + 1
	end
end

local function Update()
	until_tick = until_tick - arg1
	if until_tick <= 0 then
		tick = tick + 1
		until_tick = until_tick + TICK_SECONDS
		Tick()
	end
end

function Init()
	local f = CreateFrame("Frame")

	f:SetScript("OnUpdate", function() Update() end)

	print("Blame loaded")
end

