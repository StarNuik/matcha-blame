blame = {}

function blame.SetEnv(t, index)
    setmetatable(t, {__index = index or getfenv(1)})
    setfenv(2, t)
end

function new(t)
    obj = {}
    setmetatable(obj, t)
    t.__index = t
    return obj
end

function blame.new(t, ctor)
    obj = {}
    setmetatable(obj, t)
    t.__index = t

    if ctor then
        ctor(obj)
    end
    
    return obj
end

-- blame.SetEnv(blame)

blame.DISPLAY_NAME = "Blame"
blame.ADDON_NAME = "matcha-blame"
