local scan_aggro = {}
local private = {}

function blame.NewScanAggro()
	return blame.new(scan_aggro, scan_aggro_ctr)
end

function scan_aggro_ctr(self)
	self.scan = blame.NewScanEnemy()
	api.OnUpdate(function() self:update() end)
end

function scan_aggro:update(self)
	--
end
