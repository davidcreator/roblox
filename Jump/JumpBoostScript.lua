local Sword = script.Parent.Parent


function Equipped()
	
	local Player = Sword.Parent
	
	Player.Humanoid.JumpPower = 200		
end


function Unequipped()
	
	local Player = game.Players.LocalPlayer.Name
	
	game.Workspace:FindFirstChild(Player).Humanoid.JumpPower = 50	
end


Sword.Equipped:connect(Equipped)

Sword.Unequipped:connect(Unequipped)