local visible_enemy = scan.NewEnemy()

function scan.NewVisibleEnemy()
	local self = new(visible_enemy)

	self.Entered = nil
	self.Left = nil

	visible_enemy_ctor(self)

	return self
end

local function visible_enemy_ctor(self)