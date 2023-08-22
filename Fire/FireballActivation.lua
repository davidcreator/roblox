local UIS = game:GetService("UserInputService")
local mouse = game.Players.LocalPlayer:GetMouse()
local debounce = false

UIS.InputBegan:Connect(function(key, processed)
	if processed or debounce then return end
	   
    if key.KeyCode == Enum.KeyCode.Q then
		debounce = true
	    workspace.FireballScript.RemoteEvent:FireServer(mouse.Hit.Position)
	end

    wait(1)
    debounce = false
end)