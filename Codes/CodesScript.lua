local textBox = script.Parent

local code = "Secret Code 123"

local codeRedeemed = script.Parent.CodeRedeemed

local success = script.Parent.SuccessAudio
local invalid = script.Parent.ErrorAudio
 
textBox.FocusLost:Connect(function(entered, input)
	
	if not entered then return end
	
	local codeEntered = textBox.Text
	
	
	if codeEntered == code then
		
		if codeRedeemed.Value == false then			
			
			codeRedeemed.Value = true
		
			textBox.Text = "Code successfully redeemed!"
			success:Play()
			
			local reward = game.ReplicatedStorage.ClassicSword:Clone()
			reward.Parent = game.Players.LocalPlayer.Backpack
			
		else
			
			textBox.Text = "Already redeemed!"
			invalid:Play()	
		end
		
	else
		
		textBox.Text = "Invalid code!"
		invalid:Play()			
	end	
end)