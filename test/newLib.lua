local env = getgenv()
local Themes = {}
local Colors = {}
local Custom = {}

Themes["Speed Hub X"] = {
	Primary = Color3.fromRGB(15, 15, 15),
	Secondary = Color3.fromRGB(30, 30, 30),
	Accent = Color3.fromRGB(250, 7, 7),
	ThemeHighlight = Color3.fromRGB(255, 0, 0),
	Text = Color3.fromRGB(255, 255, 255),
	TextSecondary = Color3.fromRGB(231, 231, 231),
	Background = Color3.fromRGB(20, 20, 20),
	Stroke = Color3.fromRGB(50, 50, 50),
	GradientStart = Color3.fromRGB(45, 45, 45),
	GradientEnd = Color3.fromRGB(50, 50, 50),
}
Themes["Red"] = {
	Primary = Color3.fromRGB(60, 20, 20),
	Secondary = Color3.fromRGB(90, 40, 40),
	Accent = Color3.fromRGB(220, 60, 60),
	ThemeHighlight = Color3.fromRGB(250, 100, 100),
	Text = Color3.fromRGB(250, 230, 230),
	Background = Color3.fromRGB(20, 5, 5),
	Stroke = Color3.fromRGB(120, 40, 40),
	GradientStart = Color3.fromRGB(45, 25, 25),
	GradientEnd = Color3.fromRGB(50, 25, 25),
}
Themes["Green"] = {
	Primary = Color3.fromRGB(20, 40, 20),
	Secondary = Color3.fromRGB(40, 70, 40),
	Accent = Color3.fromRGB(80, 160, 80),
	ThemeHighlight = Color3.fromRGB(160, 250, 160),
	Text = Color3.fromRGB(230, 250, 230),
	Background = Color3.fromRGB(5, 15, 5),
	Stroke = Color3.fromRGB(40, 80, 40),
	GradientStart = Color3.fromRGB(25, 45, 25),
	GradientEnd = Color3.fromRGB(10, 30, 10),
}
Themes["Blue"] = {
	Primary = Color3.fromRGB(20, 30, 60),
	Secondary = Color3.fromRGB(40, 50, 90),
	Accent = Color3.fromRGB(60, 120, 220),
	ThemeHighlight = Color3.fromRGB(100, 170, 250),
	Text = Color3.fromRGB(230, 240, 250),
	Background = Color3.fromRGB(5, 10, 20),
	Stroke = Color3.fromRGB(40, 60, 120),
	GradientStart = Color3.fromRGB(25, 30, 45),
	GradientEnd = Color3.fromRGB(10, 25, 50),
}
Themes["Purple"] = {
	Primary = Color3.fromRGB(40, 20, 60),
	Secondary = Color3.fromRGB(70, 40, 90),
	Accent = Color3.fromRGB(160, 80, 220),
	ThemeHighlight = Color3.fromRGB(200, 160, 250),
	Text = Color3.fromRGB(240, 230, 250),
	Background = Color3.fromRGB(15, 5, 20),
	Stroke = Color3.fromRGB(80, 40, 120),
	GradientStart = Color3.fromRGB(30, 20, 45),
	GradientEnd = Color3.fromRGB(25, 10, 50),
}
Themes["Pink"] = {
	Primary = Color3.fromRGB(50, 15, 30),
	Secondary = Color3.fromRGB(90, 30, 60),
	Accent = Color3.fromRGB(220, 60, 150),
	ThemeHighlight = Color3.fromRGB(250, 100, 180),
	Text = Color3.fromRGB(250, 230, 240),
	Background = Color3.fromRGB(10, 5, 8),
	Stroke = Color3.fromRGB(120, 40, 80),
	GradientStart = Color3.fromRGB(45, 20, 35),
	GradientEnd = Color3.fromRGB(30, 10, 25),
}
Themes["Black"] = {
	Primary = Color3.fromRGB(15, 15, 15),
	Secondary = Color3.fromRGB(30, 30, 30),
	Accent = Color3.fromRGB(80, 80, 80),
	ThemeHighlight = Color3.fromRGB(160, 160, 160),
	Text = Color3.fromRGB(230, 230, 230),
	Background = Color3.fromRGB(0, 0, 0),
	Stroke = Color3.fromRGB(50, 50, 50),
	GradientStart = Color3.fromRGB(20, 20, 20),
	GradientEnd = Color3.fromRGB(5, 5, 5),
}
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
if env.Theme and env.Theme ~= "" then
	Colors = Themes[env.Theme]
else
	Colors = Themes["Speed Hub X"]
end
local function applyhover(button, defaultTransparency)
	button.MouseEnter:Connect(function()
		TweenService:Create(
			button,
			TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ BackgroundTransparency = 0.9 }
		):Play()

		local UIStroke = button:FindFirstChild("UIStroke")
		if UIStroke then
			TweenService
				:Create(
					UIStroke,
					TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{ Transparency = 0 }
				)
				:Play()
		end
	end)

	button.MouseLeave:Connect(function()
		TweenService:Create(
			button,
			TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ BackgroundTransparency = defaultTransparency }
		):Play()

		local UIStroke = button:FindFirstChild("UIStroke")
		if UIStroke then
			TweenService:Create(
				UIStroke,
				TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ Transparency = 0.9 }
			):Play()
		end
	end)
end

do
	function Custom:Create(Name, Properties, Parent)
		local _instance = Instance.new(Name)

		local defaultTransparency = Properties.BackgroundTransparency

		for i, v in pairs(Properties) do
			if i == "Gradient" and Name == "UIGradient" then
				local colorSequence = ColorSequence.new({
					ColorSequenceKeypoint.new(0, v.StartColor),
					ColorSequenceKeypoint.new(1, v.EndColor),
				})
				_instance.Color = colorSequence
				_instance.Rotation = v.Rotation or 0
			else
				_instance[i] = v
			end
		end

		if Parent then
			_instance.Parent = Parent
		end

		if Name == "TextButton" then
			applyhover(_instance, defaultTransparency)
		end

		return _instance
	end

	function Custom:EnabledAFK()
		Player.Idled:Connect(function()
			VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
			task.wait(1)
			VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
		end)
	end

	function Custom:GenNumber(Num)
		local List = {}

		for _ = 1, Num do
			table.insert(List, math.random(0, 9))
		end

		return table.concat(List)
	end

	function Custom:Decryption(Enc)
		local List = {}

		for num in string.gmatch(Enc, "[^,]+") do
			local Ori = tonumber(num) - 24 * 9e9
			table.insert(List, Ori)
		end

		return tonumber(table.concat(List))
	end
end

Custom:EnabledAFK()

local function OpenClose()
	local ScreenGui = Custom:Create(
		"ScreenGui",
		{
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		},
		RunService:IsStudio() and Player.PlayerGui
			or (gethui() or cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui"))
	)

	local Close_ImageButton = Custom:Create("ImageButton", {
		BackgroundColor3 = Colors.Background,
		BorderColor3 = Colors.ThemeHighlight,
		Position = UDim2.new(0.1021, 0, 0.0743, 0),
		Size = UDim2.new(0, 59, 0, 49),
		Image = "",
		Visible = false,
	}, ScreenGui)

	local UICorner = Custom:Create("UICorner", {
		Name = "MainCorner",
		CornerRadius = UDim.new(0, 9),
	}, Close_ImageButton)

	local dragging, dragStart, startPos = false, nil, nil

	local function UpdateDraggable(input)
		local delta = input.Position - dragStart
		Close_ImageButton.Position =
			UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	Close_ImageButton.InputBegan:Connect(function(input)
		if
			input.UserInputType == Enum.UserInputType.Touch
			or input.UserInputType == Enum.UserInputType.MouseButton1
		then
			dragging = true
			dragStart = input.Position
			startPos = Close_ImageButton.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if
			dragging
			and (
				input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch
			)
		then
			UpdateDraggable(input)
		end
	end)

	return Close_ImageButton
end

local Open_Close = OpenClose()

local function MakeDraggable(topbarobject, object)
	local dragging, dragStart, startPos = false, nil, nil

	local function UpdatePos(input)
		local delta = input.Position - dragStart
		local newPos =
			UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		object.Position = newPos
	end

	topbarobject.InputBegan:Connect(function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			dragging = true
			dragStart = input.Position
			startPos = object.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if
			dragging
			and (
				input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch
			)
		then
			UpdatePos(input)
		end
	end)
end

function CircleClick(Button, X, Y)
	task.spawn(function()
		Button.ClipsDescendants = true

		local Circle = Instance.new("ImageLabel")
		Circle.Image = ""
		Circle.ImageColor3 = Colors.ThemeHighlight
		Circle.ImageTransparency = 0.8999999761581421
		Circle.BackgroundColor3 = Colors.ThemeHighlight
		Circle.BackgroundTransparency = 1
		Circle.ZIndex = 10
		Circle.Name = "Circle"
		Circle.Parent = Button

		local NewX = X - Button.AbsolutePosition.X
		local NewY = Y - Button.AbsolutePosition.Y
		Circle.Position = UDim2.new(0, NewX, 0, NewY)

		local Size = math.max(Button.AbsoluteSize.X, Button.AbsoluteSize.Y) * 1.5

		local Time = 0.5
		local TweenInfo = TweenInfo.new(Time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		local Tween = TweenService:Create(Circle, TweenInfo, {
			Size = UDim2.new(0, Size, 0, Size),
			Position = UDim2.new(0.5, -Size / 2, 0.5, -Size / 2),
		})

		Tween:Play()

		Tween.Completed:Connect(function()
			for i = 1, 10 do
				Circle.ImageTransparency = Circle.ImageTransparency + 0.01
				task.wait(Time / 10)
			end
			Circle:Destroy()
		end)
	end)
end

local Speed_Library = {}

Speed_Library.Unloaded = false

local NotificationGui = Custom:Create(
	"ScreenGui",
	{
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	},
	RunService:IsStudio() and Player.PlayerGui
		or (gethui() or cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui"))
)

local NotificationLayout = Custom:Create("Frame", {
	AnchorPoint = Vector2.new(1, 1),
	BackgroundColor3 = Colors.Background,
	BackgroundTransparency = 0.999,
	BorderColor3 = Colors.Stroke,
	BorderSizePixel = 0,
	Position = UDim2.new(1, -30, 1, -30),
	Size = UDim2.new(0, 320, 1, 0),
	Name = "NotificationLayout",
}, NotificationGui)

NotificationLayout.ChildRemoved:Connect(function()
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
	local CurrentY = 0
	for _, v in ipairs(NotificationLayout:GetChildren()) do
		local NewPOS = UDim2.new(0, 0, 1, -(CurrentY + v.Size.Y.Offset))
		local tween = TweenService:Create(v, tweenInfo, { Position = NewPOS })
		tween:Play()
		CurrentY += v.Size.Y.Offset + 12
	end
end)

Speed_Library.closingNotifications = 0

function Speed_Library:SetNotification(Config)
	while Speed_Library.closingNotifications > 0 do
		task.wait()
	end

	local Notification = {}
	local Title = Config.Title or ""
	local Description = Config.Description or ""
	local Content = Config.Content or ""
	local Time = Config.Time or 0.5
	local Delay = Config.Delay or 5
	local CloseButtonImage = Config.CloseButtonImage or ""
	local CallbackCloseButton = Config.CallbackCloseButton or function() end
	local HeightNotify = 135

	local _Count = 0
	for _, v in ipairs(NotificationLayout:GetChildren()) do
		if v:IsA("Frame") then
			_Count += v.Size.Y.Offset + 12
		end
	end

	local NotificationFrame = Custom:Create("Frame", {
		BackgroundColor3 = Colors.Background,
		BorderColor3 = Colors.Stroke,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, HeightNotify),
		Name = "NotificationFrame",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, -_Count),
		ClipsDescendants = false,
	}, NotificationLayout)

	local NotificationFrameReal = Custom:Create("Frame", {
		BackgroundColor3 = Colors.Primary,
		BorderColor3 = Colors.Stroke,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 400, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		Name = "NotificationFrameReal",
		ClipsDescendants = true,
	}, NotificationFrame)

	Custom:Create("UICorner", {
		CornerRadius = UDim.new(0, 8),
	}, NotificationFrameReal)

	Custom:Create("UIStroke", {
		Color = Colors.Stroke,
		Thickness = 1.2,
	}, NotificationFrameReal)

	local DropShadowHolder = Custom:Create("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 0,
		Name = "DropShadowHolder",
	}, NotificationFrameReal)

	local DropShadow = Custom:Create("ImageLabel", {
		Image = "",
		ImageColor3 = Colors.Background,
		ImageTransparency = 0.5,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(49, 49, 450, 450),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, 47, 1, 47),
		ZIndex = 0,
		Name = "DropShadow",
	}, DropShadowHolder)

	local Top = Custom:Create("Frame", {
		BackgroundColor3 = Colors.Primary,
		BackgroundTransparency = 0.999,
		BorderColor3 = Colors.Stroke,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 36),
		Name = "Top",
	}, NotificationFrameReal)

	local TitleLabel = Custom:Create("TextLabel", {
		Font = Enum.Font.GothamBold,
		Text = Title,
		TextColor3 = Colors.ThemeHighlight,
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundColor3 = Colors.Accent,
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.new(0, 10, 0, 5),
		Size = UDim2.new(0.7, 0, 0, 20),
		ZIndex = 2,
	}, Top)

	Custom:Create("UIStroke", {
		Color = Colors.Stroke,
		Thickness = 0.3,
	}, TitleLabel)

	local DescriptionLabel = Custom:Create("TextLabel", {
		Font = Enum.Font.Gotham,
		Text = Description,
		TextColor3 = Colors.Text,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundColor3 = Colors.Accent,
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.new(0, 10, 0, 25),
		Size = UDim2.new(0.7, 0, 0, 15),
		ZIndex = 2,
	}, Top)

	local CloseButton = Custom:Create("TextButton", {
		Font = Enum.Font.SourceSans,
		Text = "X",
		TextColor3 = Colors.Text,
		TextSize = 18,
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = Colors.Accent,
		BackgroundTransparency = 0.999,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.new(1, -5, 0.5, 0),
		Size = UDim2.new(0, 25, 0, 25),
		Name = "CloseButton",
		ZIndex = 2,
	}, Top)

	local ContentFrame = Custom:Create("Frame", {
		BackgroundColor3 = Colors.Background,
		BackgroundTransparency = 1,
		BorderColor3 = Colors.Stroke,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, Top.Size.Y.Offset),
		Size = UDim2.new(1, 0, 1, -Top.Size.Y.Offset),
		Name = "ContentFrame",
		ClipsDescendants = true,
		ZIndex = 1,
	}, NotificationFrameReal)

	local ContentLabel = Custom:Create("TextLabel", {
		Font = Enum.Font.Gotham,
		Text = Content,
		TextColor3 = Colors.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		BackgroundColor3 = Colors.Accent,
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.new(0, 10, 0, 5),
		Size = UDim2.new(1, -20, 0, 0),
		ZIndex = 1,
	}, ContentFrame)
	function Speed_Library:UpdateNotify()
		local CalculatedHeight = 23 + (14 * (ContentLabel.TextBounds.X // ContentLabel.AbsoluteSize.X))
		local finalheight = math.min(300, CalculatedHeight)

		ContentLabel.Size = UDim2.new(1, -20, 0, finalheight)
		HeightNotify = Top.Size.Y.Offset + ContentLabel.Size.Y.Offset + 10
		NotificationFrame.Size = UDim2.new(1, 0, 0, HeightNotify)
	end
	Speed_Library:UpdateNotify()
	TweenService:Create(
		NotificationFrameReal,
		TweenInfo.new(tonumber(Time), Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
		{ Position = UDim2.new(0, 0, 0, 0) }
	):Play()

	local Waitted = false
	function Notification:Close()
		if Waitted then
			return false
		end
		Waitted = true

		Speed_Library.closingNotifications += 1

		local tween = TweenService:Create(
			NotificationFrameReal,
			TweenInfo.new(tonumber(Time), Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
			{ Position = UDim2.new(0, 400, 0, 0) }
		)
		tween:Play()
		local function fadeOutElement(element, time)
			if element:IsA("TextLabel") or element:IsA("TextButton") then
				local tween = TweenService:Create(
					element,
					TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
					{ TextTransparency = 1 }
				)
				tween:Play()
			elseif element:IsA("ImageLabel") or element:IsA("ImageButton") then
				local tween = TweenService:Create(
					element,
					TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
					{ ImageTransparency = 1 }
				)
				tween:Play()
			elseif element:IsA("Frame") then
				local tween = TweenService:Create(
					element,
					TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
					{ BackgroundTransparency = 1 }
				)
				tween:Play()
			end

			for _, child in ipairs(element:GetChildren()) do
				fadeOutElement(child, time)
			end
		end
		fadeOutElement(NotificationFrameReal, Time)
		tween.Completed:Connect(function()
			task.wait(0.1)
			NotificationFrame:Destroy()
			Speed_Library.closingNotifications -= 1
		end)
	end
	local autoCloseThread = coroutine.create(function()
		task.wait(Delay)
		if not Waitted then
			Notification:Close()
		end
	end)
	coroutine.resume(autoCloseThread)
	CloseButton.MouseButton1Click:Connect(function()
		Notification:Close()
		CallbackCloseButton()
	end)
	applyhover(CloseButton, 0.999)

	return Notification
end
NotificationLayout.ChildRemoved:Connect(function()
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
	local CurrentY = 0
	for _, v in ipairs(NotificationLayout:GetChildren()) do
		if v:IsA("Frame") then
			local NewPOS = UDim2.new(0, 0, 1, -(CurrentY + v.Size.Y.Offset))
			local tween = TweenService:Create(v, tweenInfo, { Position = NewPOS })
			tween:Play()
			CurrentY += v.Size.Y.Offset + 12
		end
	end
end)

function Speed_Library:CreateWindow(Config)
	local Title = Config[1] or Config.Title or ""
	local Description = Config[2] or Config.Description or ""
	local TabWidth = Config[3] or Config["Tab Width"] or 120
	local SizeUi = Config[4] or Config.SizeUi or UDim2.fromOffset(550, 315)

	local Funcs = {}

	local SpeedHubXGui = Custom:Create(
		"ScreenGui",
		{
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		},
		RunService:IsStudio() and Player.PlayerGui
			or (gethui() or cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui"))
	)

	self.SpeedHubXGui = SpeedHubXGui

	local DropShadowHolder = Custom:Create("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 455, 0, 350),
		ZIndex = 0,
		Name = "DropShadowHolder",
		Position = UDim2.new(
			0,
			(SpeedHubXGui.AbsoluteSize.X // 2 - 455 // 2),
			0,
			(SpeedHubXGui.AbsoluteSize.Y // 2 - 350 // 2)
		),
	}, SpeedHubXGui)

	local DropShadow = Custom:Create("ImageLabel", {
		Image = "",
		ImageColor3 = Colors.Background,
		ImageTransparency = 0.5,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(49, 49, 450, 450),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = SizeUi,
		ZIndex = 0,
		Name = "DropShadow",
	}, DropShadowHolder)

	local Main = Custom:Create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Colors.Background,
		BackgroundTransparency = 0.1,
		BorderColor3 = Colors.Stroke,
		BorderSizePixel = 0,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = SizeUi,
		Name = "Main",
	}, DropShadow)

	Custom:Create("UICorner", {}, Main)

	Custom:Create("UIStroke", {
		Color = Colors.Stroke,
		Thickness = 1.6,
	}, Main)

	local Top = Custom:Create("Frame", {
		BackgroundColor3 = Colors.Primary,
		BackgroundTransparency = 0.9990000128746033,
		BorderColor3 = Colors.Stroke,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 38),
		Name = "Top",
	}, Main)
	Custom:Create("UIGradient", {
		Gradient = {
			StartColor = Colors.GradientStart,
			EndColor = Colors.GradientEnd,
			Rotation = 30,
		},
	}, Top)
	local TextLabel = Custom:Create("TextLabel", {
		Font = Enum.Font.Gotham,
		Text = Title,
		TextColor3 = Colors.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundColor3 = Colors.Accent,
		BackgroundTransparency = 0.9990000128746033,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Size = UDim2.new(1, -100, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
	}, Top)

	Custom:Create("UICorner", {}, Top)

	local TextLabel1 = Custom:Create("TextLabel", {
		Font = Enum.Font.GothamBold,
		Text = Description,
		TextColor3 = Colors.Accent,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundColor3 = Colors.Accent,
		BackgroundTransparency = 0.9990000128746033,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Size = UDim2.new(1, -(TextLabel.TextBounds.X + 104), 1, 0),
		Position = UDim2.new(0, TextLabel.TextBounds.X + 15, 0, 0),
	}, Top)

	Custom:Create("UIStroke", {
		Color = Colors.Stroke,
		Thickness = 0.4,
		Parent = TextLabel1,
	})

	local Close = Custom:Create("TextButton", {
		Font = Enum.Font.SourceSans,
		Text = "X",
		TextColor3 = Colors.Text,
		TextSize = 18,
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = Colors.Accent,
		BackgroundTransparency = 0.9990000128746033,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.new(1, -8, 0.5, 0),
		Size = UDim2.new(0, 25, 0, 25),
		Name = "Close",
	}, Top)

	local Min = Custom:Create("TextButton", {
		Font = Enum.Font.SourceSans,
		Text = "-",
		TextColor3 = Colors.Text,
		TextSize = 18,
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = Colors.Accent,
		BackgroundTransparency = 0.9990000128746033,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Position = UDim2.new(1, -42, 0.5, 0),
		Size = UDim2.new(0, 25, 0, 25),
		Name = "Min",
	}, Top)

	local LayersTab = Custom:Create("Frame", {
		BackgroundColor3 = Colors.Secondary,
		BackgroundTransparency = 0.9990000128746033,
		BorderColor3 = Colors.Stroke,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 9, 0, 50),
		Size = UDim2.new(0, TabWidth, 1, -59),
		Name = "LayersTab",
	}, Main)

	Custom:Create("UICorner", {
		CornerRadius = UDim.new(0, 2),
	}, LayersTab)

	Custom:Create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundColor3 = Colors.Primary,
		BackgroundTransparency = 0.85,
		BorderColor3 = Colors.Stroke,
		BorderSizePixel = 0,
		Position = UDim2.new(0.5, 0, 0, 38),
		Size = UDim2.new(1, 0, 0, 1),
		Name = "DecideFrame",
	}, Main)

	local Layers = Custom:Create("Frame", {
		BackgroundColor3 = Colors.Secondary,
		BackgroundTransparency = 0.9990000128746033,
		BorderColor3 = Colors.Stroke,
		BorderSizePixel = 0,
		Position = UDim2.new(0, TabWidth + 18, 0, 50),
		Size = UDim2.new(1, -(TabWidth + 9 + 18), 1, -59),
		Name = "Layers",
	}, Main)

	Custom:Create("UICorner", {
		CornerRadius = UDim.new(0, 2),
	}, Layers)

	local NameTab = Custom:Create("TextLabel", {
		Font = Enum.Font.GothamBold,
		Text = "",
		TextColor3 = Colors.Text,
		TextSize = 24,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundColor3 = Colors.Accent,
		BackgroundTransparency = 0.9990000128746033,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 30),
		Name = "NameTab",
	}, Layers)

	local LayersReal = Custom:Create("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = Colors.Accent,
		BackgroundTransparency = 0.9990000128746033,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 1, -33),
		Name = "LayersReal",
	}, Layers)

	local LayersFolder = Custom:Create("Folder", {
		Name = "LayersFolder",
	}, LayersReal)

	local LayersPageLayout = Custom:Create("UIPageLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Name = "LayersPageLayout",
		TweenTime = 0.5,
		EasingDirection = Enum.EasingDirection.InOut,
		EasingStyle = Enum.EasingStyle.Quad,
	}, LayersFolder)

	local ScrollTab = Custom:Create("ScrollingFrame", {
		CanvasSize = UDim2.new(0, 0, 2.10000002, 0),
		ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80),
		ScrollBarThickness = 0,
		Active = true,
		BackgroundColor3 = Colors.Accent,
		BackgroundTransparency = 0.9990000128746033,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, -10),
		Name = "ScrollTab",
	}, LayersTab)

	local UIListLayout = Custom:Create("UIListLayout", {
		Padding = UDim.new(0, 0),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, ScrollTab)

	local function UpdateSize()
		local _Total = 0

		for _, v in pairs(ScrollTab:GetChildren()) do
			if v.Name ~= "UIListLayout" then
				_Total = _Total + 3 + v.Size.Y.Offset
			end
		end

		ScrollTab.CanvasSize = UDim2.new(0, 0, 0, _Total)
	end

	ScrollTab.ChildAdded:Connect(UpdateSize)
	ScrollTab.ChildRemoved:Connect(UpdateSize)

	Min.Activated:Connect(function()
		CircleClick(Min, Player:GetMouse().X, Player:GetMouse().Y)
		DropShadowHolder.Visible = false

		if not Open_Close.Visible then
			Open_Close.Visible = true
		end
	end)

	Open_Close.Activated:Connect(function()
		DropShadowHolder.Visible = true
		if Open_Close.Visible then
			Open_Close.Visible = false
		end
	end)
	local OnCloseScripted = false
	function Speed_Library:OnClose(Callback)
		Close.Activated:Connect(function()
			if type(Callback) == "function" then
				task.spawn(function()
					CircleClick(Close, Player:GetMouse().X, Player:GetMouse().Y)
					Callback()
					if SpeedHubXGui then
						SpeedHubXGui.Enabled = false
						task.wait(1)
						SpeedHubXGui:Destroy()
					end
					OnCloseScripted = true
				end)
			end
		end)
	end
	if not OnCloseScripted then
		Close.Activated:Connect(function()
			CircleClick(Close, Player:GetMouse().X, Player:GetMouse().Y)
			if SpeedHubXGui then
				SpeedHubXGui:Destroy()
			end
			if not Speed_Library.Unloaded then
				Speed_Library.Unloaded = true
			end
		end)
	end

	local function CloseUnsavedChanges(obj1)
		local tween1 = TweenService:Create(
			obj1,
			TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ Position = UDim2.new(0.5, 0, 1, 25), BackgroundTransparency = 1 }
		)
		tween1:Play()

		tween1.Completed:Connect(function()
			obj1:Destroy()
		end)
	end

	DropShadowHolder.Size = UDim2.new(0, 115 + TextLabel.TextBounds.X + 1 + TextLabel1.TextBounds.X, 0, 350)
	MakeDraggable(Top, DropShadowHolder)
	function Speed_Library:UnsavedChanges(State, Callback, ChangesNum)
		local existingUi = Layers:FindFirstChild("UnsavedChangesUi")
		if existingUi then
			CloseUnsavedChanges(existingUi)
		end
		if not State then
			return
		end
		if not ChangesNum then
			ChangesNum = 0
		end

		local UnsavedChangesUi = Custom:Create("Frame", {
			Name = "UnsavedChangesUi",
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundColor3 = Colors.Primary,
			BackgroundTransparency = 1,
			BorderColor3 = Colors.Stroke,
			BorderSizePixel = 0,
			Position = UDim2.new(0.5, 0, 1, 100),
			Size = UDim2.new(1, -20, 0, 50),
			Parent = Layers,
			ZIndex = 1,
		})

		Custom:Create("UICorner", {
			CornerRadius = UDim.new(0, 8),
		}, UnsavedChangesUi)

		Custom:Create("UIStroke", {
			Color = Colors.Stroke,
			Thickness = 1.2,
			Transparency = 0.5,
		}, UnsavedChangesUi)

		SaveLabel = Custom:Create("TextLabel", {
			Text = "You have unsaved changes: " .. ChangesNum,
			Font = Enum.Font.GothamBold,
			TextColor3 = Colors.Text,
			TextSize = 14,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -120, 1, 0),
			Position = UDim2.new(0, 10, 0, 0),
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = UnsavedChangesUi,
			ZIndex = 2,
		})

		local SaveButton = Custom:Create("TextButton", {
			Text = "Save Changes",
			Font = Enum.Font.GothamBold,
			TextColor3 = Colors.Text,
			TextSize = 12,
			BackgroundColor3 = Colors.Accent,
			BackgroundTransparency = 0.8,
			Size = UDim2.new(0, 100, 0, 35),
			Position = UDim2.new(1, -110, 0.5, -17),
			Parent = UnsavedChangesUi,
			ZIndex = 2,
		})

		Custom:Create("UICorner", {
			CornerRadius = UDim.new(0, 6),
		}, SaveButton)

		SaveButton.Activated:Connect(function()
			CircleClick(SaveButton, Player:GetMouse().X, Player:GetMouse().Y)
			if type(Callback) == "function" then
				Callback()
			elseif type(Callback) == "table" then
				for _, cbfunction in pairs(Callback) do
					cbfunction()
					task.wait()
				end
			end
			CloseUnsavedChanges(UnsavedChangesUi)
		end)
		local tweenene = TweenService:Create(
			UnsavedChangesUi,
			TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ Position = UDim2.new(0.5, 0, 1, -10), BackgroundTransparency = 0.2 }
		)
		tweenene:Play()
		return {
			Destroy = function()
				local tw33n = TweenService:Create(
					UnsavedChangesUi,
					TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{ Position = UDim2.new(0.5, 0, 1, 100), BackgroundTransparency = 1 }
				)
				tw33n:Play()

				tw33n.Completed:Connect(function()
					UnsavedChangesUi:Destroy()
				end)
			end,
		}
	end

	function Speed_Library:UpdateChanges(newval)
		if SaveLabel.Parent.BackgroundTransparency ~= 1 then
			SaveLabel.Text = "You have unsaved changes: " .. newval
		end
	end

	local MoreBlur = Custom:Create("Frame", {
		AnchorPoint = Vector2.new(1, 1),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 1,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = UDim2.new(1, 8, 1, 8),
		Size = UDim2.new(1, 154, 1, 54),
		Visible = false,
		Name = "MoreBlur",
	}, Layers)
	local DropShadowHolder1 = Custom:Create("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 0,
		Name = "DropShadowHolder",
	}, MoreBlur)

	local DropShadow1 = Custom:Create("ImageLabel", {
		Image = "",
		ImageColor3 = Color3.fromRGB(0, 0, 0),
		ImageTransparency = 0.5,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(49, 49, 450, 450),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, 35, 1, 35),
		ZIndex = 0,
		Name = "DropShadow",
	}, DropShadowHolder1)

	Custom:Create("UICorner", {}, MoreBlur)

	local ConnectButton = Custom:Create("TextButton", {
		Font = Enum.Font.SourceSans,
		Text = "",
		TextColor3 = Colors.Text,
		TextSize = 14,
		BackgroundColor3 = Colors.Accent,
		BackgroundTransparency = 0.999,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Name = "ConnectButton",
	}, MoreBlur)

	local DropdownSelect = Custom:Create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = Colors.Primary,
		BorderColor3 = Colors.Stroke,
		BorderSizePixel = 0,
		LayoutOrder = 1,
		Position = UDim2.new(1, 172, 0.5, 0),
		Size = UDim2.new(0, 160, 1, -16),
		Name = "DropdownSelect",
		ClipsDescendants = true,
	}, MoreBlur)

	ConnectButton.Activated:Connect(function()
		if MoreBlur.Visible then
			local tweenInfo = TweenInfo.new(0.2)

			local _Hide = TweenService:Create(MoreBlur, tweenInfo, { BackgroundTransparency = 0.999 })
			local _Move = TweenService:Create(DropdownSelect, tweenInfo, { Position = UDim2.new(1, 172, 0.5, 0) })

			_Hide:Play()
			_Move:Play()

			task.wait(0.2)
			MoreBlur.Visible = false
		end
	end)

	Custom:Create("UICorner", {
		CornerRadius = UDim.new(0, 3),
		Parent = DropdownSelect,
	})

	Custom:Create("UIStroke", {
		Color = Colors.Stroke,
		Thickness = 2.5,
		Transparency = 0.8,
		Parent = DropdownSelect,
	})

	local DropdownSelectReal = Custom:Create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Colors.Background,
		BackgroundTransparency = 0.999,
		BorderColor3 = Colors.Stroke,
		BorderSizePixel = 0,
		LayoutOrder = 1,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, -10, 1, -10),
		Name = "DropdownSelectReal",
		Parent = DropdownSelect,
	}, DropdownSelect)

	local DropdownFolder = Custom:Create("Folder", {
		Name = "DropdownFolder",
		Parent = DropdownSelectReal,
	}, DropdownSelect)

	local DropPageLayout = Custom:Create("UIPageLayout", {
		EasingDirection = Enum.EasingDirection.InOut,
		EasingStyle = Enum.EasingStyle.Quad,
		TweenTime = 0.01,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Archivable = false,
		Name = "DropPageLayout",
		Parent = DropdownFolder,
	})

	local Tabs = {}
	local CountTab = 0
	local CountDropdown = 0
	function Tabs:CreateTab(Config)
		local _Name = Config[1] or Config.Name or ""
		local Icon = Config[2] or Config.Icon or ""

		local ScrolLayers = Custom:Create("ScrollingFrame", {
			ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80),
			ScrollBarThickness = 0,
			Active = true,
			LayoutOrder = CountTab,
			BackgroundColor3 = Colors.Accent,
			BackgroundTransparency = 0.999,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			Name = "ScrolLayers",
			Parent = LayersFolder,
		})

		Custom:Create("UIListLayout", {
			Padding = UDim.new(0, 3),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = ScrolLayers,
		})

		local Tab = Custom:Create("Frame", {
			BackgroundColor3 = Colors.Accent,
			BackgroundTransparency = CountTab == 0 and 0.92 or 0.999,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			LayoutOrder = CountTab,
			Size = UDim2.new(1, 0, 0, 30),
			Name = "Tab",
			Parent = ScrollTab,
		})

		Custom:Create("UICorner", {
			CornerRadius = UDim.new(0, 4),
			Parent = Tab,
		})

		local TabButton = Custom:Create("TextButton", {
			Font = Enum.Font.GothamBold,
			Text = "",
			TextColor3 = Colors.Text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundColor3 = Colors.Accent,
			BackgroundTransparency = 0.999,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			Name = "TabButton",
		}, Tab)

		Custom:Create("TextLabel", {
			Font = Enum.Font.GothamBold,
			Text = _Name,
			TextColor3 = Colors.Text,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundColor3 = Colors.Accent,
			BackgroundTransparency = 0.999,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 30, 0, 0),
			Name = "TabName",
		}, Tab)

		Custom:Create("ImageLabel", {
			Image = Icon,
			BackgroundColor3 = Colors.Accent,
			BackgroundTransparency = 0.999,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			Position = UDim2.new(0, 9, 0, 7),
			Size = UDim2.new(0, 16, 0, 16),
			Name = "FeatureImg",
		}, Tab)

		if CountTab == 0 then
			LayersPageLayout:JumpToIndex(0)
			NameTab.Text = _Name

			local ChooseFrame = Custom:Create("Frame", {
				BackgroundColor3 = Colors.ThemeHighlight,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.new(0, 2, 0, 9),
				Size = UDim2.new(0, 1, 0, 12),
				Name = "ChooseFrame",
			}, Tab)

			Custom:Create("UIStroke", {
				Color = Colors.Stroke,
				Thickness = 1.6,
			}, ChooseFrame)

			Custom:Create("UICorner", {}, ChooseFrame)
		end

		TabButton.Activated:Connect(function()
			CircleClick(TabButton, Player:GetMouse().X, Player:GetMouse().Y)
			local FrameChoose = nil

			for _, s in pairs(ScrollTab:GetChildren()) do
				for _, v in pairs(s:GetChildren()) do
					if v.Name == "ChooseFrame" then
						FrameChoose = v
						break
					end
				end

				if FrameChoose then
					break
				end
			end

			if FrameChoose and Tab.LayoutOrder ~= LayersPageLayout.CurrentPage.LayoutOrder then
				for _, TabFrame in pairs(ScrollTab:GetChildren()) do
					if TabFrame.Name == "Tab" then
						TweenService:Create(
							TabFrame,
							TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
							{ BackgroundTransparency = 0.999 }
						):Play()
					end
				end

				local _TabT = TweenService:Create(
					Tab,
					TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.InOut),
					{ BackgroundTransparency = 0.92 }
				)
				local _FTween = TweenService:Create(
					FrameChoose,
					TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
					{ Position = UDim2.new(0, 2, 0, 9 + (30 * Tab.LayoutOrder)) }
				)

				_TabT:Play()
				_FTween:Play()

				LayersPageLayout:JumpToIndex(Tab.LayoutOrder)

				task.wait(0.05)
				NameTab.Text = _Name

				TweenService:Create(
					FrameChoose,
					TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
					{ Size = UDim2.new(0, 1, 0, 20) }
				):Play()

				task.wait(0.2)
				TweenService:Create(
					FrameChoose,
					TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
					{ Size = UDim2.new(0, 1, 0, 12) }
				):Play()
			end
		end)

		local Sections, CountSection = {}, 0

		function Sections:AddSection(Title, OpenSection)
			local Title = Title or ""
			local OpenSection = OpenSection or false

			local Section = Custom:Create("Frame", {
				BackgroundColor3 = Colors.Accent,
				BackgroundTransparency = 0.999,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				ClipsDescendants = true,
				LayoutOrder = CountSection,
				Size = UDim2.new(1, 0, 0, 30),
				Name = "Section",
			}, ScrolLayers)

			local SectionReal = Custom:Create("Frame", {
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundColor3 = Colors.Accent,
				BackgroundTransparency = 0.935,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				LayoutOrder = 1,
				Position = UDim2.new(0.5, 0, 0, 0),
				Size = UDim2.new(1, 1, 0, 30),
				Name = "SectionReal",
			}, Section)

			Custom:Create("UICorner", {
				CornerRadius = UDim.new(0, 4),
			}, SectionReal)

			local SectionButton = Custom:Create("TextButton", {
				Font = Enum.Font.SourceSans,
				Text = "",
				TextColor3 = Color3.fromRGB(0, 0, 0),
				TextSize = 14,
				BackgroundColor3 = Colors.Accent,
				BackgroundTransparency = 0.9990000128746033,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0),
				Name = "SectionButton",
			}, SectionReal)

			local FeatureFrame = Custom:Create("Frame", {
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 0.9990000128746033,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.new(1, -5, 0.5, 0),
				Size = UDim2.new(0, 20, 0, 20),
				Name = "FeatureFrame",
			}, SectionReal)

			local FeatureImg = Custom:Create("ImageLabel", {
				Image = "",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Colors.Accent,
				BackgroundTransparency = 0.9990000128746033,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Rotation = -90,
				Size = UDim2.new(1, 6, 1, 6),
				Name = "FeatureImg",
			}, FeatureFrame)

			local SectionTitle = Custom:Create("TextLabel", {
				Font = Enum.Font.GothamBold,
				Text = Title,
				TextColor3 = Color3.fromRGB(230, 230, 230),
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundColor3 = Colors.Accent,
				BackgroundTransparency = 0.9990000128746033,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				Position = UDim2.new(0, 10, 0.5, 0),
				Size = UDim2.new(1, -50, 0, 13),
				Name = "SectionTitle",
			}, SectionReal)

			local SectionDecideFrame = Custom:Create("Frame", {
				BackgroundColor3 = Colors.Accent,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.new(0.5, 0, 0, 33),
				Size = UDim2.new(0, 0, 0, 2),
				Name = "SectionDecideFrame",
			}, Section)
			Custom:Create("UICorner", {}, SectionDecideFrame)
			Custom:Create("UIGradient", {
				Gradient = {
					StartColor = Colors.GradientStart,
					EndColor = Colors.GradientEnd,
					Rotation = 90,
				},
			}, SectionDecideFrame)

			local SectionAdd = Custom:Create("Frame", {
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundColor3 = Colors.Accent,
				BackgroundTransparency = 0.9990000128746033,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				ClipsDescendants = true,
				LayoutOrder = 1,
				Position = UDim2.new(0.5, 0, 0, 38),
				Size = UDim2.new(1, 0, 0, 100),
				Name = "SectionAdd",
			}, Section)

			Custom:Create("UICorner", {
				CornerRadius = UDim.new(0, 2),
			}, SectionAdd)

			Custom:Create("UIListLayout", {
				Padding = UDim.new(0, 3),
				SortOrder = Enum.SortOrder.LayoutOrder,
			}, SectionAdd)

			local function UpdateSizeScroll()
				local OffsetY = 0

				for _, child in pairs(ScrolLayers:GetChildren()) do
					if child.Name ~= "UIListLayout" then
						OffsetY = OffsetY + 3 + child.Size.Y.Offset
					end
				end

				ScrolLayers.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
			end

			local function UpdateSizeSection()
				if OpenSection then
					local SectionSizeYWitdh = 38

					for _, v in pairs(SectionAdd:GetChildren()) do
						if v.Name ~= "UIListLayout" and v.Name ~= "UICorner" then
							SectionSizeYWitdh = SectionSizeYWitdh + v.Size.Y.Offset + 3
						end
					end

					TweenService:Create(FeatureFrame, TweenInfo.new(0.1), { Rotation = 90 }):Play()
					TweenService:Create(Section, TweenInfo.new(0.1), { Size = UDim2.new(1, 1, 0, SectionSizeYWitdh) })
						:Play()
					TweenService
						:Create(SectionAdd, TweenInfo.new(0.1), { Size = UDim2.new(1, 0, 0, SectionSizeYWitdh - 38) })
						:Play()
					TweenService:Create(SectionDecideFrame, TweenInfo.new(0.1), { Size = UDim2.new(1, 0, 0, 2) }):Play()

					task.wait(0.5)
					UpdateSizeScroll()
				end
			end

			local function ToggleSection()
				CircleClick(SectionButton, Player:GetMouse().X, Player:GetMouse().Y)

				if OpenSection then
					TweenService:Create(FeatureFrame, TweenInfo.new(0.1), { Rotation = 0 }):Play()
					TweenService:Create(Section, TweenInfo.new(0.1), { Size = UDim2.new(1, 1, 0, 30) }):Play()
					TweenService:Create(SectionDecideFrame, TweenInfo.new(0.1), { Size = UDim2.new(0, 0, 0, 2) }):Play()

					OpenSection = false
					task.wait(0.1)
					UpdateSizeScroll()
				else
					OpenSection = true
					UpdateSizeSection()
				end
			end

			SectionButton.Activated:Connect(ToggleSection)
			SectionAdd.ChildAdded:Connect(UpdateSizeSection)
			SectionAdd.ChildRemoved:Connect(UpdateSizeSection)

			UpdateSizeScroll()

			local Item, ItemCount = {}, 0
			function Item:AddParagraph(Config)
				local Title = Config[1] or Config.Title or ""
				local Content = Config[2] or Config.Content or ""
				local SettingFuncs = {}

				local Paragraph = Custom:Create("Frame", {
					BackgroundColor3 = Colors.Accent,
					BackgroundTransparency = 0.935,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					LayoutOrder = ItemCount,
					Size = UDim2.new(1, 0, 0, 35),
					Name = "Paragraph",
				}, SectionAdd)

				Custom:Create("UICorner", {
					CornerRadius = UDim.new(0, 4),
				}, Paragraph)

				local ParagraphTitle = Custom:Create("TextLabel", {
					Font = Enum.Font.GothamBold,
					Text = Title,
					TextColor3 = Color3.fromRGB(231, 231, 231),
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					BackgroundColor3 = Colors.Accent,
					BackgroundTransparency = 0.999,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 10, 0, 10),
					Size = UDim2.new(1, -16, 0, 13),
					Name = "ParagraphTitle",
				}, Paragraph)

				local ParagraphContent = Custom:Create("TextLabel", {
					Font = Enum.Font.GothamBold,
					Text = Content,
					TextColor3 = Colors.Text,
					TextSize = 12,
					TextTransparency = 0.6,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Bottom,
					BackgroundColor3 = Colors.Accent,
					BackgroundTransparency = 0.999,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 10, 0, 23),
					Name = "ParagraphContent",
				}, Paragraph)

				local function UpdateParagraphSize()
					ParagraphContent.TextWrapped = false
					local lineCount = math.ceil(ParagraphContent.TextBounds.X / ParagraphContent.AbsoluteSize.X)

					ParagraphContent.Size = UDim2.new(1, -16, 0, 12 + (12 * lineCount))
					Paragraph.Size = UDim2.new(1, 0, 0, ParagraphContent.AbsoluteSize.Y + 33)
					ParagraphContent.TextWrapped = true

					UpdateSizeSection()
				end

				UpdateParagraphSize()

				ParagraphContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateParagraphSize)

				function SettingFuncs:Set(Config)
					local Title = Config[1] or Config.Title or ""
					local Content = Config[2] or Config.Content or ""

					ParagraphTitle.Text = Title
					ParagraphContent.Text = Content

					UpdateParagraphSize()
				end

				return SettingFuncs
			end

			function Item:Clear()
				for _, child in ipairs(SectionAdd:GetChildren()) do
					if not child:IsA("UIListLayout") then
						child:Destroy()
					end
				end

				ItemCount = 0

				if type(UpdateSizeScroll) == "function" then
					UpdateSizeScroll()
				end
			end

			function Item:AddSeperator(Config)
				local Title = Config[1] or Config.Title or ""
				local Sep_Funcs = {}

				local Seperator = Custom:Create("Frame", {
					BackgroundColor3 = Colors.Secondary,
					BackgroundTransparency = 0.1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 1,
					LayoutOrder = ItemCount,
					Size = UDim2.new(1, 0, 0, 30),
					Name = "Seperator",
				}, SectionAdd)

				local SeperatorTitle = Custom:Create("TextLabel", {
					Font = Enum.Font.GothamBold,
					Text = Title,
					TextColor3 = Color3.fromRGB(231, 231, 231),
					TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
					TextStrokeTransparency = 0.8,
					TextSize = 14,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					BackgroundColor3 = Colors.Accent,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 12, 0, 0),
					Size = UDim2.new(1, -16, 1, 0),
					Name = "SeperatorTitle",
				}, Seperator)

				Custom:Create("UICorner", {
					CornerRadius = UDim.new(0, 6),
				}, Seperator)

				Custom:Create("UIGradient", {
					Gradient = {
						StartColor = Colors.GradientStart,
						EndColor = Colors.GradientEnd,
						Rotation = 90,
					},
				}, Seperator)

				function Sep_Funcs:Set(Config)
					local Title = Config[1] or Config.Title or ""

					SeperatorTitle.Text = Title
				end

				ItemCount += 1
				return Sep_Funcs
			end

			function Item:AddLine()
				local LineFuncs = {}

				local Line = Custom:Create("Frame", {
					BackgroundColor3 = Colors.Accent,
					BackgroundTransparency = 0.4,
					BorderSizePixel = 0,
					LayoutOrder = ItemCount,
					Size = UDim2.new(1, 0, 0, 7),
					Name = "Line",
				}, SectionAdd)

				Custom:Create("UICorner", { CornerRadius = UDim.new(0, 3) }, Line)

				Custom:Create("UIGradient", {
					Gradient = {
						StartColor = Colors.GradientStart,
						EndColor = Colors.GradientEnd,
						Rotation = 0,
					},
				}, Line)

				ItemCount += 1
				return LineFuncs
			end

			function Item:AddButton(Config)
				local Title = Config[1] or Config.Title or ""
				local Content = Config[2] or Config.Content or ""
				local Icon = Config[3] or Config.Icon or ""
				local Callback = Config[4] or Config.Callback or function() end
				local Funcs_Button = {}

				local Button = Custom:Create("Frame", {
					Name = "Button",
					BackgroundColor3 = Colors.Secondary,
					BackgroundTransparency = 0.935,
					BorderSizePixel = 0,
					LayoutOrder = ItemCount,
					Size = UDim2.new(1, 0, 0, 35),
				}, SectionAdd)

				Custom:Create("UICorner", {
					CornerRadius = UDim.new(0, 4),
				}, Button)

				Custom:Create("TextLabel", {
					Name = "ButtonTitle",
					Font = Enum.Font.GothamBold,
					Text = Title,
					TextColor3 = Colors.Text,
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					BackgroundColor3 = Colors.Accent,
					BackgroundTransparency = 0.999,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 10, 0, 10),
					Size = UDim2.new(1, -100, 0, 13),
				}, Button)

				local ButtonContent = Custom:Create("TextLabel", {
					Name = "ButtonContent",
					Font = Enum.Font.GothamBold,
					Text = Content,
					TextColor3 = Colors.Text,
					TextSize = 12,
					TextTransparency = 0.6,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Bottom,
					BackgroundColor3 = Colors.Accent,
					BackgroundTransparency = 0.999,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 10, 0, 23),
					Size = UDim2.new(1, -100, 0, 12),
				}, Button)

				local function UpdateButtonSize()
					local _Height = 12 + (12 * (ButtonContent.TextBounds.X // ButtonContent.AbsoluteSize.X))
					ButtonContent.Size = UDim2.new(1, -100, 0, _Height)

					Button.Size = UDim2.new(1, 0, 0, ButtonContent.AbsoluteSize.Y + 33)
				end

				ButtonContent.TextWrapped = true
				UpdateButtonSize()

				ButtonContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
					ButtonContent.TextWrapped = false
					UpdateButtonSize()
					ButtonContent.TextWrapped = true
					UpdateSizeSection()
				end)

				local ButtonButton = Custom:Create("TextButton", {
					Name = "ButtonButton",
					Font = Enum.Font.SourceSans,
					Text = "",
					TextColor3 = Color3.fromRGB(0, 0, 0),
					TextSize = 14,
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 0.999,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 1, 0),
				}, Button)

				local FeatureFrame1 = Custom:Create("Frame", {
					Name = "FeatureFrame",
					AnchorPoint = Vector2.new(1, 0.5),
					BackgroundColor3 = Colors.Background,
					BackgroundTransparency = 0.999,
					BorderSizePixel = 0,
					Position = UDim2.new(1, -15, 0.5, 0),
					Size = UDim2.new(0, 25, 0, 25),
				}, Button)

				Custom:Create("ImageLabel", {
					Name = "FeatureImg",
					Image = Icon,
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Colors.Accent,
					BackgroundTransparency = 0.999,
					BorderSizePixel = 0,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					Size = UDim2.new(1, 0, 1, 0),
				}, FeatureFrame1)

				ButtonButton.Activated:Connect(function()
					CircleClick(ButtonButton, Player:GetMouse().X, Player:GetMouse().Y)

					Callback()
				end)

				ItemCount += 1
				return Funcs_Button
			end

			function Item:AddToggle(Config)
				local Title = Config[1] or Config.Title or ""
				local Content = Config[2] or Config.Content or ""
				local Default = Config[3] or Config.Default or false
				local Callback = Config[4] or Config.Callback or function() end

				local Funcs_Toggle = { Value = Default }

				local Toggle = Custom:Create("Frame", {
					Name = "Toggle",
					BackgroundColor3 = Colors.Accent,
					BackgroundTransparency = 0.935,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					LayoutOrder = ItemCount,
					Size = UDim2.new(1, 0, 0, 35),
				}, SectionAdd)

				Custom:Create("UICorner", {
					CornerRadius = UDim.new(0, 4),
				}, Toggle)

				local ToggleTitle = Custom:Create("TextLabel", {
					Name = "ToggleTitle",
					Font = Enum.Font.GothamBold,
					Text = Title,
					TextColor3 = Colors.Text,
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					BackgroundColor3 = Colors.Accent,
					BackgroundTransparency = 0.999,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 10, 0, 10),
					Size = UDim2.new(1, -100, 0, 13),
				}, Toggle)

				local ToggleContent = Custom:Create("TextLabel", {
					Name = "ToggleContent",
					Font = Enum.Font.GothamBold,
					Text = Content,
					TextColor3 = Colors.Text,
					TextSize = 12,
					TextTransparency = 0.6,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Bottom,
					BackgroundColor3 = Colors.Accent,
					BackgroundTransparency = 0.999,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 10, 0, 23),
					Size = UDim2.new(1, -100, 0, 12),
				}, Toggle)
				local function UpdateToggleSize()
					ToggleContent.TextWrapped = false
					local Ratio = ToggleContent.TextBounds.X / ToggleContent.AbsoluteSize.X

					ToggleContent.Size = UDim2.new(1, -100, 0, 12 + (12 * math.ceil(Ratio)))
					Toggle.Size = UDim2.new(1, 0, 0, ToggleContent.AbsoluteSize.Y + 33)
					ToggleContent.TextWrapped = true
				end

				UpdateToggleSize()

				ToggleContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
					UpdateToggleSize()
					UpdateSizeSection()
				end)

				local ToggleButton = Custom:Create("TextButton", {
					Name = "ToggleButton",
					Font = Enum.Font.SourceSans,
					Text = "",
					TextColor3 = Color3.fromRGB(0, 0, 0),
					TextSize = 14,
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 0.999,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 1, 0),
				}, Toggle)

				local FeatureFrame2 = Custom:Create("Frame", {
					Name = "FeatureFrame2",
					AnchorPoint = Vector2.new(1, 0.5),
					BackgroundColor3 = Colors.Secondary,
					BackgroundTransparency = 0.92,
					BorderSizePixel = 0,
					Position = UDim2.new(1, -15, 0.5, 0),
					Size = UDim2.new(0, 30, 0, 15),
				}, Toggle)

				Custom:Create("UICorner", {
					CornerRadius = UDim.new(0, 4),
				}, FeatureFrame2)

				local UIStroke8 = Custom:Create("UIStroke", {
					Color = Colors.Stroke,
					Thickness = 2,
					Transparency = 0.9,
				}, FeatureFrame2)

				local ToggleCircle = Custom:Create("Frame", {
					Name = "ToggleCircle",
					BackgroundColor3 = Color3.fromRGB(230, 230, 230),
					BorderSizePixel = 0,
					Size = UDim2.new(0, 14, 0, 14),
					Position = UDim2.new(0, 0, 0, 0),
				}, FeatureFrame2)

				Custom:Create("UICorner", {
					CornerRadius = UDim.new(0, 15),
				}, ToggleCircle)

				local function ToggleAnimation(isOn)
					local TitleColor = isOn and Colors.ThemeHighlight or Colors.Text
					local CirclePosition = isOn and UDim2.new(0, 15, 0, 0) or UDim2.new(0, 0, 0, 0)
					local StrokeColor = isOn and Colors.ThemeHighlight or Colors.Text
					local StrokeTransparency = isOn and 0 or 0.9
					local FrameColor = isOn and Colors.ThemeHighlight or Color3.fromRGB(180, 180, 180)
					local FrameTransparency = isOn and 0 or 0.92

					local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

					TweenService:Create(ToggleTitle, tweenInfo, { TextColor3 = TitleColor }):Play()
					TweenService:Create(ToggleCircle, tweenInfo, { Position = CirclePosition }):Play()
					TweenService
						:Create(UIStroke8, tweenInfo, { Color = StrokeColor, Transparency = StrokeTransparency })
						:Play()
					TweenService:Create(
						FeatureFrame2,
						tweenInfo,
						{ BackgroundColor3 = FrameColor, BackgroundTransparency = FrameTransparency }
					):Play()
				end

				ToggleButton.Activated:Connect(function()
					CircleClick(ToggleButton, Player:GetMouse().X, Player:GetMouse().Y)
					Funcs_Toggle.Value = not Funcs_Toggle.Value
					Funcs_Toggle:Set(Funcs_Toggle.Value)
				end)

				function Funcs_Toggle:Set(Value)
					Callback(Value)
					ToggleAnimation(Value)
				end
				Funcs_Toggle:Set(Funcs_Toggle.Value)

				ItemCount += 1
				return Funcs_Toggle
			end

			function Item:AddSlider(Config)
				local Title = Config[1] or Config.Title or ""
				local Content = Config[2] or Config.Content or ""
				local Increment = Config[3] or Config.Increment or 1
				local Min = Config[4] or Config.Min or 0
				local Max = Config[5] or Config.Max or 100
				local Default = Config[6] or Config.Default or 50
				local Callback = Config[7] or Config.Callback or function() end

				local Funcs_Slider = { Value = Default }

				local Slider = Custom:Create("Frame", {
					BackgroundColor3 = Colors.Accent,
					BackgroundTransparency = 0.88,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					LayoutOrder = ItemCount,
					Size = UDim2.new(1, 0, 0, 40),
					Name = "Slider",
				}, SectionAdd)

				Custom:Create("UICorner", {
					CornerRadius = UDim.new(0, 6),
				}, Slider)

				Custom:Create("UIStroke", {
					Color = Colors.Stroke,
					Transparency = 0.92,
					Thickness = 1,
				}, Slider)

				local SliderTitle = Custom:Create("TextLabel", {
					Font = Enum.Font.GothamBold,
					Text = Title,
					TextColor3 = Colors.Text,
					TextSize = 14,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					BackgroundColor3 = Colors.Accent,
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.new(0, 12, 0, 10),
					Size = UDim2.new(1, -180, 0, 14),
					Name = "SliderTitle",
				}, Slider)

				local SliderContent = Custom:Create("TextLabel", {
					Font = Enum.Font.Gotham,
					Text = Content,
					TextColor3 = Colors.Text,
					TextSize = 12,
					TextTransparency = 0.5,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Bottom,
					BackgroundColor3 = Colors.Accent,
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.new(0, 12, 0, 25),
					Size = UDim2.new(1, -180, 0, 12),
					Name = "SliderContent",
				}, Slider)

				local function UpdateSliderSize()
					SliderContent.TextWrapped = false
					SliderContent.Size = UDim2.new(
						1,
						-180,
						0,
						12 + (12 * math.floor(SliderContent.TextBounds.X / SliderContent.AbsoluteSize.X))
					)
					Slider.Size = UDim2.new(1, 0, 0, SliderContent.AbsoluteSize.Y + 38)
					SliderContent.TextWrapped = true
				end

				SliderContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
					UpdateSliderSize()
					UpdateSizeSection()
				end)
				UpdateSliderSize()

				local SliderInput = Custom:Create("Frame", {
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundColor3 = Colors.Accent,
					BackgroundTransparency = 0,
					BorderColor3 = Colors.Stroke,
					BorderSizePixel = 0,
					Position = UDim2.new(1, -165, 0.5, 0),
					Size = UDim2.new(0, 32, 0, 22),
					Name = "SliderInput",
				}, Slider)

				Custom:Create("UICorner", {
					CornerRadius = UDim.new(0, 4),
				}, SliderInput)

				Custom:Create("UIStroke", {
					Color = Colors.Stroke,
					Transparency = 0.8,
					Thickness = 1,
				}, SliderInput)

				local TextBox = Custom:Create("TextBox", {
					Font = Enum.Font.GothamBold,
					Text = tostring(Default),
					TextColor3 = Colors.Text,
					TextSize = 13,
					TextWrapped = true,
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(1, 0, 1, 0),
					ClearTextOnFocus = true,
				}, SliderInput)

				local SliderFrame = Custom:Create("Frame", {
					AnchorPoint = Vector2.new(1, 0.5),
					BackgroundColor3 = Colors.Accent,
					BackgroundTransparency = 0,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.new(1, -20, 0.5, 0),
					Size = UDim2.new(0, 100, 0, 4),
					Name = "SliderFrame",
				}, Slider)

				Custom:Create("UICorner", {
					CornerRadius = UDim.new(0, 2),
				}, SliderFrame)

				Custom:Create("UIStroke", {
					Color = Colors.Stroke,
					Transparency = 0.85,
					Thickness = 1,
				}, SliderFrame)

				local SliderDraggable = Custom:Create("Frame", {
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundColor3 = Colors.ThemeHighlight,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.new(0, 0, 0.5, 0),
					Size = UDim2.new(0.5, 0, 1, 0),
					Name = "SliderDraggable",
				}, SliderFrame)

				Custom:Create("UICorner", {
					CornerRadius = UDim.new(0, 2),
				}, SliderDraggable)

				local SliderCircle = Custom:Create("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Colors.ThemeHighlight,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.new(1, 0, 0.5, 0),
					Size = UDim2.new(0, 12, 0, 12),
					Name = "SliderCircle",
				}, SliderDraggable)

				Custom:Create("UICorner", {
					CornerRadius = UDim.new(0, 6),
				}, SliderCircle)

				Custom:Create("UIStroke", {
					Color = Colors.Stroke,
					Thickness = 1,
				}, SliderCircle)

				Custom:Create("UIGradient", {
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
						ColorSequenceKeypoint.new(1, Colors.ThemeHighlight),
					}),
					Rotation = 45,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0.3),
						NumberSequenceKeypoint.new(1, 0.7),
					}),
				}, SliderCircle)

				local Dragging = false
				local Hovering = false

				local function Round(Number, Factor)
					local Result = math.floor(Number / Factor + (math.sign(Number) * 0.5)) * Factor
					if Result < 0 then
						Result = Result + Factor
					end
					return Result
				end

				function Funcs_Slider:Set(Value)
					Value = math.clamp(Round(Value, Increment), Min, Max)
					Funcs_Slider.Value = Value
					TextBox.Text = tostring(Value)

					TweenService:Create(
						SliderDraggable,
						TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{ Size = UDim2.fromScale((Value - Min) / (Max - Min), 1) }
					):Play()
				end

				SliderFrame.MouseEnter:Connect(function()
					Hovering = true

					TweenService
						:Create(
							SliderCircle,
							TweenInfo.new(0.2, Enum.EasingStyle.Quad),
							{ Size = UDim2.new(0, 14, 0, 14) }
						)
						:Play()
				end)

				SliderFrame.MouseLeave:Connect(function()
					Hovering = false
					if not Dragging then
						TweenService:Create(
							SliderCircle,
							TweenInfo.new(0.2, Enum.EasingStyle.Quad),
							{ Size = UDim2.new(0, 12, 0, 12) }
						):Play()
					end
				end)

				SliderFrame.InputBegan:Connect(function(Input)
					if
						Input.UserInputType == Enum.UserInputType.MouseButton1
						or Input.UserInputType == Enum.UserInputType.Touch
					then
						Dragging = true

						TweenService:Create(
							SliderCircle,
							TweenInfo.new(0.1, Enum.EasingStyle.Quad),
							{ Size = UDim2.new(0, 16, 0, 16) }
						):Play()

						local SizeScale = math.clamp(
							(Input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X,
							0,
							1
						)
						Funcs_Slider:Set(Min + ((Max - Min) * SizeScale))
						Callback(Funcs_Slider.Value)
					end
				end)

				SliderFrame.InputEnded:Connect(function(Input)
					if
						Input.UserInputType == Enum.UserInputType.MouseButton1
						or Input.UserInputType == Enum.UserInputType.Touch
					then
						Dragging = false

						if not Hovering then
							TweenService:Create(
								SliderCircle,
								TweenInfo.new(0.2, Enum.EasingStyle.Quad),
								{ Size = UDim2.new(0, 12, 0, 12) }
							):Play()
						else
							TweenService:Create(
								SliderCircle,
								TweenInfo.new(0.2, Enum.EasingStyle.Quad),
								{ Size = UDim2.new(0, 14, 0, 14) }
							):Play()
						end

						Callback(Funcs_Slider.Value)
					end
				end)

				local _LastX = nil
				UserInputService.InputChanged:Connect(function(Input)
					if Dragging then
						local CurrPosX = Input.Position.X
						if CurrPosX ~= _LastX then
							_LastX = CurrPosX

							local SizeScale = math.clamp(
								(CurrPosX - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X,
								0,
								1
							)
							Funcs_Slider:Set(Min + ((Max - Min) * SizeScale))
						end
					end
				end)
				TextBox.Focused:Connect(function()
					TweenService
						:Create(
							SliderInput,
							TweenInfo.new(0.2, Enum.EasingStyle.Quad),
							{ BackgroundTransparency = 0.2 }
						)
						:Play()
				end)

				TextBox.FocusLost:Connect(function()
					TweenService
						:Create(SliderInput, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { BackgroundTransparency = 0 })
						:Play()

					if TextBox.Text ~= "" then
						Funcs_Slider:Set(tonumber(TextBox.Text))
						Callback(Funcs_Slider.Value)
					else
						Funcs_Slider:Set(Funcs_Slider.Value)
					end
				end)

				TextBox:GetPropertyChangedSignal("Text"):Connect(function()
					local Valid = TextBox.Text:gsub("[^%d%-%.%+]", "")
					if Valid ~= "" then
						local ValidNumber = math.clamp(tonumber(Valid) or Min, Min, Max)
						if ValidNumber ~= tonumber(TextBox.Text) then
							TextBox.Text = tostring(ValidNumber)
						end
					end
				end)

				Funcs_Slider:Set(tonumber(Default))
				Callback(Funcs_Slider.Value)

				ItemCount += 1
				return Funcs_Slider
			end

			function Item:AddInput(Config)
				local Title = Config[1] or Config.Title or ""
				local Content = Config[2] or Config.Content or ""
				local Default = Config[3] or Config.Default or ""
				local Callback = Config[4] or Config.Callback or function() end
				local Funcs_Input = { Value = Default }

				local Input = Custom:Create("Frame", {
					BackgroundColor3 = Colors.Accent,
					BackgroundTransparency = 0.935,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					LayoutOrder = ItemCount,
					Size = UDim2.new(1, 0, 0, 35),
					Name = "Input",
				}, SectionAdd)

				Custom:Create("UICorner", {
					CornerRadius = UDim.new(0, 4),
				}, Input)

				local InputTitle = Custom:Create("TextLabel", {
					Font = Enum.Font.GothamBold,
					Text = Title,
					TextColor3 = Colors.Text,
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					BackgroundColor3 = Colors.Accent,
					BackgroundTransparency = 0.999,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.new(0, 10, 0, 10),
					Size = UDim2.new(1, -180, 0, 13),
					Name = "InputTitle",
				}, Input)

				local InputContent = Custom:Create("TextLabel", {
					Font = Enum.Font.GothamBold,
					Text = Content,
					TextColor3 = Colors.Text,
					TextSize = 12,
					TextTransparency = 0.6,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Bottom,
					BackgroundColor3 = Colors.Accent,
					BackgroundTransparency = 0.999,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.new(0, 10, 0, 23),
					Size = UDim2.new(1, -180, 0, 12),
					Name = "InputContent",
					Parent = Input,
				})

				local function UpdateInputSize()
					local Ratio = InputContent.TextBounds.X / InputContent.AbsoluteSize.X
					local Calculated = 12 + (12 * math.floor(Ratio))

					InputContent.Size = UDim2.new(1, -180, 0, Calculated)
					Input.Size = UDim2.new(1, 0, 0, InputContent.AbsoluteSize.Y + 33)
				end

				UpdateInputSize()

				InputContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
					InputContent.TextWrapped = false
					UpdateInputSize()
					InputContent.TextWrapped = true
					UpdateSizeSection()
				end)

				local InputFrame = Custom:Create("Frame", {
					AnchorPoint = Vector2.new(1, 0.5),
					BackgroundColor3 = Colors.Accent,
					BackgroundTransparency = 0.95,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					ClipsDescendants = true,
					Position = UDim2.new(1, -7, 0.5, 0),
					Size = UDim2.new(0, 148, 0, 30),
					Name = "InputFrame",
				}, Input)

				Custom:Create("UICorner", {
					CornerRadius = UDim.new(0, 4),
				}, InputFrame)

				local InputTextBox = Custom:Create("TextBox", {
					CursorPosition = -1,
					Font = Enum.Font.GothamBold,
					PlaceholderColor3 = Color3.fromRGB(120, 120, 120),
					PlaceholderText = "Write your input there",
					Text = "",
					TextColor3 = Colors.Text,
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Left,
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundColor3 = Colors.Accent,
					BackgroundTransparency = 0.999,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.new(0, 5, 0.5, 0),
					Size = UDim2.new(1, -10, 1, -8),
					Name = "InputTextBox",
				}, InputFrame)

				function Funcs_Input:Set(Value)
					InputTextBox.Text = Value
					Funcs_Input.Value = Value
					Callback(Value)
				end

				InputTextBox.FocusLost:Connect(function()
					Funcs_Input:Set(InputTextBox.Text)
				end)

				Funcs_Input:Set(Default)

				ItemCount += 1
				return Funcs_Input
			end

			function Item:AddDropdown(Config)
				local Title = Config[1] or Config.Title or ""
				local Content = Config[2] or Config.Content or ""
				local Multi = Config[3] or Config.Multi or false
				local Options = Config[4] or Config.Options or {}
				local Default = Config[5] or Config.Default or {}
				local Callback = Config[6] or Config.Callback or function() end

				local Funcs_Dropdown = { Value = Default, Options = Options }

				local Dropdown = Custom:Create("Frame", {
					BackgroundColor3 = Colors.Accent,
					BackgroundTransparency = 0.935,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					LayoutOrder = ItemCount,
					Size = UDim2.new(1, 0, 0, 35),
					Name = "Dropdown",
				}, SectionAdd)

				local DropdownButton = Custom:Create("TextButton", {
					Font = Enum.Font.SourceSans,
					Text = "",
					TextColor3 = Color3.fromRGB(0, 0, 0),
					TextSize = 14,
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 0.999,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 1, 0),
					Name = "ToggleButton",
				}, Dropdown)

				Custom:Create("UICorner", {
					CornerRadius = UDim.new(0, 4),
				}, Dropdown)

				local DropdownTitle = Custom:Create("TextLabel", {
					Font = Enum.Font.GothamBold,
					Text = Title,
					TextColor3 = Colors.Text,
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					BackgroundColor3 = Colors.Accent,
					BackgroundTransparency = 0.999,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.new(0, 10, 0, 10),
					Size = UDim2.new(1, -180, 0, 13),
					Name = "DropdownTitle",
					Parent = Dropdown,
				})

				local DropdownContent = Custom:Create("TextLabel", {
					Font = Enum.Font.GothamBold,
					Text = Content,
					TextColor3 = Colors.Text,
					TextSize = 12,
					TextTransparency = 0.6,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Bottom,
					BackgroundColor3 = Colors.Accent,
					BackgroundTransparency = 0.999,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.new(0, 10, 0, 23),
					Size = UDim2.new(1, -180, 0, 12),
					Name = "DropdownContent",
					Parent = Dropdown,
				})

				DropdownContent.Size =
					UDim2.new(1, -180, 0, 12 + (12 * (DropdownContent.TextBounds.X // DropdownContent.AbsoluteSize.X)))
				DropdownContent.TextWrapped = true
				Dropdown.Size = UDim2.new(1, 0, 0, DropdownContent.AbsoluteSize.Y + 33)

				DropdownContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
					DropdownContent.TextWrapped = false

					DropdownContent.Size = UDim2.new(
						1,
						-180,
						0,
						12 + (12 * (DropdownContent.TextBounds.X // DropdownContent.AbsoluteSize.X))
					)
					Dropdown.Size = UDim2.new(1, 0, 0, DropdownContent.AbsoluteSize.Y + 33)

					DropdownContent.TextWrapped = true

					UpdateSizeSection()
				end)

				local SelectOptionsFrame = Custom:Create("Frame", {
					AnchorPoint = Vector2.new(1, 0.5),
					BackgroundColor3 = Colors.Accent,
					BackgroundTransparency = 0.95,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.new(1, -7, 0.5, 0),
					Size = UDim2.new(0, 148, 0, 30),
					Name = "SelectOptionsFrame",
					LayoutOrder = CountDropdown,
				}, Dropdown)

				Custom:Create("UICorner", {
					CornerRadius = UDim.new(0, 4),
				}, SelectOptionsFrame)

				DropdownButton.Activated:Connect(function()
					if not MoreBlur.Visible then
						MoreBlur.Visible = true

						local tweenInfo = TweenInfo.new(0.1)

						DropPageLayout:JumpToIndex(SelectOptionsFrame.LayoutOrder)

						local BlurTween = TweenService:Create(MoreBlur, tweenInfo, { BackgroundTransparency = 0.7 })
						local DropdownTween =
							TweenService:Create(DropdownSelect, tweenInfo, { Position = UDim2.new(1, -11, 0.5, 0) })

						BlurTween:Play()
						DropdownTween:Play()
					end
				end)

				local OptionSelecting = Custom:Create("TextLabel", {
					Font = Enum.Font.GothamBold,
					Text = "",
					TextColor3 = Colors.Text,
					TextSize = 12,
					TextTransparency = 0.6,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					AnchorPoint = Vector2.new(0, 0.5),
					BackgroundColor3 = Colors.Accent,
					BackgroundTransparency = 0.999,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.new(0, 5, 0.5, 0),
					Size = UDim2.new(1, -30, 1, -8),
					Name = "OptionSelecting",
				}, SelectOptionsFrame)

				local OptionImg = Custom:Create("ImageLabel", {
					Image = "",
					ImageColor3 = Color3.fromRGB(231, 231, 231),
					AnchorPoint = Vector2.new(1, 0.5),
					BackgroundColor3 = Colors.Accent,
					BackgroundTransparency = 0.999,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.new(1, 0, 0.5, 0),
					Size = UDim2.new(0, 25, 0, 25),
					Name = "OptionImg",
				}, SelectOptionsFrame)

				local ScrollSelect = Custom:Create("ScrollingFrame", {
					CanvasSize = UDim2.new(0, 0, 0, 0),
					ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
					ScrollBarThickness = 0,
					Active = true,
					LayoutOrder = CountDropdown,
					BackgroundColor3 = Colors.Accent,
					BackgroundTransparency = 0.999,
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 1, 0),
					Name = "ScrollSelect",
				}, DropdownFolder)

				Custom:Create("UIListLayout", {
					Padding = UDim.new(0, 3),
					SortOrder = Enum.SortOrder.LayoutOrder,
				}, ScrollSelect)

				local DropCount = 0

				function Funcs_Dropdown:Clear()
					for _, DropFrame in pairs(ScrollSelect:GetChildren()) do
						if DropFrame.Name == "Option" then
							Funcs_Dropdown.Value = {}
							Funcs_Dropdown.Options = {}
							OptionSelecting.Text = "Select Options"
							DropFrame:Destroy()
						end
					end
				end

				function Funcs_Dropdown:Set(Value)
					Funcs_Dropdown.Value = Value or Funcs_Dropdown.Value

					for _, Drop in pairs(ScrollSelect:GetChildren()) do
						if Drop.Name ~= "UIListLayout" then
							local isTextFound = table.find(Funcs_Dropdown.Value, Drop.OptionText.Text)
							local tweenInfoInOut = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

							local Size = isTextFound and UDim2.new(0, 1, 0, 12) or UDim2.new(0, 0, 0, 0)
							local BackgroundTransparency = isTextFound and 0.935 or 0.999
							local Transparency = isTextFound and 0 or 0.999

							TweenService:Create(Drop.ChooseFrame, tweenInfoInOut, { Size = Size }):Play()
							TweenService
								:Create(Drop.ChooseFrame.UIStroke, tweenInfoInOut, { Transparency = Transparency })
								:Play()
							TweenService
								:Create(Drop, tweenInfoInOut, { BackgroundTransparency = BackgroundTransparency })
								:Play()
						end
					end

					local DropdownValueTable = table.concat(Funcs_Dropdown.Value, ", ")
					OptionSelecting.Text = DropdownValueTable ~= "" and DropdownValueTable or "Select Options"
					Callback(Funcs_Dropdown.Value)
				end

				function Funcs_Dropdown:AddOption(OptionName)
					OptionName = OptionName or "Option"

					local Option = Custom:Create("Frame", {
						BackgroundColor3 = Colors.Accent,
						BackgroundTransparency = 0.999,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						LayoutOrder = DropCount,
						Size = UDim2.new(1, 0, 0, 30),
						Name = "Option",
					}, ScrollSelect)

					Custom:Create("UICorner", {
						CornerRadius = UDim.new(0, 3),
					}, Option)

					local OptionButton = Custom:Create("TextButton", {
						Font = Enum.Font.GothamBold,
						Text = "",
						TextColor3 = Colors.Text,
						TextSize = 13,
						TextXAlignment = Enum.TextXAlignment.Left,
						BackgroundColor3 = Colors.Accent,
						BackgroundTransparency = 0.999,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 1, 0),
						Name = "OptionButton",
					}, Option)

					Custom:Create("TextLabel", {
						Font = Enum.Font.GothamBold,
						Text = OptionName,
						TextSize = 13,
						TextColor3 = Colors.Text,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						BackgroundColor3 = Colors.Accent,
						BackgroundTransparency = 0.999,
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						Position = UDim2.new(0, 8, 0, 8),
						Size = UDim2.new(1, -100, 0, 13),
						Name = "OptionText",
					}, Option)

					local ChooseFrame = Custom:Create("Frame", {
						AnchorPoint = Vector2.new(0, 0.5),
						BackgroundColor3 = Colors.ThemeHighlight,
						BorderColor3 = Colors.Stroke,
						BorderSizePixel = 0,
						Position = UDim2.new(0, 2, 0.5, 0),
						Size = UDim2.new(0, 0, 0, 0),
						Name = "ChooseFrame",
					}, Option)

					Custom:Create("UIStroke", {
						Color = Colors.Stroke,
						Thickness = 1.6,
						Transparency = 0.999,
					}, ChooseFrame)

					Custom:Create("UICorner", {}, ChooseFrame)

					OptionButton.Activated:Connect(function()
						CircleClick(OptionButton, Player:GetMouse().X, Player:GetMouse().Y)

						local isOptionSelected = Option.BackgroundTransparency > 0.95

						if Multi then
							if isOptionSelected then
								if not table.find(Funcs_Dropdown.Value, OptionName) then
									table.insert(Funcs_Dropdown.Value, OptionName)
								end
							else
								for i, value in ipairs(Funcs_Dropdown.Value) do
									if value == OptionName then
										table.remove(Funcs_Dropdown.Value, i)
										break
									end
								end
							end
						else
							Funcs_Dropdown.Value = { OptionName }
						end

						Funcs_Dropdown:Set(Funcs_Dropdown.Value)
					end)

					local function UpdateCanvasSize()
						local OffsetY = 0

						for _, child in ipairs(ScrollSelect:GetChildren()) do
							if child.Name ~= "UIListLayout" then
								OffsetY = OffsetY + 3 + child.Size.Y.Offset
							end
						end

						ScrollSelect.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
					end

					UpdateCanvasSize()

					DropCount += 1

					return
				end

				function Funcs_Dropdown:Refresh(RefreshList, Selecting)
					RefreshList = RefreshList or {}
					Selecting = Selecting or {}

					Funcs_Dropdown:Clear()

					for _, Drop in ipairs(RefreshList) do
						Funcs_Dropdown:AddOption(Drop)
					end

					Funcs_Dropdown.Options = RefreshList
					Funcs_Dropdown:Set(Selecting)
				end

				Funcs_Dropdown:Refresh(Funcs_Dropdown.Options, Funcs_Dropdown.Value)

				ItemCount += 1
				CountDropdown += 1
				return Funcs_Dropdown
			end

			ItemCount += 1
			return Item
		end

		CountTab += 1
		return Sections
	end

	return Tabs
end
return Speed_Library
