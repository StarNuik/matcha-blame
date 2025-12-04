-- Prototype
local scan_enemy = {}

function scan_enemy:All()
	return self.guids
end

local function scan_frame(add, update)
	-- https://github.com/shagu/ShaguScan/blob/master/core.lua
	local f = CreateFrame("Frame")

	local mouseover = {["UPDATE_MOUSEOVER_UNIT"] = true,}
	local target = {["PLAYER_TARGET_CHANGED"] = true,}
	local arg = {
		["UNIT_COMBAT"] = true,
		["UNIT_HAPPINESS"] = true,
		["UNIT_MODEL_CHANGED"] = true,
		["UNIT_PORTRAIT_UPDATE"] = true,
		["UNIT_FACTION"] = true,
		["UNIT_FLAGS"] = true,
		["UNIT_AURA"] = true,
		["UNIT_HEALTH"] = true,
		["UNIT_CASTEVENT"] = true,
	}
	local subscribe = function(f, events)
		for k, _ in pairs(events) do
			f:RegisterEvent(k)
		end
	end
	subscribe(f, mouseover)
	subscribe(f, target)
	subscribe(f, arg)
	
	f:SetScript("OnEvent", function()
		if mouseover[event] then
			add("mouseover")
			return
		end
		if target[event] then
			add("target")
			return
		end
		if arg[event] then
			add(arg1)
			return
		end
	end)
	f:SetScript("OnUpdate", update)
	return f
end

local function scan_enemy_add(self, unit_id)
	if not api.IsEnemyMob(unit_id) then
		return
	end
	local guid = api.UnitGuid(unit_id)
	self.guids[guid] = true
end

local function scan_enemy_update(self)
	local set = self.guids
	for guid in pairs(set) do
		if not api.IsUnitVisible(guid) then
			set[guid] = nil
		end
	end
end

local function scan_enemy_ctor(self)
	self.guids = {}

	local scan = scan_frame(
		function(unit_id) scan_enemy_add(self, unit_id) end,
		function() scan_enemy_update(self) end
	)
	return self
end

function blame.NewScanEnemy()
	return blame.new(scan_enemy, scan_enemy_ctor)
end