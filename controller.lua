local model = blame.model
local units = blame.visible_units
local aggro = blame.units_aggro

local controller = {} -- prototype

function blame:NewController(model, units, aggro)
	local self = new(controller)
	
	self.model = model
	self.units = units
	self.aggro = aggro

	self:Init()
	return self
end

local function unit_props(guid, aggro_count, time)
	local name = UnitName(guid)
	local level = UnitLevel(guid)
	local _, class = UnitClass(guid)
	if not UnitPlayerControlled(guid) and not UnitIsFriend(guid, "player") then
		class = "ENEMY"
	end
	if not UnitIsVisible(guid) or UnitIsFriend(guid, "player") and not UnitPlayerControlled(guid)  then
		class = "NPC"
	end
	return blame:NewModelEntry(aggro_count, name, time, class)
end

function controller:Update()
	self.model:Clear()
	-- self.aggro:Update()
	local idx = 1
	for guid, _ in pairs(self.units:All()) do
		self.model:Set(idx, unit_props(guid, nil, nil))
		idx = idx + 1
	end
	sort(self.model:All(), function(lhs, rhs) return lhs.time > rhs.time end)
end

function controller:Init()
	local f = CreateFrame("Frame")

	f:SetScript("OnUpdate", function() self:Update() end)
end

