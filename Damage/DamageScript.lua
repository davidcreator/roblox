script.Parent.Blade.Touched:Connect(function(Player)

	if script.Parent.CanDamage.Value == true then

		script.Parent.CanDamage.Value = false

		Player.Parent.Humanoid:TakeDamage(20)
		
		wait(1)
		
		script.Parent.CanDamage.Value = true
	end
end)