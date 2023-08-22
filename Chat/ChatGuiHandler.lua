local gui = script.Parent
local text = gui.TextBackground.Text
local op1 = gui.TextBackground.Option1
local op2 = gui.TextBackground.Option2


local range = 7

local plr = game.Players.LocalPlayer


local NPCs = {}

for i, descendant in pairs(workspace:GetDescendants()) do

	if descendant:FindFirstChild("Interactive") then
		table.insert(NPCs, descendant)
		descendant.Head.InteractGui.Interact.Size = UDim2.new(0, 0, 0, 0)
	end
end


local closestNPC = script:WaitForChild("nil")
local previousClosestNPC = closestNPC

game:GetService("RunService").RenderStepped:Connect(function()


	previousClosestNPC = closestNPC
	closestNPC = script:WaitForChild("nil")


	local NPCsInRange = {}
	for i, NPC in pairs(NPCs) do

		local distance = plr:DistanceFromCharacter(NPC.HumanoidRootPart.Position)

		if distance <= range then
			table.insert(NPCsInRange, NPC)
		end
	end


	for i, NPCInRange in pairs(NPCsInRange) do

		if not closestNPC then closestNPC = NPCInRange end

		if closestNPC.Name == "nil" or plr:DistanceFromCharacter(closestNPC.HumanoidRootPart.Position) > plr:DistanceFromCharacter(NPCInRange.HumanoidRootPart.Position) then
			closestNPC = NPCInRange
		end
	end


	script:WaitForChild("ClosestNPC").Value = closestNPC 
end)


script:WaitForChild("ClosestNPC"):GetPropertyChangedSignal("Value"):Connect(function()

	if closestNPC.Name == "nil" then

		for i, NPC in pairs(NPCs) do

			NPC.Head.InteractGui.Interact:TweenSize(UDim2.new(0, 0, 0, 0), "InOut", "Quint", 0.3, true)
		end
		
		gui.TextBackground:TweenPosition(UDim2.new(0.5, 0, 1 + gui.TextBackground.Size.Y.Scale, 0), "InOut", "Quint", 0.3, true)

	else

		if previousClosestNPC and previousClosestNPC.Name ~= "nil" then previousClosestNPC.Head.InteractGui.Interact:TweenSize(UDim2.new(0, 0, 0, 0), "InOut", "Quint", 0.3, true) end

		closestNPC.Head.InteractGui.Interact:TweenSize(UDim2.new(1, 0, 1, 0), "InOut", "Quint", 0.3, true)


		previousClosestNPC = closestNPC
	end
end)


local function handleChoice(interactVal, option)
	
	local character = plr.Character or plr.CharacterAdded:Wait()
	local hum = character:WaitForChild("Humanoid")
	
	
	if interactVal == "Would you like extra speed?" then

		if option == 1 then hum.WalkSpeed = hum.WalkSpeed + 10 end


	elseif interactVal == "Would you like extra jump?" then

		if option == 1 then hum.JumpPower = hum.JumpPower + 10 end
	end
	
	gui.TextBackground:TweenPosition(UDim2.new(0.5, 0, 1 + gui.TextBackground.Size.Y.Scale, 0), "InOut", "Quint", 0.3, true)
end


local uis = game:GetService("UserInputService")

uis.InputBegan:Connect(function(inp, processed)

	if processed or not closestNPC then return end

	if inp.KeyCode == Enum.KeyCode.E then

		local interactVal = closestNPC.Interactive.Value
		
		text.Text = ""
		gui.TextBackground:TweenPosition(UDim2.new(0.5, 0, 0.866, 0), "InOut", "Quint", 0.3, true)
		wait(0.3)
		
		
		op1.MouseButton1Click:Connect(function()
			handleChoice(interactVal, 1)
		end)
		op2.MouseButton1Click:Connect(function()
			handleChoice(interactVal, 2)
		end)
		
		
		for i = 1, #interactVal do
			
			text.Text = string.sub(interactVal, 1, i)
			wait()
		end
	end
end)