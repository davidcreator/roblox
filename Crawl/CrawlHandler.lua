local uis = game:GetService("UserInputService")

local crawlAnimation = script:WaitForChild("Crawl")
local loadedCrawlAnim

local crawlIdle = script:WaitForChild("CrawlIdle")
local loadedIdleAnim

local isCrawling = false

local humanoid = script.Parent:FindFirstChild("Humanoid")


uis.InputBegan:Connect(function(key, gameProcessed)
		
	if key.KeyCode == Enum.KeyCode.C then
				
		
		if isCrawling then
		
			isCrawling = false	
			
			if loadedCrawlAnim then loadedCrawlAnim:Stop() end	
			
			loadedIdleAnim:Stop()			
			
			game.ReplicatedStorage.OnCrouchBegun:FireServer(humanoid, 16, 50)
				
		elseif not isCrawling then

			isCrawling = true	
	
			loadedIdleAnim = humanoid:LoadAnimation(crawlIdle)
			loadedIdleAnim:Play()
			
			game.ReplicatedStorage.OnCrouchBegun:FireServer(humanoid, 3, 20)
		end
	end	
end)


game:GetService("RunService").RenderStepped:Connect(function()
		
	if not isCrawling then return end
		
	if humanoid.MoveDirection.Magnitude > 0 then
		
		if not loadedCrawlAnim then loadedCrawlAnim = humanoid:LoadAnimation(crawlAnimation) end
		if loadedCrawlAnim.IsPlaying == false then loadedCrawlAnim:Play() end	

	else
		loadedCrawlAnim:Stop()
		loadedIdleAnim:Play()
	end
end)