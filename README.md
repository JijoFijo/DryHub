    local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

--change these if you'd like
local title = "this is a title" --with "catargory =" you can change it to smth like "emote" or anything rlly
local presetAnimations = {
	R6 = {
		{
			name = "Dance1",
			id = "rbxassetid://182491065",
			category = "this is an example"
		},
		{
			name = "Dance2",
			id = "rbxassetid://182436842",
			category = title
		},
		{
			name = "Dance3",
			id = "rbxassetid://182491423",
			category = title
		},
		{
			name = "Laugh",
			id = "rbxassetid://129423131",
			category = title
		},
		{
			name = "Zesty Pose",
			id = "rbxassetid://106772613",
			category = title
		},
		{
			name = "Sit",
			id = "rbxassetid://179224234",
			category = title
		},
		{
			name = "differ walk anim",
			id = "rbxassetid://28440069",
			category = title
		},
		{
			name = "zombie arms",
			id = "rbxassetid://79419402",
			category = title
		},
		{
			name = "rahh",
			id = "rbxassetid://93648331",
			category = title
		},
		{
			name = "punches",
			id = "rbxassetid://126753849",
			category = title
		},
		{
			name = "tilting",
			id = "rbxassetid://136799807",
			category = title
		},
		{
			name = "throwing",
			id = "rbxassetid://57862093",
			category = title
		},
	},
	R15 = {
		{
			name = "Idol",
			id = "rbxassetid://507766666",
			category = "this is an example"
		},
		{
			name = "Running",
			id = "rbxassetid://507767714",
			category = title
		},
		{
			name = "Jump",
			id = "rbxassetid://507765000",
			category = title
		},
		{
			name = "Dance",
			id = "rbxassetid://507771019",
			category = title
		}
	}
}

local loggedR6Animations = {}
local loggedR15Animations = {}
local isDraggingGUI = false
local isDraggingSlider = false
local isDraggingTimeSlider = false
local currentAnimTrack = nil
local previewDelay = 0.5
local previewDelayTimer = nil

local function createInstance(className, properties)
	local instance = Instance.new(className)
	for k, v in pairs(properties) do
		instance[k] = v
	end
	return instance
end

local ScreenGui = createInstance("ScreenGui", {
	Name = "AnimationLogger",
	Parent = LocalPlayer:WaitForChild("PlayerGui")
})

local PreviewFrame = createInstance("ViewportFrame", {
	Name = "PreviewFrame",
	Size = UDim2.new(0, 150, 0, 150),
	BackgroundColor3 = Color3.fromRGB(35, 35, 35),
	BorderSizePixel = 1,
	Visible = false,
	ZIndex = 20,
	Parent = ScreenGui
})

local PreviewCamera = Instance.new("Camera")
PreviewFrame.CurrentCamera = PreviewCamera
PreviewCamera.Parent = PreviewFrame

local MainFrame = createInstance("Frame", {
	Name = "MainFrame",
	Size = UDim2.new(0, 400, 0, 450),
	Position = UDim2.new(0.5, -200, 0.5, -225),
	BackgroundColor3 = Color3.fromRGB(45, 45, 45),
	BorderSizePixel = 0,
	Parent = ScreenGui
})

local TitleBar = createInstance("Frame", {
	Name = "TitleBar",
	Size = UDim2.new(1, 0, 0, 30),
	BackgroundColor3 = Color3.fromRGB(35, 35, 35),
	BorderSizePixel = 0,
	Parent = MainFrame
})

local Title = createInstance("TextLabel", {
	Size = UDim2.new(1, -90, 1, 0),
	Position = UDim2.new(0, 10, 0, 0),
	BackgroundTransparency = 1,
	Text = "Animation Logger",
	TextColor3 = Color3.fromRGB(255, 255, 255),
	TextSize = 18,
	Font = Enum.Font.SourceSansBold,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = TitleBar
})

local CloseButton = createInstance("TextButton", {
	Size = UDim2.new(0, 30, 0, 30),
	Position = UDim2.new(1, -30, 0, 0),
	BackgroundColor3 = Color3.fromRGB(255, 0, 0),
	Text = "X",
	TextColor3 = Color3.fromRGB(255, 255, 255),
	TextSize = 18,
	Font = Enum.Font.SourceSansBold,
	Parent = TitleBar
})

local TabButtons = createInstance("Frame", {
	Size = UDim2.new(1, 0, 0, 40),
	Position = UDim2.new(0, 0, 0, 30),
	BackgroundColor3 = Color3.fromRGB(35, 35, 35),
	BorderSizePixel = 0,
	Parent = MainFrame
})

local LoggerTab = createInstance("TextButton", {
	Size = UDim2.new(1/3, 0, 1, 0),
	BackgroundColor3 = Color3.fromRGB(55, 55, 55),
	Text = "Animation Logger",
	TextColor3 = Color3.fromRGB(255, 255, 255),
	TextSize = 16,
	Font = Enum.Font.SourceSansBold,
	Parent = TabButtons
})

local PresetTab = createInstance("TextButton", {
	Size = UDim2.new(1/3, 0, 1, 0),
	Position = UDim2.new(1/3, 0, 0, 0),
	BackgroundColor3 = Color3.fromRGB(45, 45, 45),
	Text = "Preset Animations",
	TextColor3 = Color3.fromRGB(255, 255, 255),
	TextSize = 16,
	Font = Enum.Font.SourceSansBold,
	Parent = TabButtons
})

local AdjusterTab = createInstance("TextButton", {
	Size = UDim2.new(1/3, 0, 1, 0),
	Position = UDim2.new(2/3, 0, 0, 0),
	BackgroundColor3 = Color3.fromRGB(45, 45, 45),
	Text = "Animation Adjuster",
	TextColor3 = Color3.fromRGB(255, 255, 255),
	TextSize = 16,
	Font = Enum.Font.SourceSansBold,
	Parent = TabButtons
})

local AdjusterFrame = createInstance("Frame", {
	Size = UDim2.new(1, -20, 1, -80),
	Position = UDim2.new(0, 10, 0, 75),
	BackgroundColor3 = Color3.fromRGB(35, 35, 35),
	BorderSizePixel = 0,
	Name = "this",
	Visible = false,
	Parent = MainFrame
})

local PresetFrame = createInstance("Frame", {
	Size = UDim2.new(1, -20, 1, -80),
	Position = UDim2.new(0, 10, 0, 75),
	BackgroundColor3 = Color3.fromRGB(35, 35, 35),
	BorderSizePixel = 0,
	Visible = false,
	Parent = MainFrame
})

local PresetToggleFrame = createInstance("Frame", {
	Size = UDim2.new(1, 0, 0, 30),
	BackgroundColor3 = Color3.fromRGB(45, 45, 45),
	BorderSizePixel = 0,
	Parent = PresetFrame
})

local R6LoggerFrame = createInstance("ScrollingFrame", {
	Name = "R6LoggerFrame",
	Size = UDim2.new(1, -20, 0.45, -40),
	Position = UDim2.new(0, 10, 0, 100),
	BackgroundColor3 = Color3.fromRGB(35, 35, 35),
	BorderSizePixel = 0,
	ScrollBarThickness = 6,
	Visible = true,
	Parent = MainFrame
})

local R6Label = createInstance("TextLabel", {
	Size = UDim2.new(0.4, -20, 0, 20),
	Position = UDim2.new(0, 10, 0, 80),
	BackgroundTransparency = 1,
	Text = "R6 Animations",
	TextColor3 = Color3.fromRGB(255, 255, 255),
	TextSize = 16,
	Font = Enum.Font.SourceSansBold,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = MainFrame
})

local R6PresetButton = createInstance("TextButton", {
	Size = UDim2.new(0.5, 0, 1, 0),
	BackgroundColor3 = Color3.fromRGB(55, 55, 55),
	Text = "R6 Animations",
	TextColor3 = Color3.fromRGB(255, 255, 255),
	TextSize = 14,
	Font = Enum.Font.SourceSansBold,
	Parent = PresetToggleFrame
})

local R15LoggerFrame = createInstance("ScrollingFrame", {
	Name = "R15LoggerFrame",
	Size = UDim2.new(1, -20, 0.45, -40),
	Position = UDim2.new(0, 10, 0.55, 30),
	BackgroundColor3 = Color3.fromRGB(35, 35, 35),
	BorderSizePixel = 0,
	ScrollBarThickness = 6,
	Visible = true,
	Parent = MainFrame
})

local R15Label = createInstance("TextLabel", {
	Size = UDim2.new(1, -20, 0, 20),
	Position = UDim2.new(0, 10, 0.45, 58),
	BackgroundTransparency = 1,
	Text = "R15 Animations",
	TextColor3 = Color3.fromRGB(255, 255, 255),
	TextSize = 16,
	Font = Enum.Font.SourceSansBold,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = MainFrame
})

local R15PresetButton = createInstance("TextButton", {
	Size = UDim2.new(0.5, 0, 1, 0),
	Position = UDim2.new(0.5, 0, 0, 0),
	BackgroundColor3 = Color3.fromRGB(45, 45, 45),
	Text = "R15 Animations",
	TextColor3 = Color3.fromRGB(255, 255, 255),
	TextSize = 14,
	Font = Enum.Font.SourceSansBold,
	Parent = PresetToggleFrame
})

local PresetScrollFrame = createInstance("ScrollingFrame", {
	Size = UDim2.new(1, 0, 1, -35),
	Position = UDim2.new(0, 0, 0, 35),
	BackgroundTransparency = 1,
	ScrollBarThickness = 6,
	Parent = PresetFrame
})

local SearchBar = createInstance("TextBox", {
	Size = UDim2.new(0.5, -20, 0, 20),
	Position = UDim2.new(.5, 10, 0, 75),
	BackgroundColor3 = Color3.fromRGB(35, 35, 35),
	BorderSizePixel = 1,
	PlaceholderText = "Search by player name...",
	Text = "",
	TextColor3 = Color3.fromRGB(255, 255, 255),
	PlaceholderColor3 = Color3.fromRGB(178, 178, 178),
	TextSize = 14,
	Font = Enum.Font.SourceSans,
	ClearTextOnFocus = false,
	Parent = MainFrame
})


local WarningLabel = createInstance("TextLabel", {
	Size = UDim2.new(1, -20, 0, 20),
	Position = UDim2.new(0, 10, 0, 60),
	BackgroundTransparency = 1,
	Text = "",
	TextColor3 = Color3.fromRGB(255, 0, 0),
	TextSize = 14,
	Font = Enum.Font.SourceSansBold,
	TextXAlignment = Enum.TextXAlignment.Left,
	Visible = false,
	Parent = MainFrame
})

local function enableDragging(frame, titleBar)
	local dragStart, startPos = nil, nil
	titleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isDraggingGUI = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if isDraggingGUI and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isDraggingGUI = false
		end
	end)
end

enableDragging(MainFrame, TitleBar)

local function isAnimationCompatible(rigType)
	local character = LocalPlayer.Character
	if character then
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid then
			local localRigType = humanoid.RigType == Enum.HumanoidRigType.R6 and "R6" or "R15"
			return localRigType == rigType
		end
	end
	return false
end

local function showWarning(message)
	WarningLabel.Text = message
	WarningLabel.ZIndex = 20
	WarningLabel.Visible = true
	task.delay(3, function()
		WarningLabel.Visible = false
	end)
end

local function cloneCharacterModel(player)
	local character = player.Character
	if character then
		character.Archivable = true
		local clone = character:Clone()
		for _, child in ipairs(clone:GetChildren()) do
			if child:IsA("LocalScript") then
				child:Destroy()
			end
		end
		return clone
	end
	return nil
end

local function setupPreviewCharacter()
	PreviewFrame.Visible = false
	for _, child in ipairs(PreviewFrame:GetChildren()) do
		if child:IsA("Model") or child:IsA("WorldModel") then
			child:Destroy()
		end
	end
	local worldModel = Instance.new("WorldModel")
	worldModel.Parent = PreviewFrame
	local characterClone = cloneCharacterModel(LocalPlayer)
	if not characterClone then 
		warn("Failed to clone character")
		return nil 
	end
	characterClone.Parent = worldModel
	local hrp = characterClone:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.CFrame = CFrame.new(0, 0, -4) * CFrame.Angles(0, math.rad(180), 0)
	end
	PreviewCamera.CFrame = CFrame.new(Vector3.new(0, 0.5, 0.5), Vector3.new(0, 0.5, 0))
	PreviewFrame.CurrentCamera = PreviewCamera
	PreviewFrame.Visible = true

	return characterClone, worldModel
end

local function updatePreviewPosition()
	local mouseLocation = UserInputService:GetMouseLocation()
	local viewportSize = PreviewFrame.AbsoluteSize
	local screenSize = workspace.CurrentCamera.ViewportSize
	local xOffset = 5
	local yOffset = 5

	if mouseLocation.X + xOffset + viewportSize.X > screenSize.X then
		xOffset = -xOffset - viewportSize.X
	end
	if mouseLocation.Y + yOffset + viewportSize.Y > screenSize.Y then
		yOffset = -yOffset - viewportSize.Y
	end
	PreviewFrame.Position = UDim2.new(0, mouseLocation.X + xOffset, 0, mouseLocation.Y + yOffset)
end

local function createAnimationControls(animation, container)
	local controlsFrame = createInstance("Frame", {
		Size = UDim2.new(1, 0, 0, 180), -- Reduced from 200 to 180
		BackgroundColor3 = Color3.fromRGB(45, 45, 45),
		BorderSizePixel = 1,
		Parent = container
	})
	local nameLabel = createInstance("TextLabel", {
		Size = UDim2.new(1, -20, 0, 20),
		Position = UDim2.new(0, 10, 0, 10),
		BackgroundTransparency = 1,
		Text = "Animation: " .. animation.Name,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 14,
		Font = Enum.Font.SourceSans,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = controlsFrame
	})
	local idLabel = createInstance("TextLabel", {
		Size = UDim2.new(1, -20, 0, 20),
		Position = UDim2.new(0, 10, 0, 30),
		BackgroundTransparency = 1,
		Text = "ID: " .. animation.AnimationId,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 14,
		Font = Enum.Font.SourceSans,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = controlsFrame
	})
	local priorityLabel = createInstance("TextLabel", {
		Size = UDim2.new(0, 80, 0, 20),
		Position = UDim2.new(0, 10, 0, 60),
		BackgroundTransparency = 1,
		Text = "Priority:",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 14,
		Font = Enum.Font.SourceSans,
		Parent = controlsFrame
	})
	local priorityButton = createInstance("TextButton", {
		Size = UDim2.new(0, 120, 0, 25),
		Position = UDim2.new(0, 90, 0, 58),
		BackgroundColor3 = Color3.fromRGB(65, 65, 65),
		Text = "Core",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 14,
		Font = Enum.Font.SourceSans,
		Parent = controlsFrame
	})
	local priorityMenu = createInstance("Frame", {
		Size = UDim2.new(0, 120, 0, 75),
		Position = UDim2.new(0, 90, 0, 83),
		BackgroundColor3 = Color3.fromRGB(65, 65, 65),
		Visible = false,
		ZIndex = 2,
		Parent = controlsFrame
	})
	local priorities = {"Core", "Idle", "Movement", "Action"}
	local currentPriority = Enum.AnimationPriority.Core
	for i, priority in ipairs(priorities) do
		local option = createInstance("TextButton", {
			Size = UDim2.new(1, 0, 0, 25),
			Position = UDim2.new(0, 0, 0, (i-1) * 25),
			BackgroundColor3 = Color3.fromRGB(75, 75, 75),
			Text = priority,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 14,
			Font = Enum.Font.SourceSans,
			ZIndex = 2,
			Parent = priorityMenu
		})
		option.MouseButton1Click:Connect(function()
			priorityButton.Text = priority
			currentPriority = Enum.AnimationPriority[priority]
			priorityMenu.Visible = false
		end)
	end
	priorityButton.MouseButton1Click:Connect(function()
		priorityMenu.Visible = not priorityMenu.Visible
	end)
	local playButton = createInstance("TextButton", {
		Size = UDim2.new(0, 80, 0, 30),
		Position = UDim2.new(0, 10, 0, 90),
		BackgroundColor3 = Color3.fromRGB(0, 255, 0),
		Text = "Play",
		TextColor3 = Color3.fromRGB(0, 0, 0),
		TextSize = 14,
		Font = Enum.Font.SourceSansBold,
		Parent = controlsFrame
	})
	local pauseButton = createInstance("TextButton", {
		Size = UDim2.new(0, 80, 0, 30),
		Position = UDim2.new(0, 100, 0, 90),
		BackgroundColor3 = Color3.fromRGB(255, 255, 0),
		Text = "Pause",
		TextColor3 = Color3.fromRGB(0, 0, 0),
		TextSize = 14,
		Font = Enum.Font.SourceSansBold,
		Parent = controlsFrame
	})
	local stopButton = createInstance("TextButton", {
		Size = UDim2.new(0, 80, 0, 30),
		Position = UDim2.new(0, 190, 0, 90),
		BackgroundColor3 = Color3.fromRGB(255, 0, 0),
		Text = "Stop",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 14,
		Font = Enum.Font.SourceSansBold,
		Parent = controlsFrame
	})
	local sliderContainer = createInstance("Frame", {
		Size = UDim2.new(0.7, 0, 0, 30),
		Position = UDim2.new(0, 10, 0, 130),
		BackgroundColor3 = Color3.fromRGB(35, 35, 35),
		BorderSizePixel = 0,
		Parent = controlsFrame
	})
	local sliderBar = createInstance("Frame", {
		Size = UDim2.new(1, 0, 0, 4),
		Position = UDim2.new(0, 0, 0.5, -2),
		BackgroundColor3 = Color3.fromRGB(100, 100, 100),
		BorderSizePixel = 0,
		Parent = sliderContainer
	})
	local sliderKnob = createInstance("Frame", {
		Size = UDim2.new(0, 16, 0, 16),
		Position = UDim2.new(0.5, -8, 0.5, -8),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		Parent = sliderContainer
	})
	local speedLabel = createInstance("TextBox", {
		Size = UDim2.new(0, 50, 0, 20),
		Position = UDim2.new(0.7, 20, 0, 135),
		BackgroundColor3 = Color3.fromRGB(45, 45, 45),
		BorderSizePixel = 1,
		Text = "1.0x",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 14,
		Font = Enum.Font.SourceSans,
		ClearTextOnFocus = true,
		Parent = controlsFrame
	})
	local timeSliderContainer = createInstance("Frame", {
		Size = UDim2.new(0.7, 0, 0, 30),
		Position = UDim2.new(0, 10, 0, 170),
		BackgroundColor3 = Color3.fromRGB(35, 35, 35),
		BorderSizePixel = 0,
		Parent = controlsFrame
	})
	local timeSliderBar = createInstance("Frame", {
		Size = UDim2.new(1, 0, 0, 4),
		Position = UDim2.new(0, 0, 0.5, -2),
		BackgroundColor3 = Color3.fromRGB(100, 100, 100),
		BorderSizePixel = 0,
		Parent = timeSliderContainer
	})
	local timeSliderKnob = createInstance("Frame", {
		Size = UDim2.new(0, 16, 0, 16),
		Position = UDim2.new(0, -8, 0.5, -8),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		Parent = timeSliderContainer
	})
	local timeLabel = createInstance("TextBox", {
		Size = UDim2.new(0, 50, 0, 20),
		Position = UDim2.new(0.7, 20, 0, 175),
		BackgroundColor3 = Color3.fromRGB(45, 45, 45),
		BorderSizePixel = 1,
		Text = "0.0s",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 14,
		Font = Enum.Font.SourceSans,
		ClearTextOnFocus = true,
		Parent = controlsFrame
	})
	local corner = createInstance("UICorner", {
		CornerRadius = UDim.new(1, 0),
		Parent = sliderKnob
	})
	local timeCorner = createInstance("UICorner", {
		CornerRadius = UDim.new(1, 0),
		Parent = timeSliderKnob
	})
	local defaultSpeed = 1
	local currentSpeed = defaultSpeed
	local animTrack
	local isPaused = false
	local function updateSlider(relativeX)
		relativeX = math.clamp(relativeX, 0, 1)
		currentSpeed = 0.1 + relativeX * 1.9
		speedLabel.Text = string.format("%.1fx", currentSpeed)
		sliderKnob.Position = UDim2.new(relativeX, -8, 0.5, -8)
		if animTrack and not isPaused then
			animTrack:AdjustSpeed(currentSpeed)
		end
	end
	local function updateTimeSlider(relativeX)
		if not animTrack then
			warn("Animation track is not initialized.")
			return
		end
		relativeX = math.clamp(relativeX, 0, 1)
		local timePosition = relativeX * animTrack.Length
		timeLabel.Text = string.format("%.1fs", timePosition)
		timeSliderKnob.Position = UDim2.new(relativeX, -8, 0.5, -8)

		if animTrack then
			animTrack.TimePosition = timePosition
		end
	end
	local function updateTimeLabel()
		if animTrack then
			timeLabel.Text = string.format("%.1fs", animTrack.TimePosition)
			local relativeX = animTrack.TimePosition / animTrack.Length
			timeSliderKnob.Position = UDim2.new(relativeX, -8, 0.5, -8)
		end
	end
	local function updateTimeFromInput(newTime)
		local time = tonumber(newTime and newTime:gsub("s", "") or "0")
		if not time then
			if animTrack then
				timeLabel.Text = string.format("%.1fs", animTrack.TimePosition)
			else
				timeLabel.Text = "0.0s"
			end
			return
		end
		if animTrack then
			time = math.clamp(time, 0, animTrack.Length)
			animTrack.TimePosition = time
			timeLabel.Text = string.format("%.1fs", time)
			local relativeX = time / animTrack.Length
			timeSliderKnob.Position = UDim2.new(relativeX, -8, 0.5, -8)
		else
			timeLabel.Text = "0.0s"
		end
	end
	local function updateSpeedFromInput(newSpeed)
		local speed = tonumber(newSpeed)
		if not speed then
			speedLabel.Text = string.format("%.1fx", currentSpeed)
			return
		end
		speed = math.clamp(speed, 0.1, 10)
		currentSpeed = speed
		local relativeX = math.clamp((speed - 0.1) / 1.9, 0, 1)
		sliderKnob.Position = UDim2.new(relativeX, -8, 0.5, -8)
		speedLabel.Text = string.format("%.1fx", speed)
		if animTrack and not isPaused then
			animTrack:AdjustSpeed(speed)
		end
	end
	local function getCurrentSpeedFromLabel()
		local speedText = speedLabel.Text:gsub("x", "")
		local speed = tonumber(speedText)
		return speed or defaultSpeed
	end
	playButton.MouseButton1Click:Connect(function()
		local character = LocalPlayer.Character
		if character and character:FindFirstChild("Humanoid") then
			local animator = character.Humanoid:FindFirstChild("Animator")
			if animator then
				if currentAnimTrack then
					currentAnimTrack:Stop()
				end
				if animTrack then
					animTrack:Stop()
				end
				animTrack = animator:LoadAnimation(animation)
				if animTrack then
					animTrack.Priority = currentPriority
					currentSpeed = getCurrentSpeedFromLabel()
					animTrack:AdjustSpeed(currentSpeed)
					animTrack:Play()
					isPaused = false
					currentAnimTrack = animTrack
				else
					warn("Failed to load animation track.")
				end
			else
				warn("Animator not found in Humanoid.")
			end
		else
			warn("Character or Humanoid not found.")
		end
	end)
	local function setupPreview(button)
		local previewCharacter
		local previewAnimTrack
		button.MouseEnter:Connect(function()
			previewCharacter = setupPreviewCharacter()
			if previewCharacter then
				local humanoid = previewCharacter:FindFirstChild("Humanoid")
				if humanoid and humanoid:FindFirstChild("Animator") then
					previewAnimTrack = humanoid.Animator:LoadAnimation(animation)
					previewAnimTrack:Play()
					PreviewFrame.Visible = true
					local mouseConnection = UserInputService.InputChanged:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseMovement then
							updatePreviewPosition(input.Position.X, input.Position.Y)
						end
					end)
					button.MouseLeave:Connect(function()
						if previewAnimTrack then
							previewAnimTrack:Stop()
							previewAnimTrack:Destroy()
						end
						if previewCharacter then
							previewCharacter:Destroy()
						end
						PreviewFrame.Visible = false
						mouseConnection:Disconnect()
					end)
				end
			end
		end)
	end
	setupPreview(playButton)
	pauseButton.MouseButton1Click:Connect(function()
		if animTrack then
			if isPaused then
				animTrack:AdjustSpeed(currentSpeed)
				isPaused = false
				pauseButton.Text = "Pause"
			else
				animTrack:AdjustSpeed(0)
				isPaused = true
				pauseButton.Text = "Resume"
			end
		end
	end)
	stopButton.MouseButton1Click:Connect(function()
		if animTrack then
			animTrack:Stop()
			isPaused = false
			pauseButton.Text = "Pause"
		end
	end)
	speedLabel.FocusLost:Connect(function(enterPressed)
		local newSpeed = speedLabel.Text:gsub("x", "")
		updateSpeedFromInput(newSpeed)
	end)
	timeLabel.FocusLost:Connect(function(enterPressed)
		local newTime = timeLabel.Text
		updateTimeFromInput(newTime)
	end)
	local isDraggingSlider = false
	local isDraggingTimeSlider = false
	sliderContainer.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isDraggingSlider = true
			local relativeX = (input.Position.X - sliderContainer.AbsolutePosition.X) / sliderContainer.AbsoluteSize.X
			updateSlider(relativeX)
			input:Destroy()
		end
	end)
	timeSliderContainer.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isDraggingTimeSlider = true
			local relativeX = (input.Position.X - timeSliderContainer.AbsolutePosition.X) / timeSliderContainer.AbsoluteSize.X
			updateTimeSlider(relativeX)
			input:Destroy()
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			if isDraggingSlider then
				local relativeX = (input.Position.X - sliderContainer.AbsolutePosition.X) / sliderContainer.AbsoluteSize.X
				updateSlider(relativeX)
			elseif isDraggingTimeSlider then
				local relativeX = (input.Position.X - timeSliderContainer.AbsolutePosition.X) / timeSliderContainer.AbsoluteSize.X
				updateTimeSlider(relativeX)
			end
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isDraggingSlider = false
			isDraggingTimeSlider = false
		end
	end)
	sliderKnob.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isDraggingSlider = true
			input:Destroy()
		end
	end)
	timeSliderKnob.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isDraggingTimeSlider = true
			input:Destroy()
		end
	end)
	RunService.Heartbeat:Connect(function()
		if animTrack and not isDraggingTimeSlider and not isPaused then
			updateTimeLabel()
		end
	end)
	return controlsFrame
end

local function getLocalPlayerRigType()
	local character = LocalPlayer.Character
	if character then
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid then
			return humanoid.RigType == Enum.HumanoidRigType.R6 and "R6" or "R15"
		end
	end
	return nil
end

local function setTabVisibility(tabName)
	R6LoggerFrame.Visible = false
	R15LoggerFrame.Visible = false
	PresetFrame.Visible = false
	AdjusterFrame.Visible = false
	R6Label.Visible = false
	R15Label.Visible = false
	SearchBar.Visible = false
	LoggerTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	PresetTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	AdjusterTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	if tabName == "Logger" then
		R6LoggerFrame.Visible = true
		R15LoggerFrame.Visible = true
		R6Label.Visible = true
		R15Label.Visible = true
		SearchBar.Visible = true
		LoggerTab.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	elseif tabName == "Preset" then
		PresetFrame.Visible = true
		PresetTab.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	elseif tabName == "Adjuster" then
		AdjusterFrame.Visible = true
		AdjusterTab.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
		AdjusterFrame:FindFirstChild("Frame").ZIndex = 0
	end
end

local function updateSearch(searchText)
	searchText = searchText:lower()
	local function updateFrameButtons(frame)
		local visibleCount = 0
		for _, button in ipairs(frame:GetChildren()) do
			if button:IsA("TextButton") then
				local playerName = button:GetAttribute("PlayerName"):lower()
				local isVisible = searchText == "" or playerName:find(searchText, 1, true)
				button.Visible = isVisible
				if isVisible then
					button.Position = UDim2.new(0, 5, 0, visibleCount * 65)
					visibleCount = visibleCount + 1
				end
			end
		end
		return visibleCount
	end
	local r6VisibleCount = updateFrameButtons(R6LoggerFrame)
	local r15VisibleCount = updateFrameButtons(R15LoggerFrame)
	R6LoggerFrame.CanvasSize = UDim2.new(0, 0, 0, r6VisibleCount * 65)
	R15LoggerFrame.CanvasSize = UDim2.new(0, 0, 0, r15VisibleCount * 65)
end

local function createAnimationButton(animation, rigType, container, yPosition, playerName)
	local button = createInstance("TextButton", {
		Size = UDim2.new(1, -10, 0, 60),
		Position = UDim2.new(0, 5, 0, yPosition),
		BackgroundColor3 = Color3.fromRGB(55, 55, 55),
		Text = string.format("Player: %s\nAnimation: %s\nID: %s", playerName or "Unknown", animation.Name, animation.AnimationId),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 14,
		Font = Enum.Font.SourceSans,
		TextWrapped = true,
		Parent = container
	})
	button:SetAttribute("PlayerName", playerName or "Unknown")
	button.MouseButton1Click:Connect(function()
		if not isAnimationCompatible(rigType) then
			local localRigType = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and 
				(LocalPlayer.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "R6" or "R15")
			showWarning(string.format("This is a %s animation. Your character is using %s rig type.", rigType, localRigType or "unknown"))
			return
		end
		for _, child in ipairs(AdjusterFrame:GetChildren()) do
			child:Destroy()
		end
		local controls = createAnimationControls(animation, AdjusterFrame)
		setTabVisibility("Adjuster")
	end)

	local previewCharacter = nil
	local previewAnimTrack = nil
	local mouseConnection = nil
	local updateConnection = nil
	local previewDelayConnection = nil

	local function cleanupPreview()
		if previewAnimTrack then
			previewAnimTrack:Stop()
			previewAnimTrack:Destroy()
			previewAnimTrack = nil
		end
		if mouseConnection then
			mouseConnection:Disconnect()
			mouseConnection = nil
		end
		if updateConnection then
			updateConnection:Disconnect()
			updateConnection = nil
		end
		if previewDelayConnection then
			previewDelayConnection:Disconnect()
			previewDelayConnection = nil
		end
		if previewCharacter then
			local worldModel = previewCharacter.Parent
			if worldModel then
				worldModel:Destroy()
			end
			previewCharacter = nil
		end
		PreviewFrame.Visible = false
	end

	local function startPreview(button, animation, rigType)
		cleanupPreview()
		local startTime = tick()
		previewDelayConnection = RunService.RenderStepped:Connect(function()
			if tick() - startTime >= previewDelay then
				previewDelayConnection:Disconnect()
				previewDelayConnection = nil
				if not isAnimationCompatible(rigType) then return end
				local success, model, world = pcall(function()
					return setupPreviewCharacter()
				end)
				if success and model then
					previewCharacter = model
					local humanoid = model:FindFirstChild("Humanoid")
					if humanoid then
						local animationInstance = Instance.new("Animation")
						animationInstance.AnimationId = animation.AnimationId
						local animator = humanoid:FindFirstChild("Animator") or Instance.new("Animator", humanoid)
						local success2, animTrack = pcall(function()
							return animator:LoadAnimation(animationInstance)
						end)
						if success2 and animTrack then
							previewAnimTrack = animTrack
							animTrack:Play()
							mouseConnection = RunService.RenderStepped:Connect(updatePreviewPosition)
							updateConnection = RunService.Heartbeat:Connect(function()
								if previewAnimTrack and previewAnimTrack.IsPlaying then
									if previewAnimTrack.TimePosition >= previewAnimTrack.Length then
										previewAnimTrack:AdjustSpeed(1)
										previewAnimTrack.TimePosition = 0
									end
								end
							end)
						end
					end
				end
			end
		end)
	end
	button.MouseEnter:Connect(function()
		startPreview(button, animation, rigType)
	end)
	button.MouseLeave:Connect(function()
		cleanupPreview()
	end)

	return button
end

local function createPresetButtons(rigType)
	for _, child in ipairs(PresetScrollFrame:GetChildren()) do
		child:Destroy()
	end
	local animations = presetAnimations[rigType]
	local buttonHeight = 60
	local padding = 5
	local categories = {}
	for _, anim in ipairs(animations) do
		local category = anim.category or title
		if not categories[category] then
			categories[category] = {}
		end
		table.insert(categories[category], anim)
	end
	local sortedCategories = {}
	for category in pairs(categories) do
		table.insert(sortedCategories, category)
	end
	table.sort(sortedCategories)
	local yOffset = 0
	for _, category in ipairs(sortedCategories) do
		local categoryAnimations = categories[category]
		local categoryLabel = createInstance("TextLabel", {
			Size = UDim2.new(1, -10, 0, 30),
			Position = UDim2.new(0, 5, 0, yOffset),
			BackgroundTransparency = 1,
			Text = category,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 16,
			Font = Enum.Font.SourceSansBold,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = PresetScrollFrame
		})
		yOffset = yOffset + 35
		table.sort(categoryAnimations, function(a, b)
			return a.name < b.name
		end)
		for _, anim in ipairs(categoryAnimations) do
			local animation = Instance.new("Animation")
			animation.AnimationId = anim.id
			animation.Name = anim.name

			local button = createInstance("TextButton", {
				Size = UDim2.new(1, -10, 0, buttonHeight),
				Position = UDim2.new(0, 5, 0, yOffset),
				BackgroundColor3 = Color3.fromRGB(55, 55, 55),
				Text = string.format("%s\nID: %s", anim.name, anim.id),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 14,
				Font = Enum.Font.SourceSans,
				TextWrapped = true,
				Parent = PresetScrollFrame
			})
			button.MouseButton1Click:Connect(function()
				if not isAnimationCompatible(rigType) then
					local localRigType = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and 
						(LocalPlayer.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 and "R6" or "R15")
					showWarning(string.format("This is a %s animation. Your character is using %s rig type.", rigType, localRigType or "unknown"))
					return
				end
				for _, child in ipairs(AdjusterFrame:GetChildren()) do
					child:Destroy()
				end
				local controls = createAnimationControls(animation, AdjusterFrame)
				setTabVisibility("Adjuster")
			end)

			local previewCharacter = nil
			local previewAnimTrack = nil
			local mouseConnection = nil
			local updateConnection = nil
			local previewDelayConnection = nil

			local function cleanupPreview()
				if previewAnimTrack then
					previewAnimTrack:Stop()
					previewAnimTrack:Destroy()
					previewAnimTrack = nil
				end
				if mouseConnection then
					mouseConnection:Disconnect()
					mouseConnection = nil
				end
				if updateConnection then
					updateConnection:Disconnect()
					updateConnection = nil
				end
				if previewDelayConnection then
					previewDelayConnection:Disconnect()
					previewDelayConnection = nil
				end
				if previewCharacter then
					local worldModel = previewCharacter.Parent
					if worldModel then
						worldModel:Destroy()
					end
					previewCharacter = nil
				end
				PreviewFrame.Visible = false
			end
			local function startPreview()
				cleanupPreview()
				local startTime = tick()
				previewDelayConnection = RunService.RenderStepped:Connect(function()
					if tick() - startTime >= previewDelay then
						previewDelayConnection:Disconnect()
						previewDelayConnection = nil
						if not isAnimationCompatible(rigType) then return end

						local success, model, world = pcall(function()
							return setupPreviewCharacter()
						end)
						if success and model then
							previewCharacter = model
							local humanoid = model:FindFirstChild("Humanoid")
							if humanoid then
								local animator = humanoid:FindFirstChild("Animator") or Instance.new("Animator", humanoid)
								local success2, animTrack = pcall(function()
									return animator:LoadAnimation(animation)
								end)
								if success2 and animTrack then
									previewAnimTrack = animTrack
									animTrack:Play()
									mouseConnection = RunService.RenderStepped:Connect(updatePreviewPosition)
									updateConnection = RunService.Heartbeat:Connect(function()
										if previewAnimTrack and previewAnimTrack.IsPlaying then
											if previewAnimTrack.TimePosition >= previewAnimTrack.Length then
												previewAnimTrack:AdjustSpeed(1)
												previewAnimTrack.TimePosition = 0
											end
										end
									end)
								end
							end
						end
					end
				end)
			end
			button.MouseEnter:Connect(startPreview)
			button.MouseLeave:Connect(cleanupPreview)
			yOffset = yOffset + buttonHeight + padding
		end
	end
	PresetScrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

R6PresetButton.MouseButton1Click:Connect(function()
	createPresetButtons("R6")
	R6PresetButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	R15PresetButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
end)

R15PresetButton.MouseButton1Click:Connect(function()
	createPresetButtons("R15")
	R6PresetButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	R15PresetButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
end)

LoggerTab.MouseButton1Click:Connect(function()
	setTabVisibility("Logger")
end)

PresetTab.MouseButton1Click:Connect(function()
	setTabVisibility("Preset")
	createPresetButtons("R6")
	R6PresetButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	R15PresetButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
end)

AdjusterTab.MouseButton1Click:Connect(function()
	setTabVisibility("Adjuster")
end)

local function logAnimations()
	for _, player in ipairs(Players:GetPlayers()) do
		local character = player.Character
		if character then
			local humanoid = character:FindFirstChild("Humanoid")
			if humanoid then
				local animator = humanoid:FindFirstChild("Animator")
				if animator then
					for _, animation in ipairs(animator:GetPlayingAnimationTracks()) do
						local animId = animation.Animation.AnimationId
						local rigType = humanoid.RigType == Enum.HumanoidRigType.R6 and "R6" or "R15"
						local loggedAnimations = rigType == "R6" and loggedR6Animations or loggedR15Animations
						local loggerFrame = rigType == "R6" and R6LoggerFrame or R15LoggerFrame

						if not loggedAnimations[animId] then
							loggedAnimations[animId] = animation.Animation
							createAnimationButton(animation.Animation, rigType, loggerFrame, #loggerFrame:GetChildren() * 65, player.Name)  -- Added player.Name
						end
					end
				end
			end
		end
	end

	R6LoggerFrame.CanvasSize = UDim2.new(0, 0, 0, #R6LoggerFrame:GetChildren() * 65)
	R15LoggerFrame.CanvasSize = UDim2.new(0, 0, 0, #R15LoggerFrame:GetChildren() * 65)
end

SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
	updateSearch(SearchBar.Text)
end)

CloseButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

LoggerTab.MouseButton1Click:Connect(function()
	R6LoggerFrame.Visible = true
	R15LoggerFrame.Visible = true
	AdjusterFrame.Visible = false
	LoggerTab.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	AdjusterTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
end)

AdjusterTab.MouseButton1Click:Connect(function()
	R6LoggerFrame.Visible = false
	R15LoggerFrame.Visible = false
	AdjusterFrame.Visible = true
	LoggerTab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	AdjusterTab.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
end)

local function onCharacterAdded(character)
	loggedR6Animations = {}
	loggedR15Animations = {}
	for _, child in ipairs(R6LoggerFrame:GetChildren()) do
		child:Destroy()
	end
	for _, child in ipairs(R15LoggerFrame:GetChildren()) do
		child:Destroy()
	end
	local humanoid = character:WaitForChild("Humanoid")
	humanoid:WaitForChild("Animator")
	RunService.Heartbeat:Connect(logAnimations)
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
if LocalPlayer.Character then
	onCharacterAdded(LocalPlayer.Character)
end
