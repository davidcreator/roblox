script.RemoteEvent.OnServerEvent:Connect(function(Player, Mouse)
		
	print("remote event fired")
    local Fireball = game:GetService("ServerStorage").Fireball:Clone()
    local Explosion = game:GetService("ServerStorage").Explosion:Clone()
    local Character = Player.Character

	
    Fireball.Position = Character.HumanoidRootPart.Position
    Fireball.Parent = workspace
    local velocity = Instance.new("BodyVelocity", Fireball)
    velocity.Velocity = CFrame.new(Fireball.Position, Mouse).LookVector * 100
 

    Fireball.Touched:Connect(function(Touched)
        if Touched:IsDescendantOf(Character) then return end

        Explosion.Position = Fireball.Position
        Fireball:Destroy()
        Explosion.Parent = workspace
       
        if Touched.Parent:FindFirstChild("Humanoid") then
            Touched.Parent:FindFirstChild("Humanoid"):TakeDamage(30)
        end
       
        wait(2)
		for i = 1, 300 do
        	Explosion.Fire.Size = Explosion.Fire.Size - 0.08
			Explosion.Fire.Heat = Explosion.Fire.Heat - 0.03
			wait()
		end
		Explosion:Destroy()
    end)
end)