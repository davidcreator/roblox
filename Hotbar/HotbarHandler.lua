game:GetService('StarterGui'):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)


local plr = game.Players.LocalPlayer
local char = plr.Character

local backpack = plr:WaitForChild("Backpack")


local tools = backpack:GetChildren()


local slotMax = 9


local hotbar = script.Parent


local numToWord = 
	{
		[1] = "One",
		[2] = "Two",
		[3] = "Three",
		[4] = "Four",
		[5] = "Five",
		[6] = "Six",
		[7] = "Seven",
		[8] = "Eight",
		[9] = "Nine"
	}


local function updateHotbar()


	for i, child in pairs(hotbar:GetChildren()) do

		if child.Name == "Slot" then child:Destroy() end
	end


	for i, tool in pairs(tools) do


		if i > slotMax then return end


		local slotClone = script.Slot:Clone()
		slotClone.HotkeyNumber.Text = i
		
		
		slotClone.GunIcon.Image = "rbxassetid://" .. tool.ImageId.Value

		
		slotClone.Parent = hotbar
		
		
		if tool.Parent == char then

			slotClone.BackgroundColor3 = Color3.fromRGB(88, 88, 88)
		end
		
		
		game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
			
			if not processed then
				
				if input.KeyCode == Enum.KeyCode[numToWord[i]] then
					
					game.ReplicatedStorage.EquipToolRE:FireServer(tool, tool.Parent)			
				end
			end
		end)
	end
end

updateHotbar()


backpack.ChildAdded:Connect(function(child)
	
	if not table.find(tools, child) then
		table.insert(tools, child)
		updateHotbar()
	end
end)

backpack.ChildRemoved:Connect(function(child)
	
	if child.Parent ~= char then
		table.remove(tools, tools[child])
		updateHotbar()
	end
end)


char.ChildAdded:Connect(function(child)
	
	if child:IsA("Tool") and not table.find(tools, child) then
		table.insert(tools, child)
		updateHotbar()
	end
end)

char.ChildRemoved:Connect(function(child)

	if child.Parent ~= backpack then
		table.remove(tools, tools[child])
		updateHotbar()
	end
end)



game.ReplicatedStorage.EquipToolRE.OnClientEvent:Connect(function()
	
	
	for x, slot in pairs(hotbar:GetChildren()) do
		
		
		if slot:IsA("Frame") then
		
			local tool = tools[tonumber(slot.HotkeyNumber.Text)]

			if tool.Parent ~= char then

				slot.BackgroundColor3 = Color3.fromRGB(57, 57, 57)
				
			else
				slot.BackgroundColor3 = Color3.fromRGB(88, 88, 88)
			end
		end
	end
end)