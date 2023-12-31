-------------------------------SETTINGS-------------------------------

local zoom = 3
local maxZoom = 20
local canScrollToZoom = true
local zoomSpeed = 1/7

local openMapKeys = {Enum.KeyCode.M, Enum.KeyCode.CapsLock}

local displayTeams = true

local markerSize = UDim2.new(0.04, 0, 0.04, 0)

local defaultColor = Color3.fromRGB(115, 115, 115)
local allyColor = Color3.fromRGB(71, 134, 132)
local enemyColor = Color3.fromRGB(116, 59, 59)

----------------------------------------------------------------------


--Variables
local frame = script.Parent:WaitForChild("MinimapClipping")
local map = frame:WaitForChild("MapImage")
local plrPointer = frame:WaitForChild("PlayerPointer")

local uis = game:GetService("UserInputService")
local mapOpen = false

local mapCorners = workspace:WaitForChild("MINIMAP CORNERS")
local corner1, corner2 = mapCorners.Corner1, mapCorners.Corner2

local xLowerBound, zLowerBound = corner1.Position.X, corner1.Position.Z
local xUpperBound, zUpperBound = corner2.Position.X, corner2.Position.Z

local realWidth = xUpperBound - xLowerBound
local realHeight = zUpperBound - zLowerBound

local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local runs = game:GetService("RunService")
local cam = workspace.CurrentCamera

local playerMarkersFolder = Instance.new("Folder")
playerMarkersFolder.Name = "PLAYER MARKERS"
playerMarkersFolder.Parent = map


--Handling markers on the minimap, such as for other players or landmarks on the map
function createMarker(markerName, positionToDisplay, imageToDisplay, colorToDisplay)

	local marker = playerMarkersFolder:FindFirstChild(markerName)
	if not marker then

		marker = Instance.new("ViewportFrame")
		marker.Name = markerName
		marker.BorderSizePixel = 0
		marker.BackgroundTransparency = 1
		marker.Size = markerSize

		local imageDisplay = Instance.new("Part")
		imageDisplay.Shape = Enum.PartType.Cylinder
		imageDisplay.Orientation = Vector3.new(0, -90, 0)
		imageDisplay.Size = Vector3.new(1, 1, 1)
		imageDisplay.Color = colorToDisplay or defaultColor

		local decal = Instance.new("Decal", imageDisplay)
		decal.Face = Enum.NormalId.Right
		decal.Texture = imageToDisplay

		local vpfCamera = Instance.new("Camera")
		vpfCamera.CFrame = imageDisplay.CFrame * CFrame.Angles(0, math.rad(90), 0) + Vector3.new(0, 0, 1.25)

		marker.CurrentCamera = vpfCamera
		vpfCamera.Parent = marker
		imageDisplay.Parent = marker
	end

	local x = positionToDisplay.X - xLowerBound
	local z = positionToDisplay.Z - zLowerBound

	local xScaled = x / realWidth
	local zScaled = z / realHeight

	marker.Position = UDim2.new(xScaled, 0, zScaled, 0)
	marker.Parent = playerMarkersFolder
end

function destroyMarker(markerName)
	local marker = playerMarkersFolder:FindFirstChild(markerName)

	if marker then
		marker:Destroy()
	end
end


runs.Heartbeat:Connect(function()

	--Moving the map
	if not mapOpen then
		frame.Size = UDim2.new(0.168, 0, 0.311, 0)
		frame.Position = UDim2.new(0.015, 0, 0.971, 0)

		map.AnchorPoint = Vector2.new(0.5, 0.5)
		map.Size = UDim2.new(zoom, 0, zoom, 0)

		plrPointer.Size = UDim2.new(0.159, 0, 0.159, 0)

		local guiSize = map.AbsoluteSize

		local plrPos = hrp.Position
		local plrX = xUpperBound - plrPos.X
		local plrZ = zUpperBound - plrPos.Z

		local plrXscaled = plrX / realWidth
		local plrZscaled = plrZ / realHeight

		plrXscaled = ((plrXscaled - 0.5) * zoom) + 0.5
		plrZscaled = ((plrZscaled - 0.5) * zoom) + 0.5

		map.Position = UDim2.new(plrXscaled, 0, plrZscaled, 0)

		plrPointer.Position = UDim2.new(0.5, 0, 0.5, 0)

	else
		frame.Size = UDim2.new(0.259, 0, 0.605, 0)
		frame.Position = UDim2.new(0.37, 0, 0.739, 0)

		map.Size = UDim2.new(1, 0, 1, 0)
		map.Position = UDim2.new(0.5, 0, 0.5, 0)

		plrPointer.Size = UDim2.new(0.08, 0, 0.08, 0)

		local x = hrp.Position.X - xLowerBound
		local z = hrp.Position.Z - zLowerBound

		local xScaled = x / realWidth
		local zScaled = z / realHeight

		plrPointer.Position = UDim2.new(xScaled, 0, zScaled, 0)
	end


	--Rotating the pointer
	plrPointer.AnchorPoint = Vector2.new(0.5, 0.5)

	local plrRot = -hrp.Orientation.Y
	plrPointer.Rotation = plrRot


	--Displaying other players
	for i, plrInGame in pairs(game.Players:GetPlayers()) do

		if plrInGame ~= plr and plrInGame.Character then

			local inGameChar = plrInGame.Character
			local inGameHRP = inGameChar:FindFirstChild("HumanoidRootPart")

			if inGameHRP and inGameChar.Humanoid.Health > 0 then

				local playerImage = game.Players:GetUserThumbnailAsync(plrInGame.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)

				if displayTeams then
					if plr.Team == plrInGame.Team then
						createMarker(plrInGame.Name, inGameHRP.Position, playerImage, allyColor)

					else
						local worldPosition = inGameHRP.Position
						local _, visible = cam:WorldToScreenPoint(worldPosition)

						if visible then

							local rayParams = RaycastParams.new()
							rayParams.FilterType = Enum.RaycastFilterType.Blacklist
							rayParams.FilterDescendantsInstances = {inGameChar, char}
							local rayResult = workspace:Raycast(cam.CFrame.Position, inGameHRP.Position - cam.CFrame.Position, rayParams)
							
							if not rayResult then
								createMarker(plrInGame.Name, inGameHRP.Position, playerImage, enemyColor)
								
							else
								destroyMarker(plrInGame.Name)
							end
						else
							destroyMarker(plrInGame.Name)
						end
					end

				else
					createMarker(plrInGame.Name, inGameHRP.Position, playerImage)
				end
			end
		end
	end
end)

--Detect inputs to expand/minimize the map
uis.InputBegan:Connect(function(input, p)

	if not p and table.find(openMapKeys, input.KeyCode) then
		mapOpen = not mapOpen
	end
end)

--Detect inputs to change the zoom of the map
uis.InputChanged:Connect(function(input, p)

	if canScrollToZoom and input.UserInputType == Enum.UserInputType.MouseWheel then

		local mousePos = uis:GetMouseLocation()
		local hovering = plr.PlayerGui:GetGuiObjectsAtPosition(mousePos.X, mousePos.Y)

		if table.find(hovering, frame) then

			zoom = math.clamp(zoom + (input.Position.Z * zoomSpeed), 1, maxZoom)
		end
	end
end)