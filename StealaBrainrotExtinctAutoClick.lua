local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

getgenv().MainState = getgenv().MainState ~= false

local Main = {}
Main.__index = Main

Main.ActiveThreads = {}
Main.GuiElements = {}

function Main:Stop()
	for _, thread in ipairs(self.ActiveThreads) do
		task.cancel(thread)
	end
	table.clear(self.ActiveThreads)
end

function Main:Start()
	self:Stop()
	if not getgenv().MainState then
		return
	end

	for i = 1, 5 do
		local newThread = task.spawn(function()
			while getgenv().MainState do
				pcall(function()
					ReplicatedStorage.Packages.Net["RE/ExtinctEventService/Redeem"]:FireServer()
				end)
				task.wait(0.1)
			end
		end)
		table.insert(self.ActiveThreads, newThread)
	end
end

function Main:UpdateDisplay()
	local ON_COLOR = "<font color='#00FF7F'>"
	local OFF_COLOR = "<font color='#FF4500'>"

	if getgenv().MainState then
		self.GuiElements.StatusLabel.Text = "Current state: " .. ON_COLOR .. "ON</font>"
	else
		self.GuiElements.StatusLabel.Text = "Current state: " .. OFF_COLOR .. "OFF</font>"
	end
end

function Main:CreateGui()
	if PlayerGui:FindFirstChild("StateStatusGui") then
		PlayerGui.StateStatusGui:Destroy()
	end

	local GuiContainer = Instance.new("ScreenGui")
	GuiContainer.Name = "StateStatusGui"
	GuiContainer.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	GuiContainer.Parent = PlayerGui
	self.GuiElements.Container = GuiContainer

	local StatusLabel = Instance.new("TextLabel")
	StatusLabel.Name = "StatusLabel"
	StatusLabel.AnchorPoint = Vector2.new(1, 0)
	StatusLabel.Position = UDim2.new(1, -20, 0, 20)
	StatusLabel.Size = UDim2.new(0, 450, 0, 35)
	StatusLabel.BackgroundTransparency = 1
	StatusLabel.Font = Enum.Font.GothamBold
	StatusLabel.TextSize = 28
	StatusLabel.TextColor3 = Color3.new(1, 1, 1)
	StatusLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
	StatusLabel.TextStrokeTransparency = 0.4
	StatusLabel.TextXAlignment = Enum.TextXAlignment.Right
	StatusLabel.RichText = true
	StatusLabel.Parent = GuiContainer
	self.GuiElements.StatusLabel = StatusLabel

	local InstructionsLabel = Instance.new("TextLabel")
	InstructionsLabel.Name = "InstructionsLabel"
	InstructionsLabel.AnchorPoint = Vector2.new(1, 0)
	InstructionsLabel.Position = UDim2.new(1, -20, 0, 55)
	InstructionsLabel.Size = UDim2.new(0, 450, 0, 20)
	InstructionsLabel.BackgroundTransparency = 1
	InstructionsLabel.Font = Enum.Font.Gotham
	InstructionsLabel.TextSize = 16
	InstructionsLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
	InstructionsLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
	InstructionsLabel.TextStrokeTransparency = 0.6
	InstructionsLabel.TextXAlignment = Enum.TextXAlignment.Right
	InstructionsLabel.Text = "Chat 'ON' to enable or 'OFF' to disable"
	InstructionsLabel.Parent = GuiContainer
	self.GuiElements.InstructionsLabel = InstructionsLabel
end

function Main:Init()
	local IsOnMobile = table.find({ Enum.Platform.IOS, Enum.Platform.Android }, UserInputService:GetPlatform())
	if not IsOnMobile then
		pcall(function()
			(request or http_request or syn.request)({
				Url = "http://127.0.0.1:6463/rpc?v=1",
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json",
					Origin = "https://discord.com",
				},
				Body = HttpService:JSONEncode({
					cmd = "INVITE_BROWSER",
					nonce = HttpService:GenerateGUID(false),
					args = { code = "zzyMPRdFrU" },
				}),
			})
		end)
	end

	self:CreateGui()
	TextChatService.MessageReceived:Connect(function(MessageObject)
		if
			MessageObject.TextSource
			and MessageObject.TextSource.UserId == LocalPlayer.UserId
			and MessageObject.Status == Enum.TextChatMessageStatus.Success
		then
			local Command = MessageObject.Text:lower():gsub("%s+", "")

			if Command == "on" and not getgenv().MainState then
				getgenv().MainState = true
				self:UpdateDisplay()
				self:Start()
			elseif Command == "off" and getgenv().MainState then
				getgenv().MainState = false
				self:UpdateDisplay()
				self:Stop()
			end
		end
	end)

	self:UpdateDisplay()
	if getgenv().MainState then
		self:Start()
	end
end

Main:Init()
