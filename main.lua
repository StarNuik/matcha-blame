api.Subscribe(api_event.ADDON_LOADED, function(addon_name)
	if addon_name ~= blame.ADDON_NAME then
		return
	end

	blame.InitSaved()
	local model = blame.NewModel(BlameSaved)
	
	local view = blame.view.New(model)
	
	local uadd = blame.NewAddUnit(model)
	local eadd = blame.NewAddEnemy(model)
	local aadd = blame.NewAddAggro(model)
	local radd = blame.NewAddAggroRecord(model)
	local ucache = blame.NewCacheUnitInfo(model)
	local rgroup = blame.NewGroupRecord(model)
	
	local set_entries = blame.NewSetEntries(model)
	local vhide = blame.NewViewHide(model)
	local cmd = blame.NewCmdModel(model)

	-- Debugging
	blame.model = model
	--
	
	print(blame.DISPLAY_NAME .. " loaded.")
end)
