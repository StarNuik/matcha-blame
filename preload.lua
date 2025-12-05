-- Namespaces
blame = {}
blame.view = {}

-- Consts
blame.DISPLAY_NAME = "Blame"
blame.ADDON_NAME = "matcha-blame"

function blame.SetEnv(t, index)
	setmetatable(t, {__index = index or getfenv(1)})
	setfenv(2, t)
end

function new(t)
	local obj = {}
	setmetatable(obj, t)
	t.__index = t
	return obj
end

function blame.new(t, ctor)
	local obj = {}
	setmetatable(obj, t)
	t.__index = t

	if ctor then
		ctor(obj)
	end
	
	return obj
end

function blame.new2(t, ...)
	local obj = {}
	setmetatable(obj, t)
	t.__index = t

	if obj.ctor then
		obj:ctor(unpack(arg))
	end
	
	return obj
end

function blame.new_event()
	local self = {
		subscribers = {},
	}

	function self.Subscribe(callback)
		print(callback)
		table.insert(self.subscribers, callback)
	end

	function self.Fire()
		for _, callback in ipairs(self.subscribers) do
			callback()
		end
	end

	return self
end
-- blame.SetEnv(blame)


