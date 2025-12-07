function blame.NewCmdModel(model)
	api.Subscribe(svc_event.CMD_MODEL_CLEAR, function()
		model.Clear()
		api.Fire(view_event.MODEL_ENTRIES_CHANGED, 0)
		api.Fire(view_event.MODEL_CHANGED)
	end)

	api.Subscribe(svc_event.CMD_MODEL_SHOW, function()
		model.show = true
		api.Fire(view_event.MODEL_CHANGED)
	end)

	return {}
end