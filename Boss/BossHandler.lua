local boss = script.Parent.Parent.Parent
local humanoid = boss:WaitForChild("Humanoid")


local ts = game:GetService("TweenService")
local ringTI = TweenInfo.new(8, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
local fadeTI = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
local meteorTI = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)


local attacks = game.ServerStorage:WaitForChild("Attacks")

local attacksContainer = Instance.new("Folder", workspace)


local health = 1000

humanoid.MaxHealth = health
humanoid.Health = health

local bar = script.Parent.BarBackground:WaitForChild("Bar")
local healthLabel = script.Parent.BarBackground:WaitForChild("HealthText")


function healthChanged()

	local xScale = humanoid.Health / humanoid.MaxHealth

	bar:TweenSize(UDim2.new(xScale, 0, 1, 0), "InOut", "Quint", 0.3)
	healthLabel.Text = humanoid.Health .. "/" .. health
end

healthChanged()


humanoid.HealthChanged:Connect(healthChanged)


humanoid.Died:Connect(function()

	attacksContainer.Parent = game.ServerStorage

	for i, descendant in pairs(boss:GetDescendants()) do

		if descendant:IsA("BasePart") then

			ts:Create(descendant, fadeTI, {Transparency = 1}):Play()
		end
	end

	wait(1)
	attacksContainer:Destroy()
	boss:Destroy()
end)


while humanoid.Health > 0 do


	repeat wait() until #game.Players:GetPlayers() > 0


	local ring = attacks.RingAttack:Clone()
	ring.Size = Vector3.new(0, 0, 0)
	ring.Position = boss.HumanoidRootPart.Position - Vector3.new(0, humanoid.HipHeight*1.5, 0)

	local tween = ts:Create(ring, ringTI, {Size = Vector3.new(1000, 0.5, 1000)})
	tween:Play()

	ring.Parent = attacksContainer


	local touched = {}
	ring.Touched:Connect(function(hit)

		if hit.Parent:FindFirstChild("Humanoid") and not touched[hit.Parent.Humanoid] and hit.Parent.Humanoid ~= humanoid then

			touched[hit.Parent.Humanoid] = true

			hit.Parent.Humanoid:TakeDamage(20)
		end
	end)

	tween.Completed:Wait()
	ring:Destroy()
	
	
	local hrps = {}
	
	repeat wait()

		for i, plr in pairs(game.Players:GetPlayers()) do

			if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then

				table.insert(hrps, plr.Character.HumanoidRootPart)
			end
		end
	until #hrps > 0 

	local randomPos = hrps[math.random(1, #hrps)].Position

	humanoid:MoveTo(randomPos)

	boss.HumanoidRootPart.Velocity = randomPos + Vector3.new(0, game.Workspace.Gravity * 0.7, 0)


	touched = {}
	local connection = humanoid.Touched:Connect(function(hit)

		if hit.Parent:FindFirstChild("Humanoid") and not touched[hit.Parent.Humanoid] then

			touched[hit.Parent.Humanoid] = true

			hit.Parent.Humanoid:TakeDamage(10)
		end
	end)

	wait(5)
	connection:Disconnect()


	for i = 1, math.random(7, 15) do

		local circle = attacks.CircleAttack:Clone()

		local randomX = math.random(boss.HumanoidRootPart.Position.X - 100, boss.HumanoidRootPart.Position.X + 100)
		local randomZ = math.random(boss.HumanoidRootPart.Position.Z - 100, boss.HumanoidRootPart.Position.Z + 100)

		local y = boss.HumanoidRootPart.Position.Y - humanoid.HipHeight*1.5

		local randomPos = Vector3.new(randomX, y, randomZ)
		circle.Position = randomPos


		local colourTween = ts:Create(circle, fadeTI, {Color = Color3.fromRGB(196, 40, 28)})
		colourTween:Play()

		circle.Parent = attacksContainer


		coroutine.resume(coroutine.create(function()

			colourTween.Completed:Wait()


			local meteor = attacks.Meteor:Clone()
			meteor.Position = circle.Position + Vector3.new(0, 70, 0)

			local fallTween = ts:Create(meteor, meteorTI, {Position = circle.Position})
			fallTween:Play()

			meteor.Parent = attacksContainer


			touched = {}
			meteor.Touched:Connect(function(hit)

				if hit.Parent:FindFirstChild("Humanoid") and not touched[hit.Parent.Humanoid] and hit.Parent.Humanoid ~= humanoid then

					touched[hit.Parent.Humanoid] = true

					hit.Parent.Humanoid:TakeDamage(30)
				end
			end)

			fallTween.Completed:Connect(function()
				meteor:Destroy()
				circle:Destroy()
			end)
		end))


		wait(1)
	end
end