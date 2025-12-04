local scan_enemy = scan.NewFrame()

function scan.NewEnemy()
	local self = new(scan_enemy)

	self.EnemyVisible = function() end

	scan_enemy_ctor(self)

	return self
end

local function scan_enemy_ctor(self)
	local action = self.EnemyVisible
	self.UnitVisible = function(unit_id)
		if not api.IsEnemyMob(unit_id) then
			return
		end
		if self.EnemyVisible then
			self.EnemyVisible()
		end
	end
end