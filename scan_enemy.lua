-- Prototype
local scan_enemy = {}

local function scan_enemy_ctor(self)
	self.guids = {}

	api:OnUpdate(function() self:update() end)

	local add_arg1 = function() self:add(arg1) end
	local add_target = function() self:add("target") end
	local add_mouseover = function() self:add("mouseover") end
	api:OnEvent("UNIT_AURA", add_arg1)
	api:OnEvent("UNIT_FLAGS", add_arg1)
	api:OnEvent("UNIT_HEALTH", add_arg1)
	api:OnEvent("UNIT_COMBAT", add_arg1)
	api:OnEvent("UNIT_FACTION", add_arg1)
	api:OnEvent("UNIT_CASTEVENT", add_arg1)
	api:OnEvent("UNIT_HAPPINESS", add_arg1)
	api:OnEvent("UNIT_MODEL_CHANGED", add_arg1)
	api:OnEvent("UNIT_PORTRAIT_UPDATE", add_arg1)
	api:OnEvent("PLAYER_TARGET_CHANGED", add_target)
	api:OnEvent("UPDATE_MOUSEOVER_UNIT", add_mouseover)

	return self
end

function blame.NewScanEnemy()
	return blame.new(scan_enemy, scan_enemy_ctor)
end

function scan_enemy:All()
	return self.guids
end

function scan_enemy:add(unit_id)
	if not api:IsEnemyMob(unit_id) then
		return
	end
	local guid = api:UnitGuid(unit_id)
	self.guids[guid] = true
end

function scan_enemy:update()
	local set = self.guids
	for guid in pairs(set) do
		if not api:IsUnitVisible(guid) then
			set[guid] = nil
		end
	end
end



