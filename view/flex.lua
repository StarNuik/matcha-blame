-- Import
local view = blame.view
-- Prototype
local flex = {}

local function len(list)
	return table.getn(list)
end

function view.NewFlex(parent)
	return blame.new2(flex, parent)
end

function flex:ctor(parent)
	local f = CreateFrame("Frame", "$parent_Flex", parent)

	f:SetPoint("TOP", 0, 0)
	f:SetWidth(parent:GetWidth())
	f:SetHeight(1)

	self.frame = f
	return self
end

function flex:Update()
	local children = {self.frame:GetRegions()}
	local spacing = view.LIST_ENTRY_HEIGHT * 0.5 + view.LIST_SPACING * 0.5
	local magic = function(idx) return (1 + (idx - 1) * 2) end
	for idx, frame in ipairs(children) do
		local offset_y = spacing * magic(idx)
		frame:ClearAllPoints()
		frame:SetPoint("TOP", 0, -offset_y)
	end
	local size_y = spacing * magic(len(children) + 1)
	self.frame:SetHeight(size_y)
end