function blame.InitSaved()
	if not BlameSaved then
		BlameSaved = {}
	end
	if not BlameSaved.list_limit then
		BlameSaved.list_limit = blame.DEFAULT_LIST_LIMIT
	end
end