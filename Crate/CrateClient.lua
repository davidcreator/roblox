local crates = game.ReplicatedStorage:WaitForChild("Crates")


local gui = script.Parent

local cratesGui = gui:WaitForChild("CratesGui")
local unboxGui = gui:WaitForChild("UnboxGui")


local isOpeningCrate = false


local minTime, maxTime = 5, 10
local minCells, maxCells = 15, 50


local openGui = gui:WaitForChild("OpenCrateGui")

openGui.MouseButton1Click:Connect(function()
	
	if isOpeningCrate then return end
	
	cratesGui.Visible = not cratesGui.Visible
end)


for i, crate in pairs(crates:GetChildren()) do
	
	local crateName = crate.Name
	local cratePrice = crate.Price.Value
	
	
	local clonedTemplate = script:WaitForChild("BuyCrateTemplate"):Clone()
	
	clonedTemplate.CrateInfo.Text = crateName .. "\nPrice: " .. cratePrice
	
	
	clonedTemplate.Parent = cratesGui:WaitForChild("CratesScroll")
	
	
	clonedTemplate.MouseButton1Click:Connect(function()
		
		
		if not isOpeningCrate then
			
			isOpeningCrate = true
			
			
			local cells = math.random(minCells, maxCells)
			local unboxTime = math.random(minTime, maxTime)
			
			game.ReplicatedStorage.CrateRE:FireServer(crateName, unboxTime)
			
			
			local connection
			
			connection = game.ReplicatedStorage.CrateRE.OnClientEvent:Connect(function(chosenWeapon)
			
			
				local weaponCell = math.random(7, cells - 7)
				
				local weaponVPF
				
				
				unboxGui.WeaponsClipping.Scroller.Size = UDim2.new(0, cells * unboxGui.WeaponsClipping.Scroller.AbsoluteSize.Y, 1, 0)
				unboxGui.WeaponsClipping.Scroller.Position = UDim2.new(0, 0, 0, 0)
				unboxGui.WeaponsClipping.Scroller:ClearAllChildren()
				

				for i = 1, cells do
					
					
					local vpf = Instance.new("ViewportFrame")
					
					local weapon

					if i ~= weaponCell then
						
						repeat weapon = crates[crateName]:GetChildren()[math.random(#crates[crateName]:GetChildren())]; wait() until weapon:IsA("Tool")
						
					else
						weapon = chosenWeapon
						weaponVPF = vpf
					end
					
					
					local clone = weapon.Handle:Clone()
					clone.Parent = vpf
					
					clone.Anchored = true
					
					local cam = Instance.new("Camera")
					cam.Parent = vpf
					
					cam.CFrame = CFrame.new(clone.Position + Vector3.new(0, 0, 3), clone.Position)
					
					vpf.CurrentCamera = cam

					
					vpf.Size = UDim2.new(0, unboxGui.WeaponsClipping.Scroller.AbsoluteSize.X / cells, 1, 0)
					vpf.Position = UDim2.new(0, vpf.AbsoluteSize.X * (i - 1), 0, 0)
					
					
					vpf.Parent = unboxGui.WeaponsClipping.Scroller
				end
				
				cratesGui.Visible = false
				unboxGui.Visible = true
				
				
				local offset = math.random(-weaponVPF.AbsoluteSize.X/2, weaponVPF.AbsoluteSize.X/2)
				local distance =  (weaponVPF.AbsolutePosition.X + (weaponVPF.AbsoluteSize.X / 2)) - unboxGui.Marker.AbsolutePosition.X
				
				unboxGui.WeaponsClipping.Scroller:TweenPosition(UDim2.new(0, -distance + offset, 0, 0), "InOut", "Quint", unboxTime)
				

				wait(unboxTime)
				isOpeningCrate = false
				unboxGui.Visible = false
				
				connection:Disconnect()
			end)
		end
	end)
end