local repl = game.ReplicatedStorage:WaitForChild("EmotesReplicatedStorage")
local re = repl:WaitForChild("RE")
local allEmotes = repl:WaitForChild("Emotes")


--Opening and closing the UI
local sBtn = script.Parent:WaitForChild("ShopButton")
local sFrame = script.Parent:WaitForChild("ShopFrame")

sBtn.MouseButton1Click:Connect(function()
	sFrame.Visible = not sFrame.Visible
end)
sFrame.CloseButton.MouseButton1Click:Connect(function()
	sFrame.Visible = false
end)

local iBtn = script.Parent:WaitForChild("InventoryButton")
local iFrame = script.Parent:WaitForChild("InventoryFrame")

iBtn.MouseButton1Click:Connect(function()
	iFrame.Visible = not iFrame.Visible
end)
iFrame.CloseButton.MouseButton1Click:Connect(function()
	iFrame.Visible = false
end)

iFrame.Visible = false
sFrame.Visible = false
sFrame.SelectedEmoteFrame.Visible = false


--Emotes inventory
local emotesF = game.Players.LocalPlayer:WaitForChild("Emotes")

local playingEmotes = {}

function createInv()
	
	for i, child in pairs(iFrame.EmotesScroller:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
	
	local btns = {}
	
	for i, emote in pairs(emotesF:GetChildren()) do
		
		local btn = script.PlayEmoteButton:Clone()
		local emoteN = emote.Name
		btn.Text = emoteN
		
		local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
		local humanoid = char:WaitForChild("Humanoid")
		local loadedAnim = humanoid:LoadAnimation(emote)
		loadedAnim.Priority = Enum.AnimationPriority.Action
		
		btn.MouseButton1Click:Connect(function()	
			if loadedAnim.IsPlaying then
				loadedAnim:Stop()
			else
				
				for i, playingEmote in pairs(playingEmotes) do
					playingEmote:Stop()
					table.remove(playingEmotes, i)
				end
				loadedAnim:Play()
				table.insert(playingEmotes, loadedAnim)
			end
		end)
		
		table.insert(btns, btn)
	end
	
	table.sort(btns, function(a, b)
		return a.Text < b.Text
	end)
	
	for i, btn in pairs(btns) do
		btn.Parent = iFrame.EmotesScroller
	end
end

createInv()
emotesF.ChildAdded:Connect(createInv)
emotesF.ChildRemoved:Connect(createInv)


--Emotes shop
local cash = game.Players.LocalPlayer:WaitForChild("leaderstats"):WaitForChild("Cash")

function createShop()

	for i, child in pairs(sFrame.EmotesScroller:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	local btns = {}

	for i, emote in pairs(allEmotes:GetChildren()) do

		if emote:FindFirstChild("PRICE") then
			local btn = script.SelectEmoteButton:Clone()
			local emoteN = emote.Name
			btn.EmoteName.Text = emoteN
				
				
			local cam = Instance.new("Camera")
			cam.Parent = btn.EmotePreview
			btn.EmotePreview.CurrentCamera = cam
				
			local char = repl.PreviewCharacter:Clone()
			char.Parent = btn.EmotePreview
			
			local hrp = char.HumanoidRootPart
			cam.CFrame = CFrame.new(hrp.Position + hrp.CFrame.LookVector * 5, hrp.Position)
				

			local price = emote.PRICE.Value

			btn.MouseButton1Click:Connect(function()

				sFrame.SelectedEmoteFrame.EmoteName.Text = emoteN

				if not emotesF:FindFirstChild(emoteN) then
					sFrame.SelectedEmoteFrame.BuyButton.Text = "BUY for $" .. price
				else
					sFrame.SelectedEmoteFrame.BuyButton.Text = "OWNED"
				end
					
				sFrame.SelectedEmoteFrame.EmotePreview:ClearAllChildren()
					
				local cam2 = Instance.new("Camera")
				cam2.Parent = sFrame.SelectedEmoteFrame.EmotePreview
				sFrame.SelectedEmoteFrame.EmotePreview.CurrentCamera = cam2

				local wModel2 = Instance.new("WorldModel")
				local char2 = repl.PreviewCharacter:Clone()
				char2.Parent = workspace

				local loadedAnim2 = char2.Humanoid:LoadAnimation(emote)
				loadedAnim2.Looped = true
				loadedAnim2:Play()
					
				wModel2.Parent = sFrame.SelectedEmoteFrame.EmotePreview
				char2.Parent = wModel2

				local hrp2 = char2.HumanoidRootPart
				cam2.CFrame = CFrame.new(hrp2.Position + hrp2.CFrame.LookVector * 5.2, hrp2.Position)
					
				sFrame.SelectedEmoteFrame.Visible = true
			end)

			table.insert(btns, btn)
		end
	end

	table.sort(btns, function(a, b)
		local aPrice = allEmotes[a.EmoteName.Text].PRICE.Value
		local bPrice = allEmotes[b.EmoteName.Text].PRICE.Value
		return aPrice < bPrice or aPrice == bPrice and a.EmoteName.Text < b.EmoteName.Text
	end)

	for i, btn in pairs(btns) do
		btn.Parent = sFrame.EmotesScroller
	end
end

createShop()
allEmotes.ChildAdded:Connect(createShop)
allEmotes.ChildRemoved:Connect(createShop)


--Send message to server to buy selected emote
sFrame.SelectedEmoteFrame.BuyButton.MouseButton1Click:Connect(function()
	
	if sFrame.SelectedEmoteFrame.BuyButton.Text ~= "OWNED" then
		
		local emoteN = sFrame.SelectedEmoteFrame.EmoteName.Text
		local emotePrice = allEmotes[emoteN].PRICE.Value
		
		if cash.Value >= emotePrice then
			re:FireServer(emoteN)
			
			sFrame.SelectedEmoteFrame.BuyButton.Text = "OWNED"
		end
	end
end)