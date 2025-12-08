local function split(str)
	local out = {}
	for token in string.gmatch(str, "[^%s]+") do
		append(out, token)
	end
	return out
end

local function blame_help()
	print("Usage: \\blame {clear | show | limit %d}")
end

local function blame_clear()
	api.Fire(svc_event.CMD_MODEL_CLEAR)
	print("Blame log cleared.")
end

local function blame_show()
	api.Fire(svc_event.CMD_MODEL_SHOW)
end

local function blame_limit(str)
	local num = tonumber(str)
	if not num then
		blame_help()
		return
	end
	if num <= 0 then
		print("%d has to be >= 1")
	end

	api.Fire(svc_event.CMD_LIMIT, num)
	print("Blame log limit set to " .. tostring(num))
end

local cmd_map = {
	clear = blame_clear,
	show = blame_show,
	limit = blame_limit,
}

SLASH_BLAME1, SLASH_BLAME2, SLASH_BLAME3 = "/blame", "/bl", "/matcha-blame"
function SlashCmdList.BLAME(msg)
	if not msg or msg == "" then
		blame_help()
		return
	end

	local tokens = split(msg)
	if not tokens[1] or tokens[1] == "" then
		blame_help()
		return
	end

	local cmd = string.lower(tokens[1])

	local action = cmd_map[cmd]
	if action then
		action(tokens[2])
	else
		blame_help()
	end
end
