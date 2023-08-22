local plrGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")


local screenGui = Instance.new("ScreenGui", plrGui)

local txtButton = Instance.new("TextButton")
txtButton.BackgroundTransparency = 1
txtButton.Size = UDim2.new(0, 0, 0, 0)

txtButton.Modal = true

txtButton.Parent = screenGui