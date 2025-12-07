-- Import
local view = blame.view
-- Prototype
local list_item = {}

function view.NewListItem(parent, model)
	local self = {
		idx = 0,
	}

	local text = parent:CreateFontString(nil, "OVERLAY", "GameFontWhite")
	text:SetPoint("TOP", 0, 0)
	text:SetWidth(parent:GetWidth())
	text:SetHeight(view.LIST_ENTRY_HEIGHT)
	text:SetText("Empty entry")
	text:SetJustifyH("LEFT")
	-- text:SetJustifyV("TOP")
	text:SetShadowColor(0, 0, 0)
	text:SetShadowOffset(1, -1)
	view.set_font(text, view.LIST_ENTRY_FONT_SIZE)

	api.Subscribe(view_event.POOL_ASKS_UPDATE, function()
		if self.idx <= 0 then
			return
		end

		text:SetText(model.entries[self.idx])
	end)

	function self.Show(idx)
		self.idx = idx
		text:Show()
	end

	function self.Hide()
		text:Hide()
	end

	function self.SetPoint(point, x, y)
		text:ClearAllPoints()
		text:SetPoint(point, x, y)
	end

	self.text = text
	return self
end
