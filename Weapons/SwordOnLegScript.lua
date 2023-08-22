while wait() do
	if script.Parent.Parent.Name == "Backpack" then
		local Chararacter = script.Parent.Parent.Parent.Character
		
		if Chararacter then
	  		local UpperTorso = Chararacter:FindFirstChild("UpperTorso")
	  		local Weapon = Chararacter:FindFirstChild(script.Parent.Name)
	
	  		if UpperTorso and not Weapon then
		   		local WeaponOnLeg = Instance.new("Model")
		   		WeaponOnLeg.Name = script.Parent.Name
		   		WeaponOnLeg.Parent = Chararacter
		
		   		Handle = script.Parent.Handle:Clone()
			    Handle.Name = "Handle"
			    Handle.Parent = WeaponOnLeg
			
			    local LegWeld = Instance.new("Weld")
			    LegWeld.Name = "WeldOnLeg"
			    LegWeld.Part0 = UpperTorso
			    LegWeld.Part1 = Handle
			    LegWeld.C0 = CFrame.new(1,-1.42,0.5)
			    LegWeld.C0 = LegWeld.C0 * CFrame.fromEulerAnglesXYZ(math.rad(-150),math.rad(-180),-20.5)
			    LegWeld.Parent = Handle
	  		end
		end

	else
		if Handle.Parent then 
	  		Handle.Parent:Destroy()
	 	endend
	
end