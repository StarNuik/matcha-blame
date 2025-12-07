function blame.NewAddEnemy(model)
	local self = {}

	local function add_enemy(guid)
		if not api.IsEnemyMob(guid) then
			return
		end
		model.enemies[guid] = true
		api.Fire(svc_event.ENEMY_ADDED, guid)
	end

	api.Subscribe(svc_event.UNIT_ADDED, add_enemy)

	return self
end