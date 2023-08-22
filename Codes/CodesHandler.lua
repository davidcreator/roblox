local codes = {FreeSword = script.Sword, FreeGun = script.Gun}


local dss = game:GetService("DataStoreService")
local ds = dss:GetDataStore("CodesEntered")



game.ReplicatedStorage.CodeEntered.OnServerEvent:Connect(function(plr, codeEntered)
	
	
	
	local reward = codes[codeEntered]
	
	if not reward then 
		
		game.ReplicatedStorage.CodeEntered:FireClient(plr, "Code Invalid!")
		
	
	else
			
			
		local alreadyRedeemed = false

		pcall(function()

			alreadyRedeemed = ds:GetAsync(codeEntered .. plr.UserId) or false
		end)
			
			
		if not alreadyRedeemed then
				
			reward:Clone().Parent = plr.Backpack
				
				
			pcall(function()

				ds:SetAsync(codeEntered .. plr.UserId, true)
			end)
			
			
			game.ReplicatedStorage.CodeEntered:FireClient(plr, "Code Redeemed!")
			
			
		else
			
			game.ReplicatedStorage.CodeEntered:FireClient(plr, "Code Already Redeemed!")
		end
	end
end)