--Variables
local memoryStore = game:GetService("MemoryStoreService")
local queue = memoryStore:GetSortedMap("Queue")

local tpService = game:GetService("TeleportService")

local minimum = 2
local maximum = 30

local placeId = 9869371728

local re = game.ReplicatedStorage:WaitForChild("QueueRE")


--Functions to edit queue
function addToQueue(player)
	queue:SetAsync(player.UserId, player.UserId, 2592000)
end

function removeFromQueue(player)
	queue:RemoveAsync(player.UserId)
end


--Add and remove players from queue when they press the button
local cooldown = {}

re.OnServerEvent:Connect(function(player, inQueue)
	
	if cooldown[player] then return end
	cooldown[player] = true
	
	if inQueue == "IN QUEUE" then
		pcall(addToQueue, player)
	elseif inQueue == "QUEUE" then
		pcall(removeFromQueue, player)
	end
	
	wait(1)
	cooldown[player] = false
end)


--Remove player from queue if they leave the server
game.Players.PlayerRemoving:Connect(removeFromQueue)


--Check when enough players are in the queue to teleport players
local lastOverMin = tick()

while wait(1) do
	
	local success, queuedPlayers = pcall(function()
		return queue:GetRangeAsync(Enum.SortDirection.Descending, maximum)
	end)
	
	if success then
		
		local amountQueued = 0
		
		for i, data in pairs(queuedPlayers) do
			amountQueued += 1
		end
		
		if amountQueued < minimum then
			lastOverMin = tick()
		end
		
		--Wait 20 seconds after the minimum players is reached to allow for more players to join the queue
		--Or instantly queue once the maximum players is reached
		local timeOverMin = tick() - lastOverMin
		
		if timeOverMin >= 20 or amountQueued == maximum then
			
			for i, data in pairs(queuedPlayers) do	
				
				local userId = data.value
				local player = game.Players:GetPlayerByUserId(userId)
				
				if player then
					local success, err = pcall(function()
						tpService:TeleportAsync(placeId, {player})
					end) 
					
					spawn(function()
						if success then
							wait(1)
							pcall(function()
								queue:RemoveAsync(data.key)
							end)
						end
					end)
				end
			end
		end
	end
end