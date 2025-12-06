local self = blame

local model = blame.NewModel()

local view = blame.view.New(model)

model:ClearEntries()
model:PushEntry("woof")
model:PushEntry("meow")
model:PushEntry("moo")
model:PushEntry("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
model:FireChanged()

self.model = model
self.view = view

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
