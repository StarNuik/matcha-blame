local model = blame.model
local units = blame.visible_units
local aggro = blame.units_aggro

local controller = {} -- prototype

function blame:NewController(model, units, aggro)
	local self = new(controller)
	
	self.until_tick = 0
	self.tick = 0

	self.model = model
	self.units = units
	self.aggro = aggro

	self:Init()
	return self
end

local TICK_SECONDS = 0.1

local function unit_props(guid, aggro_count)
	local name = UnitName(guid)
	local level = UnitLevel(guid)
	local _, class = UnitClass(guid)
	if not UnitIsFriend(guid, "player") then
		class = "ENEMY"
	elseif not UnitPlayerControlled(guid) then
		class = "MOB"
	end
	return blame:NewModelEntry(aggro_count, name, nil, class)
end

function controller:Tick()
	self.model:Clear()
	self.units:Update()
	self.aggro:Update()
	local idx = 1
	for guid, val in pairs(self.units:Get()) do
		self.model:Set(idx, unit_props(guid, 0))
		idx = idx + 1
	end
end

function controller:Update()
	self.until_tick = self.until_tick - arg1
	if self.until_tick <= 0 then
		self.tick = self.tick + 1
		self.until_tick = self.until_tick + TICK_SECONDS
		self:Tick()
	end
end

function controller:Init()
	local f = CreateFrame("Frame")

	f:SetScript("OnUpdate", function() self:Update() end)
end

