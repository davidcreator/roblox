game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)


local msg1 = script.Parent:WaitForChild("MessageBox1")
local msg2 = script.Parent:WaitForChild("MessageBox2")
local msg3 = script.Parent:WaitForChild("MessageBox3")
local msg4 = script.Parent:WaitForChild("MessageBox4")
local msg5 = script.Parent:WaitForChild("MessageBox5")
local msg6 = script.Parent:WaitForChild("MessageBox6")
local msg7 = script.Parent:WaitForChild("MessageBox7")
local msg8 = script.Parent:WaitForChild("MessageBox8")
local msg9 = script.Parent:WaitForChild("MessageBox9")
local msg10 = script.Parent:WaitForChild("MessageBox10")
local msg11 = script.Parent:WaitForChild("MessageBox11")
local msg12 = script.Parent:WaitForChild("MessageBox12")
local msg13 = script.Parent:WaitForChild("MessageBox13")
local msg14 = script.Parent:WaitForChild("MessageBox14")



game.ReplicatedStorage.MessageContainer.ChildAdded:Connect(function(str)
	
	
	msg1.Text = msg2.Text
	msg2.Text = msg3.Text
	msg3.Text = msg4.Text
	msg4.Text = msg5.Text
	msg5.Text = msg6.Text
	msg6.Text = msg7.Text
	msg7.Text = msg8.Text
	msg8.Text = msg9.Text
	msg9.Text = msg10.Text
	msg10.Text = msg11.Text
	msg11.Text = msg12.Text
	msg12.Text = msg13.Text
	msg13.Text = msg14.Text
	msg14.Text = str.Value
end)