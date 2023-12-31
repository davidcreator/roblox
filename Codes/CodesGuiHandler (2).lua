local open = script.Parent:WaitForChild("OpenButtonBase"):WaitForChild("OpenButtonBack"):WaitForChild("OpenButton")
open.Visible = true
local frame = script.Parent:WaitForChild("CodeFrame")
frame.Visible = false
local close = frame:WaitForChild("CloseButtonBack"):WaitForChild("CloseButton")
local succ = frame:WaitForChild("Success")
succ.Text = ""
local redeem = frame:WaitForChild("RedeemFrame"):WaitForChild("RedeemButtonBack"):WaitForChild("RedeemButton")
local enterCode = frame:WaitForChild("CodeBox")

local rs = game:GetService("ReplicatedStorage"):WaitForChild("CodesReplicatedStorage")
local re = rs:WaitForChild("RemoteEvent")
local codes = require(rs:WaitForChild("CodesModule"))

local fireServerDebounce = false

local messageCode = 0


function success(message)
	succ.Text = message
	succ.TextColor3 = Color3.fromRGB(43, 247, 77)
	
	local generatedCode = math.random(0, 1000000)
	messageCode = generatedCode
	
	task.wait(2)
	if (generatedCode == messageCode) then
		succ.Text = ""
	end
end
function err(message)
	succ.Text = message
	succ.TextColor3 = Color3.fromRGB(235, 43, 43)
	
	local generatedCode = math.random(0, 1000000)
	messageCode = generatedCode
	
	task.wait(2)
	if (generatedCode == messageCode) then
		succ.Text = ""
	end
end


redeem.MouseButton1Click:Connect(function()
	
	local enteredCode = enterCode.Text
	if string.len(enteredCode) > 0 then
		
		local codeInfo = codes[enteredCode]
		
		if not codeInfo then
			err("Code not found!")
			
		else
			if (codeInfo.expiresAt and os.time() > codeInfo.expiresAt) then
				err("Code has expired!")
				
			else
				if (not codeInfo.repeatable and game.Players.LocalPlayer["REDEEMED CODES"]:FindFirstChild(enteredCode)) then
					err("Already redeemed!")
					
				else
					if not fireServerDebounce then
						fireServerDebounce = true
						
						re:FireServer("REDEEM CODE", enteredCode)
						task.wait(1)
						
						fireServerDebounce = false
					end
				end
			end
		end
		
	else
		err("Enter a code!")
	end
end)


re.OnClientEvent:Connect(function(instruction, value)
	if (instruction == "SUCCESS") then
		success(value)
	elseif (instruction == "ERROR") then
		err(value)
	end
end)


--Effects (animations + sounds)
local ts = game:GetService("TweenService")

local hoverSound = script.Parent:WaitForChild("Sounds"):WaitForChild("Hover")
local clickSound = script.Parent:WaitForChild("Sounds"):WaitForChild("Click")

local inQuartTI = TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
local outBounceTI = TweenInfo.new(0.1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)


function mouseEnter(button, originalPos, offset)
	hoverSound:Play()
	ts:Create(button, inQuartTI, {Position = originalPos + offset, ImageColor3 = Color3.fromRGB(244, 244, 244), BackgroundColor3 = Color3.fromRGB(244, 244, 244)}):Play()
end
function mouseLeave(button, originalPos)
	ts:Create(button, inQuartTI, {Position = originalPos, ImageColor3 = Color3.fromRGB(255, 255, 255), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end
function mouseButton1Down(button, originalPos, offset)
	ts:Create(button, inQuartTI, {Position = originalPos + offset, ImageColor3 = Color3.fromRGB(230, 230, 230), BackgroundColor3 = Color3.fromRGB(230, 230, 230)}):Play()
end
function mouseButton1Up(button, originalPos, offset)
	clickSound:Play()
	ts:Create(button, outBounceTI, {Position = originalPos + offset, ImageColor3 = Color3.fromRGB(244, 244, 244), BackgroundColor3 = Color3.fromRGB(244, 244, 244)}):Play()
end


local openPos = open.Position
open.MouseEnter:Connect(function()
	mouseEnter(open, openPos, UDim2.new(0, 0, -0.02, 0))
end)
open.MouseLeave:Connect(function()
	mouseLeave(open, openPos)
end)
open.MouseButton1Down:Connect(function()
	mouseButton1Down(open, openPos, UDim2.new(0, 0, 0.03, 0))
end)
open.MouseButton1Up:Connect(function()
	mouseButton1Up(open, openPos, UDim2.new(0, 0, -0.02, 0))
end)

local closePos = close.Position
close.MouseEnter:Connect(function()
	mouseEnter(close, closePos, UDim2.new(0.045, 0, -0.044, 0))
end)
close.MouseLeave:Connect(function()
	mouseLeave(close, closePos)
end)
close.MouseButton1Down:Connect(function()
	mouseButton1Down(close, closePos, UDim2.new(-0.072, 0, 0.034, 0))
end)
close.MouseButton1Up:Connect(function()
	mouseButton1Up(close, closePos, UDim2.new(0.045, 0, -0.044, 0))
end)

local redeemPos = redeem.Position
redeem.MouseEnter:Connect(function()
	mouseEnter(redeem, redeemPos, UDim2.new(0, 0, 0.06, 0))
end)
redeem.MouseLeave:Connect(function()
	mouseLeave(redeem, redeemPos)
end)
redeem.MouseButton1Down:Connect(function()
	mouseButton1Down(redeem, redeemPos, UDim2.new(0, 0, -0.08, 0))
end)
redeem.MouseButton1Up:Connect(function()
	mouseButton1Up(redeem, redeemPos, UDim2.new(0, 0, 0.06, 0))
end)

local enterPos = enterCode.Position
local enterSize = enterCode.Size
local enterH, enterS, enterV = enterCode.BackgroundColor3:ToHSV()
enterCode.MouseEnter:Connect(function()
	hoverSound:Play()
	ts:Create(enterCode, inQuartTI, {Size = UDim2.new(enterSize.X.Scale * 1.02, 0, enterSize.Y.Scale * 1.02, 0), Position = enterPos + UDim2.new(0, 0, -0.01, 0), BackgroundColor3 = Color3.fromHSV(enterH, enterS, enterV + 0.15)}):Play()
end)
enterCode.MouseLeave:Connect(function()
	ts:Create(enterCode, inQuartTI, {Size = enterSize, Position = enterPos, BackgroundColor3 = Color3.fromHSV(enterH, enterS, enterV)}):Play()
end)


local openFrameTI = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local closeFrameTI = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
local bounceTI = TweenInfo.new(0.6, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)

local isOpen = false
local openSequenceHappening = false

function openFrame()
	frame.Size = UDim2.new(0, 0, 0, 0)
	frame.Position = UDim2.new(0.5, 0, 0.9, 0)
	ts:Create(frame, openFrameTI, {Size = UDim2.new(0.337, 0, 0.492, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
	enterCode.Size = UDim2.new(0.46, 0, 0.161, 0)
	ts:Create(enterCode, openFrameTI, {Size = UDim2.new(0.724, 0, 0.161, 0)}):Play()
	
	task.wait(0.1)
	frame.Visible = true
	
	close.Position = closePos + UDim2.new(-0.072, 0, 0.034, 0)
	redeem.Position = redeemPos + UDim2.new(0, 0, -0.08, 0)
	ts:Create(close, bounceTI, {Position = closePos}):Play()
	ts:Create(redeem, bounceTI, {Position = redeemPos}):Play()
	
	task.wait(0.6)
end

function closeFrame()
	
	ts:Create(frame, closeFrameTI, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.9, 0)}):Play()
	ts:Create(enterCode, closeFrameTI, {Size = UDim2.new(0.46, 0, 0.161, 0)}):Play()
	
	task.wait(0.25)
	frame.Visible = false
end

open.MouseButton1Click:Connect(function()
	
	if not openSequenceHappening then
		isOpen = not isOpen
		openSequenceHappening = true
		
		if isOpen then
			openFrame()
		else
			closeFrame()
		end
		
		openSequenceHappening = false
	end
end)

close.MouseButton1Click:Connect(function()
	
	if not openSequenceHappening then
		isOpen = false
		openSequenceHappening = true
		
		closeFrame()
		
		openSequenceHappening = false
	end
end)