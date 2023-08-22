local Gun = script.Parent
local Gunshot = Gun:WaitForChild("Gunshot")
local OnHit = script.Parent.OnHit
local debounce = false
local Ammo = 5
local ReloadingSound = Gun:WaitForChild("Reloading")
local Reloading = false
local UIS = game:GetService("UserInputService")
local Player = game:GetService("Players").LocalPlayer
local Headshot = false

Player.PlayerGui.GunInfo.InfoFrame.Visible = false

Gun.Equipped:Connect(function(Mouse)
	Player.PlayerGui.GunInfo.InfoFrame.GunName.Text = Gun.Name
	Player.PlayerGui.GunInfo.InfoFrame.KillsText.Text = ("Kills: " .. script.Kills.Value)
	Player.PlayerGui.GunInfo.InfoFrame.AmmoText.Text = ("Ammo: " .. Ammo .. "/5")
	Player.PlayerGui.GunInfo.InfoFrame.Visible = true
	Mouse.Icon = "rbxassetid://4450645985"
	Gun.Activated:Connect(function()		
		if debounce == false and Reloading == false then
			if Ammo > 0 then
				debounce = true
				
				Ammo = Ammo - 1
				Ammo = Ammo
				Player.PlayerGui.GunInfo.InfoFrame.AmmoText.Text = ("Ammo: " .. Ammo .. "/5")
					
				Gunshot:Play()
				
				for i,x in pairs(Gun:WaitForChild("Flare"):GetChildren())do
					if x.ClassName == "Decal" then
						x.Transparency = 0
					end
				end
				wait(0.03)
				for i,x in pairs(Gun:WaitForChild("Flare"):GetChildren())do
					if x.ClassName == "Decal" then
						x.Transparency = 1
					end
				end
					
				if Mouse.Target then
					if Mouse.Target.Parent:FindFirstChild("Humanoid") then
						if Mouse.Target.Name == "Head" then 
							Headshot = true
						end
						OnHit:FireServer(Mouse.Target.Parent, Headshot)
						wait(0.1)
						Headshot = false
						Player.PlayerGui.GunInfo.InfoFrame.KillsText.Text = ("Kills: " .. script.Kills.Value)
					end
				end
		
				wait(0.7)
				debounce = false
				
			elseif Reloading == false then
				Mouse.Icon = "rbxassetid://4450665798"
				Reloading = true	
				ReloadingSound:Play()
				Player.PlayerGui.GunInfo.InfoFrame.AmmoText.Text = ("Reloading..")
				wait(3)
				Ammo = 5
				script:FindFirstChild("Ammo").Value = Ammo
				Player.PlayerGui.GunInfo.InfoFrame.AmmoText.Text = ("Ammo: " .. Ammo .. "/5")
				Reloading = false
				Mouse.Icon = "rbxassetid://4450645985"
			end
		end
	end)
	
	UIS.InputBegan:Connect(function(Key)
		if Key.KeyCode == Enum.KeyCode.R and Reloading == false and Ammo ~= 5 then
			Mouse.Icon = "rbxassetid://4450665798"
			Reloading = true	
			ReloadingSound:Play()
			Player.PlayerGui.GunInfo.InfoFrame.AmmoText.Text = ("Reloading..")
			wait(3)
			Ammo = 5
			script:FindFirstChild("Ammo").Value = Ammo
			Player.PlayerGui.GunInfo.InfoFrame.AmmoText.Text = ("Ammo: " .. Ammo .. "/5")
			Reloading = false
			Mouse.Icon = "rbxassetid://4450645985"
		end
	end)
end)

Gun.Unequipped:Connect(function()
	Player.PlayerGui.GunInfo.InfoFrame.Visible = false
end)