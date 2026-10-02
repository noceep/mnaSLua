local Notify =  {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Colors = {
	Success = Color3.fromRGB(75, 220, 150),
	Warning = Color3.fromRGB(255, 190, 85),
	Error = Color3.fromRGB(255, 100, 110),
	Info = Color3.fromRGB(100, 170, 255)
}

local Icons = {
	Success = "✓",
	Warning = "!",
	Error = "X",
	Info = "i"
}

local ScreenGUI = Instance.new("ScreenGui")
ScreenGUI.Name = "mnaNotify"
ScreenGUI.Parent = PlayerGui
ScreenGUI.ResetOnSpawn = false

local Container = Instance.new("Frame")
Container.Name  = "Container"
Container.AnchorPoint = Vector2.new(1, 1)
Container.Size = UDim2.new(0, 340, 1 , -32)
Container.Position = UDim2.new(1, -20, 1, -20)
Container.BackgroundTransparency = 1
Container.Parent = ScreenGUI

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,10)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
Layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Container

local NotificationCount = 0

function Notify:Send(Message, Type, Duration)
	if typeof(Message) ~= "string" then
		return
	end

	Type = Colors[Type] and Type or "Info"
	NotifyDuration = math.clamp(tonumber(Duration) or 4, 0.1, 60)

	NotificationCount = NotificationCount + 1

	local Notification = Instance.new("Frame")
	Notification.Name = Type
	Notification .LayoutOrder = -NotificationCount
	Notification.Size = UDim2.new(1, 0, 0, 82)
	Notification.BackgroundColor3 = Color3.fromRGB(24, 27, 36)
	Notification.BackgroundTransparency = 0.12
	Notification.BorderSizePixel = 0
	Notification.ClipsDescendants = true

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 12)
	Corner.Parent = Notification
	
	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(255, 255, 255)
	Stroke.Transparency = 0.82
	Stroke.Thickness = 1
	Stroke.Parent = Notification

	local Gradient = Instance.new("UIGradient")
	Gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(39, 43, 55)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 22, 30))
	})
	Gradient.Rotation = 20
	Gradient.Parent = Notification

	local Accent = Instance.new("Frame")
	Accent.Name = "Accent"
	Accent.Size =  UDim2.new(0, 4, 1, -24)
	Accent.Position = UDim2.new(0, 0, 0, 12)
	Accent.BackgroundColor3 = Colors[Type]
	Accent.BorderSizePixel = 0
	Accent.Parent = Notification

	local AccentCorner = Instance.new("UICorner")
	AccentCorner.CornerRadius = UDim.new(1, 0)
	AccentCorner.Parent = Accent

	local Icon = Instance.new("TextLabel")
	Icon.Name = "Icon"
	Icon.Size = UDim2.new(0, 30, 0, 30)
	Icon.Position = UDim2.new(0, 17, 0, 15)
	Icon.BackgroundColor3 = Colors[Type]
	Icon.BackgroundTransparency = 0.82
	Icon.Text = Icons[Type]
	Icon.TextColor3 = Colors[Type]
	Icon.TextSize = 18
	Icon.Font = Enum.Font.GothamBold
	Icon.Parent = Notification

	local IconCorner = Instance.new("UICorner")
	IconCorner.CornerRadius = UDim.new(1, 0)
	IconCorner.Parent = Icon

	local Title = Instance.new("TextLabel")
	Title.Name = "Title"
	Title.Size = UDim2.new(1, -75, 0, 20)
	Title.Position = UDim2.new(0, 57, 0, 13)
	Title.BackgroundTransparency = 1
	Title.Text = Type
	Title.TextColor3 = Color3.fromRGB(245, 247, 255)
	Title.TextSize = 14
	Title.Font = Enum.Font.GothamBold
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = Notification

	local Label = Instance.new("TextLabel")
	Label.Name = "Message"
	Label.Size = UDim2.new(1, -75, 0, 34)
	Label.Position = UDim2.new(0, 57, 0, 34)
	Label.BackgroundTransparency = 1
	Label.Text = Message
	Label.TextColor3 = Color3.fromRGB(190, 196, 210)
	Label.TextSize = 13
	Label.Font = Enum.Font.GothamMedium
	Label.TextWrapped = true
	Label.TextTruncate = Enum.TextTruncate.AtEnd
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.TextYAlignment = Enum.TextYAlignment.Top
	Label.Parent = Notification

	local ProgressBackground = Instance.new("Frame")
	ProgressBackground.Name = "ProgressBackground"
	ProgressBackground.Size = UDim2.new(1, -24, 0, 2)
	ProgressBackground.Position = UDim2.new(0, 12, 1, -5)
	ProgressBackground.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ProgressBackground.BackgroundTransparency = 0.88
	ProgressBackground.BorderSizePixel = 0
	ProgressBackground.Parent = Notification

	local Progress = Instance.new("Frame")
	Progress.Name = "Progress"
	Progress.Size = UDim2.new(1, 0, 1, 0)
	Progress.BackgroundColor3 = Colors[Type]
	Progress.BorderSizePixel = 0
	Progress.Parent = ProgressBackground

	Notification.Parent = Container

	Notification.Position = UDim2.new(0, 35, 0, 0)
	Notification.BackgroundTransparency = 1
	Stroke.Transparency = 1

	for _, Object in ipairs(Notification:GetDescendants()) do
		if Object:IsA("TextLabel") then
		Object.TextTransparency = 1
		end
	end

	local EnterTween = TweenService:Create(
		Notification,
		TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 0.12
		}
	)

	local StrokeTween = TweenService:Create(
		Stroke,
		TweenInfo.new(0.3),
		{Transparency = 0.82}
	)

	EnterTween:Play()
	StrokeTween:Play()

	for _, Object in ipairs(Notification:GetDescendants()) do
		if Object:IsA("TextLabel") then
		TweenService:Create(
			Object,
			TweenInfo.new(0.25),
			{TextTransparency = 0}
		):Play()
		end
	end

	TweenService:Create(
		Progress,
		TweenInfo.new(Duration, Enum.EasingStyle.Linear),
		{Size = UDim2.new(0, 0, 1, 0)}
	):Play()

	task.delay(Duration, function()
		if not Notification.Parent then
			return
		end

		local ExitTween = TweenService:Create(
			Notification,
			TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{
				Position = UDim2.new(0, 35, 0, 0),
				BackgroundTransparency = 1
			}
		)

		ExitTween:Play()

		TweenService:Create(
			Stroke,
			TweenInfo.new(0.22),
			{Transparency = 1}
		):Play()

		for _, Object in ipairs(Notification:GetDescendants()) do
			if Object:IsA("TextLabel") then
				TweenService:Create(
					Object,
					TweenInfo.new(0.15),
					{TextTransparency = 1}
				):Play()
			end
		end

		ExitTween.Completed:Wait()

		if Notification.Parent then
			Notification:Destroy()
		end
	end)

	return Notification
end

return Notify


