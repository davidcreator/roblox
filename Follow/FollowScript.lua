function findNearestPlayer(Position)
	wait(0.3)
 	local List = game.Workspace:children()
 	local Torso = nil
 	local Distance = 30
 	local Temp = nil
 	local Human = nil
 	local Temp2 = nil
 	for x = 1, #List do
  		Temp2 = List[x]
  		if (Temp2.className == "Model") and (Temp2 ~= script.Parent) then
   			Temp = Temp2:findFirstChild("HumanoidRootPart")
   			Human = Temp2:findFirstChild("Humanoid")
   			if (Temp ~= nil) and (Human ~= nil) and (Human.Health > 0) then
    			if (Temp.Position - Position).magnitude < Distance then
     				Torso = Temp
     				Distance = (Temp.Position - Position).magnitude
    			end
   			end
 		end
 	end
	return Torso
end




while true do
 	local target = findNearestPlayer(script.Parent.HumanoidRootPart.Position)
 	if target ~= nil then
  		script.Parent.Humanoid:MoveTo(target.Position, target)
	end
end