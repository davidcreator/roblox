local dss = game:GetService("DataStoreService")
local feedbackDS = dss:GetDataStore("Feedback")

local feedbackData = {}

local success, errorMessage = pcall(function()
	feedbackData = feedbackDS:GetAsync("List") or {}
end)


local re = game.ReplicatedStorage:WaitForChild("FeedbackRE")


re.OnServerEvent:Connect(function(plr, feedback)
	
	
	if string.len(string.gsub(feedback, " ", "")) > 0 then
		
		local success, errorMessage = pcall(function()
			feedback = game:GetService("TextService"):FilterStringAsync(feedback, plr.UserId)
			feedback = feedback:GetNonChatStringForBroadcastAsync()
		end)
		
		
		if success then
			
			local timeOfFeedback = os.time()
			local plrSent = plr.Name
			
			
			table.insert(feedbackData, {plrSent, feedback, timeOfFeedback})
			
			local success, err = pcall(function()
				
				feedbackDS:SetAsync("List", feedbackData)
			end)
		end
	end
end)


while wait(5) do
	
	local success, errorMessage = pcall(function()
		feedbackData = feedbackDS:GetAsync("List") or {}
	end)
	
	
	game.ReplicatedStorage:WaitForChild("FeedbackFolder"):ClearAllChildren()
	
	
	for i, feedbackInfo in pairs(feedbackData) do
		
		local plrName = feedbackInfo[1]
		local feedback = feedbackInfo[2]
		local timeSent = feedbackInfo[3]
		
		local timeValues = os.date("*t", timeSent)
		local formattedTime = timeValues["hour"] .. ":" ..  timeValues["min"] .. ":" .. timeValues["sec"]
		local formattedDate = timeValues["day"] .. "/" .. timeValues["month"] .. "/" .. timeValues["year"]
		local combinedTime = formattedTime .. "  " .. formattedDate
		
		
		local str = Instance.new("StringValue")
		str.Name = plrName .. " - " .. combinedTime
		str.Value = feedback
		
		str.Parent = game.ReplicatedStorage.FeedbackFolder
	end
end