-- Import
local view = blame.view
-- Prototype
local flex = {}

function view.NewFlex(...)
	return blame.new2(flex, unpack(arg))
end

function flex:ctor(frame, get_children)
	-- f:SetPoint("TOP", 0, 0)
	-- f:SetWidth(parent:GetWidth())
	-- f:SetHeight(1)

	self.frame = frame
	self.get_children = get_children
	return self
end

function flex:Update()
	local children = self.get_children()
	local spacing = view.LIST_ENTRY_HEIGHT * 0.5 + view.LIST_SPACING * 0.5
	local magic = function(idx) return (1 + (idx - 1) * 2) end
	for idx, child in ipairs(children) do
		local offset_y = spacing * magic(idx)
		child:ClearAllPoints()
		child:SetPoint("TOP", 0, -offset_y)
	end
	local size_y = spacing * magic(blame.len(children) + 1)
	self.frame:SetHeight(size_y)
end