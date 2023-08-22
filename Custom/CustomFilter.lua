local filterList = {{"ez", "GG!"},
					{"ur bad", ""}}

local function filter(speakerName, messageObj, channelName)
	
	for i, filterWord in pairs(filterList) do
		
		if string.lower(messageObj.Message):match(filterWord[1]) then
			
			messageObj.Message = filterWord[2]
		end
	end
end

local function Run(chatService)
	chatService:RegisterFilterMessageFunction("customFilter", filter)
end


return Run
