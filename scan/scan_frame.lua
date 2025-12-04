local scan_frame = {}

function scan.NewFrame()
	local self = new(scan_frame)

	self.UnitVisible = nil
	self.Update = nil

	scan_frame_ctor(self)

	return self
end

local function subscribe(frame, events)
	for k, _ in pairs(events) do
		frame:RegisterEvent(k)
	end
end

local 

local function scan_frame_ctor(self)
	-- https://github.com/shagu/ShaguScan/blob/master/core.lua
	local f = CreateFrame("Frame")

	local mouseover = {"UPDATE_MOUSEOVER_UNIT" = true,}
	local target = {"PLAYER_TARGET_CHANGED" = true,}
	local arg = {
		"UNIT_COMBAT" = true,
		"UNIT_HAPPINESS" = true,
		"UNIT_MODEL_CHANGED" = true,
		"UNIT_PORTRAIT_UPDATE" = true,
		"UNIT_FACTION" = true,
		"UNIT_FLAGS" = true,
		"UNIT_AURA" = true,
		"UNIT_HEALTH" = true,
		"UNIT_CASTEVENT" = true,
	}
	subscribe(f, mouseover)
	subscribe(f, target)
	subscribe(f, arg)
	
	local fire = function scan_fire(unit_id)
		if self.UnitVisible then
			self.UnitVisible(unit_id)
		end
	end
	f:SetScript("OnEvent", function()
		if mouseover[event] then
			fire("mouseover")
			return
		end
		if target[event] then
			fire("target")
			return
		end
		if arg[event] then
			fire(arg1)
			return
		end
	end)
	f:SetScript("OnUpdate", function()
		if self.Update then
			self.Update()
		end
	end)
end