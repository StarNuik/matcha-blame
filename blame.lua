blame.SetEnv(blame)

function Init()
	controller.Init()
	visible_units.Init()
	view.Init()
	print(DISPLAY_NAME .. " loaded.")
end

Init()

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
