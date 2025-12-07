function blame.NewViewHide(model)
	api.Subscribe(view_event.INPUT_CLOSE, function()
		model.show = false
		api.Fire(view_event.MODEL_CHANGED)
	end)

	return {}
end