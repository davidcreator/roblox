--Gui components
local btn = script.Parent:WaitForChild("OpenArmorImageButton")
local frame = script.Parent:WaitForChild("ArmorInventoryFrame")
frame.Visible = false

local invframe = frame:WaitForChild("InventoryFrame")
local closebtn = frame:WaitForChild("CloseImageButton")
local scrollingframe = invframe:WaitForChild("ArmorInventoryScrollingFrame")
local statsframe = invframe:WaitForChild("ArmorStatsFrame")
statsframe.Visible = false
local charframe = frame:WaitForChild("CharacterFrame")
local charvpf = charframe:WaitForChild("CharacterViewportFrame")

local wearingArmorButtons = {
	Head  = charframe:WaitForChild("HeadImageButton");
	Torso = charframe:WaitForChild("TorsoImageButton");
	Hands = charframe:WaitForChild("HandsImageButton");
	Legs  = charframe:WaitForChild("LegsImageButton");
	Feet  = charframe:WaitForChild("FeetImageButton");
}

local armorpieceTemplate = script:WaitForChild("ArmorPieceTextButton")

--RemoteEvents
local remotes = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents")
local equipRE = remotes:WaitForChild("EquipArmor")
local removeRE = remotes:WaitForChild("RemoveArmor")
local deleteRE = remotes:WaitForChild("DeleteArmor")

--Other variables
local numslots = 30

local me = game.Players.LocalPlayer
local myInv = me:WaitForChild("ArmorInventory")
local myEquipped = me:WaitForChild("ArmorEquipped")

local mouse = me:GetMouse()

local armorpieces = game:GetService("ReplicatedStorage"):WaitForChild("ArmorPieces")


--Stats frame
local selectedSlot = nil

statsframe:WaitForChild("CloseTextButton").MouseButton1Click:Connect(function()
	statsframe.Visible = false
	selectedSlot = nil
end)

statsframe:WaitForChild("EquipTextButton").MouseButton1Click:Connect(function()
	statsframe.Visible = false
	
	for _, armorpiece in pairs(armorpieces:GetDescendants()) do
		if armorpiece.Name == selectedSlot["ARMOR PIECE"].Value.Name and armorpiece.Parent.Parent == armorpieces then
			equipRE:FireServer(armorpiece.Parent.Name, selectedSlot["ARMOR PIECE"].Value.Name)
			break
		end
	end
end)

statsframe:WaitForChild("DeleteTextButton").MouseButton1Click:Connect(function()
	statsframe.Visible = false
	deleteRE:FireServer(selectedSlot["ARMOR PIECE"].Value.Name)
end)


--Inventory set up
for i = 1, numslots do
	local newslot = armorpieceTemplate:Clone()
	newslot.NameTextLabel.Visible = false
	newslot.ModelViewportFrame.Visible = false
	newslot.ModelImageLabel.Visible = false
	newslot.Name = i
	newslot.Parent = scrollingframe
	
	newslot.MouseButton1Click:Connect(function()
		
		if newslot.NameTextLabel.Visible == true then
			selectedSlot = newslot
			
			statsframe.NameTextLabel.Text = newslot.NameTextLabel.Text
			
			local armor = newslot["ARMOR PIECE"].Value
			local health = armor:WaitForChild("Stats").Health.Value
			if health > 0 then
				health = "+" .. tostring(health)
			end
			local speed = armor:WaitForChild("Stats").Speed.Value
			if speed > 0 then
				speed = "+" .. tostring(speed)
			end
			statsframe.HealthTextLabel.Text = "Health: " .. health
			statsframe.SpeedTextLabel.Text = "Speed: " .. speed
			
			statsframe.Position = UDim2.new(0, mouse.X - statsframe.Parent.AbsolutePosition.X, 0, mouse.Y - statsframe.Parent.AbsolutePosition.Y)
			
			statsframe.Visible = true
		end
	end)
end

function updateInv()
	task.wait(0.1)
	local inv = myInv:GetChildren()
	table.sort(inv, function(a, b)
		return (a.Stats.Health.Value + a.Stats.Speed.Value) > (b.Stats.Health.Value + b.Stats.Speed.Value)
	end)
	
	for _, slot in pairs(scrollingframe:GetChildren()) do
		if slot.ClassName == armorpieceTemplate.ClassName then
			
			if tonumber(slot.Name) > #inv then
				slot.NameTextLabel.Visible = false
				slot.ModelViewportFrame.Visible = false
				slot.ModelImageLabel.Visible = false
				
				if slot:FindFirstChild("ARMOR PIECE") then
					slot["ARMOR PIECE"]:Destroy()
				end
				
			else
				slot.NameTextLabel.Text = inv[tonumber(slot.Name)].Name
				
				if not inv[tonumber(slot.Name)]:WaitForChild("Stats"):FindFirstChild("Icon") then
					local armorModel = inv[tonumber(slot.Name)]:Clone()
					armorModel:PivotTo(CFrame.new())
					armorModel.Parent = slot.ModelViewportFrame
					
					local cf, size = armorModel:GetBoundingBox()
					
					local cc = Instance.new("Camera")
					cc.Name = "CurrentCamera"
					cc.CFrame = CFrame.new(size * 0.7 + Vector3.new(-1, 1, 0), cf.Position)
					cc.Parent = slot.ModelViewportFrame
					slot.ModelViewportFrame.CurrentCamera = cc
					
					slot.ModelImageLabel.Visible = false
					slot.ModelViewportFrame.Visible = true
					
				else
					slot.ModelImageLabel.Image = inv[tonumber(slot.Name)]:WaitForChild("Stats").Icon.Value
					
					slot.ModelViewportFrame.Visible = false
					slot.ModelImageLabel.Visible = true
				end
				
				if slot:FindFirstChild("ARMOR PIECE") then
					slot["ARMOR PIECE"].Value = inv[tonumber(slot.Name)]
				else
					local armorpieceValue = Instance.new("ObjectValue")
					armorpieceValue.Name = "ARMOR PIECE"
					armorpieceValue.Value = inv[tonumber(slot.Name)]
					armorpieceValue.Parent = slot
				end
				
				slot.NameTextLabel.Visible = true
				slot.Visible = true
			end
		end
	end
	
	for _, equipped in pairs(myEquipped:GetChildren()) do
		
		if equipped.Value == nil then
			wearingArmorButtons[equipped.Name].NameTextLabel.Visible = false
			wearingArmorButtons[equipped.Name].ModelViewportFrame.Visible = false
			wearingArmorButtons[equipped.Name].ModelImageLabel.Visible = false
			wearingArmorButtons[equipped.Name].ModelViewportFrame:ClearAllChildren()
			
		else
			wearingArmorButtons[equipped.Name].ModelViewportFrame:ClearAllChildren()
			
			for _, armorpiece in pairs(armorpieces:GetDescendants()) do
				if armorpiece.Name == equipped.Value.Name and armorpiece.Parent.Parent == armorpieces then
					
					if not armorpiece:WaitForChild("Stats"):FindFirstChild("Icon") then
						local armorModel = armorpiece:Clone()
						armorModel:PivotTo(CFrame.new())
						armorModel.Parent = wearingArmorButtons[equipped.Name].ModelViewportFrame

						local cf, size = armorModel:GetBoundingBox()

						local cc = Instance.new("Camera")
						cc.Name = "CurrentCamera"
						cc.CFrame = CFrame.new(size * 0.7 + Vector3.new(-1, 1, 0), cf.Position)
						cc.Parent = wearingArmorButtons[equipped.Name].ModelViewportFrame
						wearingArmorButtons[equipped.Name].ModelViewportFrame.CurrentCamera = cc
						
						wearingArmorButtons[equipped.Name].ModelImageLabel.Visible = false
						wearingArmorButtons[equipped.Name].ModelViewportFrame.Visible = true

					else
						wearingArmorButtons[equipped.Name].ModelImageLabel.Image = armorpiece:WaitForChild("Stats").Icon.Value

						wearingArmorButtons[equipped.Name].ModelViewportFrame.Visible = false
						wearingArmorButtons[equipped.Name].ModelImageLabel.Visible = true
					end

					wearingArmorButtons[equipped.Name].NameTextLabel.Text = equipped.Value.Name
					wearingArmorButtons[equipped.Name].NameTextLabel.Visible = true
					
					break
				end
			end
		end
	end
end

updateInv()
myInv.ChildAdded:Connect(updateInv)
myInv.ChildRemoved:Connect(updateInv)
for _, child in pairs(myEquipped:GetChildren()) do
	child:GetPropertyChangedSignal("Value"):Connect(updateInv)
end


--Unequipping armor
for armortype, btn in pairs(wearingArmorButtons) do
	btn.MouseButton1Click:Connect(function()
		if btn.NameTextLabel.Visible == true then
			removeRE:FireServer(armortype)
		end
	end)
end


--Opening and closing inventory
btn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

closebtn.MouseButton1Click:Connect(function()
	frame.Visible = false
end)


--Character viewer
game:GetService("RunService").Heartbeat:Connect(function()
	
	if frame.Visible == true then
		local char = game.Players.LocalPlayer.Character
		if char.Archivable == false then
			char.Archivable = true
		end
		
		if not charvpf:FindFirstChild("CurrentCamera") then
			local cc = Instance.new("Camera")
			cc.Name = "CurrentCamera"
			cc.Parent = charvpf
			charvpf.CurrentCamera = cc
		end
		
		if charvpf:FindFirstChild("Character") then
			charvpf["Character"]:Destroy()
		end
		
		local newchar = char:Clone()
		newchar.Name = "Character"
		local hrp = newchar:WaitForChild("HumanoidRootPart")
		newchar.Parent = charvpf
		
		charvpf["CurrentCamera"].CFrame = CFrame.new(hrp.Position + (hrp.CFrame.LookVector * 5), hrp.Position)
	end
end)