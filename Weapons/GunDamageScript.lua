local OnHit = script.Parent.OnHit
local Kills = 0
local KillsValue = script.Parent.GunScript.Kills

OnHit.OnServerEvent:Connect(function(Player, Target, Headshot)
	if Headshot == true then
		Target:FindFirstChild("Humanoid"):TakeDamage(50)
	else
		Target:FindFirstChild("Humanoid"):TakeDamage(20)
	end
	if Target:FindFirstChild("Humanoid").Health == 0 then
		Kills = Kills + 1
		KillsValue.Value = Kills
	end
end)