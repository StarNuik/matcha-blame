-- Import
local view = blame.view

function view.NewFlex(frame, get_children)
	local self = {}

	api.Subscribe(view_event.POOL_CHANGED, function()
		local children = get_children()
		if len(children) == 0 then
			frame:SetHeight(0)
			return
		end

		local curr_y = 0
		for idx, child in ipairs(children) do
			curr_y = curr_y + view.LIST_SPACING
			child.SetPoint("TOP", 0, -curr_y)
			curr_y = curr_y + view.LIST_ENTRY_HEIGHT
		end
		
		curr_y = curr_y + view.LIST_SPACING
		frame:SetHeight(curr_y)

		api.Fire(view_event.FLEX_SIZE_CHANGED, curr_y)
	end)

	return self
end
