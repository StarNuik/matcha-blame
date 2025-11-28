blame = {}

function blame.SetEnv(t, index)
    setmetatable(t, {__index = index or getfenv(1)})
    setfenv(2, t)
end

blame.SetEnv(blame)

DISPLAY_NAME = "Blame"
ADDON_NAME = "matcha-blame"
