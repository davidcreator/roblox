local cam = workspace.CurrentCamera

local plr = game.Players.LocalPlayer

local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local neck = char:FindFirstChild("Neck", true)

local y = neck.C0.Y


game:GetService("RunService").RenderStepped:Connect(function()
		
	if neck then
		
		local camDirection = hrp.CFrame:ToObjectSpace(cam.CFrame).LookVector
			
		neck.C0 = CFrame.new(0, y, 0) * CFrame.Angles(0, -camDirection.X, 0) * CFrame.Angles(camDirection.Y, 0, 0)
	end
end)