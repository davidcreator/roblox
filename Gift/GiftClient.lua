local mps = game:GetService("MarketplaceService")

local frame = script.Parent:WaitForChild("GiftFrame")
frame.Visible = false

local btn = script.Parent:WaitForChild("OpenButton")

btn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)


frame.UserIdBox.FocusLost:Connect(function()

	local userId = tonumber(frame.UserIdBox.Text)

	local icon = game.Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
	if icon then
		frame.GiftedPlayerIcon.Image = icon
	else
		frame.GiftedPlayerIcon.Image = ""
	end
end)


local re = game.ReplicatedStorage:WaitForChild("GiftGamepassReplicatedStorage"):WaitForChild("GiftRE")
local gamepasses = require(game.ReplicatedStorage.GiftGamepassReplicatedStorage:WaitForChild("GiftableGamepasses"))

for i, pass in pairs(gamepasses) do
	local gamepassId = pass[1]
	local productId = pass[2]

	local passInfo = mps:GetProductInfo(gamepassId, Enum.InfoType.GamePass)
	local name = passInfo.Name
	local desc = passInfo.Description
	local price = passInfo.PriceInRobux .. "R$"
	local image = passInfo.IconImageAssetId

	local newFrame = script.GamepassFrame:Clone()
	newFrame.GamepassName.Text = name
	newFrame.GamepassDescription.Text = desc
	newFrame.GamepassPrice.Text = price
	newFrame.GamepassImage.Image = "rbxassetid://" .. image

	newFrame.GiftButton.MouseButton1Click:Connect(function()
		local userId = frame.UserIdBox.Text

		re:FireServer(pass, userId)
	end)

	newFrame.Parent = frame.GamepassList
end