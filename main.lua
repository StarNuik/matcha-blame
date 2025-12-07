local self = blame

local model = blame.NewModel()

local view = blame.view.New(model)

local uadd = blame.NewAddUnit(model)
local eadd = blame.NewAddEnemy(model)
local aadd = blame.NewAddAggro(model)
local radd = blame.NewAddAggroRecord(model)
local rgroup = blame.NewGroupRecord(model)

local set_entries = blame.NewSetEntries(model)

local vhide = blame.NewViewHide(model)

self.model = model

-- self.units = blame.NewScanEnemy()
-- self.aggro = self:NewUnitsAggro(self.units)
-- self.controller = self:NewController(self.model, self.units, self.aggro)

print(blame.DISPLAY_NAME .. " loaded.")



-- f = CreateFrame("Frame")

-- f:SetScript("OnEvent", function()
-- 	if event ~= "ADDON_LOADED" then
-- 		return
-- 	end
-- 	local addon_name = arg1
-- 	if addon_name ~= ADDON_NAME then
-- 		return
-- 	end
-- 	controller.Init()
-- 	visible_units.Init()
-- 	view.Init()
-- 	print(DISPLAY_NAME .. " loaded.")
-- end)
