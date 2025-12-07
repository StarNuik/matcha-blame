-- Import
local view = blame.view

function view.NewFlex(frame, get_children)
	local self = {}

	api.Subscribe(view_event.POOL_CHANGED, function()
		local children = get_children()
		local spacing = view.LIST_ENTRY_HEIGHT * 0.5 + view.LIST_SPACING * 0.5
		local magic = function(idx) return (1 + (idx - 1) * 2) end

		for idx, child in ipairs(children) do
			local offset_y = spacing * magic(idx)
			child.SetPoint("TOP", 0, -offset_y)
		end

		local size_y = spacing * magic(len(children) + 1)
		frame:SetHeight(size_y)

		api.Fire(view_event.FLEX_SIZE_CHANGED, size_y)
	end)

	return self
end
