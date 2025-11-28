function blame:Init()
	self.model = self:NewModel()

	self.view = self:NewView(self.model)
	
	self.units = self:NewVisibleUnits()
	self.aggro = self:NewUnitsAggro(self.units)
	self.controller = self:NewController(self.model, self.units, self.aggro)
	
	print(blame.DISPLAY_NAME .. " loaded.")
end

blame:Init()

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
