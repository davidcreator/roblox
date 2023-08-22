--KILL FEED PART
		if touch.Parent.Humanoid.Health < 1 then


			local killFeedMsg = script.Parent.Parent.Name .. " killed " .. touch.Parent.Name

			game.ReplicatedStorage.OnPlayerKilled:FireAllClients(killFeedMsg)
		end