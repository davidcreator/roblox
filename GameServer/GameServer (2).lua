game.Players.CharacterAutoLoads = false
game.StarterPlayer.CameraMode = Enum.CameraMode.LockFirstPerson


game.Players.PlayerAdded:Connect(function(plr)
	plr:LoadCharacter()
end)


--Start sequence
local ts = game:GetService("TweenService")


local lift = workspace:WaitForChild("Starting Room"):WaitForChild("Lift")
local liftDoor = workspace:WaitForChild("Starting Room"):WaitForChild("LiftDoor")

local liftTI = TweenInfo.new(25, Enum.EasingStyle.Linear)
local liftDoorTI = TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)


local liftCFV = Instance.new("CFrameValue")
liftCFV.Value = lift.PrimaryPart.CFrame
local goalCF = liftCFV.Value - Vector3.new(0, liftCFV.Value.Position.Y - 0.5, 0)

liftCFV:GetPropertyChangedSignal("Value"):Connect(function()
	
	lift:SetPrimaryPartCFrame(liftCFV.Value)
end)

local liftTween = ts:Create(liftCFV, liftTI, {Value = goalCF})
liftTween:Play()

liftTween.Completed:Wait()
task.wait(2)


local liftDoorCFV = Instance.new("CFrameValue")
liftDoorCFV.Value = liftDoor.PrimaryPart.CFrame
local goalDoorCF = liftDoorCFV.Value + Vector3.new(0, liftDoor:GetExtentsSize().Y, 0)

liftDoorCFV:GetPropertyChangedSignal("Value"):Connect(function()

	liftDoor:SetPrimaryPartCFrame(liftDoorCFV.Value)
end)

local liftDoorTween = ts:Create(liftDoorCFV, liftDoorTI, {Value = goalDoorCF})
liftDoorTween:Play()

liftDoorTween.Completed:Wait()