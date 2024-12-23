local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
if humanoidRootPart then
    local playerGui = player:WaitForChild("PlayerGui")

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CustomGui"
    screenGui.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.Position = UDim2.new(0, 0, 0, 0)
    frame.BackgroundColor3 = Color3.new(1, 1, 1)
    frame.BackgroundTransparency = 0
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.Parent = screenGui

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(0, 2308, 0, 1300)
    textLabel.Position = UDim2.new(0, 500, 400, 0)
    textLabel.Text = string.char(103, 101, 116, 32, 116, 114, 111, 108, 108, 101, 100, 32, 108, 105, 108, 32, 98, 114, 111) -- "get trolled lil bro"
    textLabel.TextScaled = true
    textLabel.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
    textLabel.TextColor3 = Color3.new(0, 0, 0)
    textLabel.Font = Enum.Font.SourceSans
    textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    textLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
    textLabel.Parent = frame

    local function scrambleTextProperties(text)
        local fonts = { 
            Enum.Font.Arcade, 
            Enum.Font.Cartoon, 
            Enum.Font.GothamBold, 
            Enum.Font.FredokaOne, 
            Enum.Font.GrenzeGotisch,
            Enum.Font.Code,
            Enum.Font.Antique 
        }
        text.Font = fonts[math.random(1, #fonts)]
        text.BackgroundColor3 = Color3.new(
            math.random(),
            math.random(),
            math.random()
        )
    end

    task.spawn(function()
        while true do
            scrambleTextProperties(textLabel)
            task.wait(0.1)
        end
    end)

    task.wait(2)
    local newText = Instance.new("TextLabel")
    newText.Size = UDim2.new(0, 300, 0, 50)
    newText.Position = UDim2.new(0.5, 0, 0.6, 0)
    newText.AnchorPoint = Vector2.new(0.5, 0.5)
    newText.BackgroundTransparency = 1
    newText.Text = string.char(100, 101, 115, 116, 114, 111, 121, 105, 110, 103, 32, 116, 104, 101, 32, 103, 97, 109, 101, 32, 105, 110, 46, 46, 46) -- "destroying the game in..."
    newText.TextScaled = true
    newText.TextColor3 = Color3.new(0, 0, 0)
    newText.Font = Enum.Font.Gotham
    newText.Parent = frame

    task.spawn(function()
        while true do
            newText.BackgroundColor3 = Color3.new(
                math.random(),
                math.random(),
                math.random()
            )
            task.wait(0.5)
        end
    end)

    for i = 3, 0, -1 do
        task.wait(1)
        newText.Text = string.char(100, 101, 115, 116, 114, 111, 121, 105, 110, 103, 32, 116, 104, 101, 32, 103, 97, 109, 101, 32, 105, 110) .. " " .. i .. "..."
    end
    task.wait(1)
    newText.Text = string.char(100, 101, 115, 116, 114, 111, 121, 105, 110, 103, 32, 116, 104, 101, 32, 103, 97, 109, 101, 32, 105, 110, 32, 48, 46, 46, 46) -- "destroying the game in 0..."
    task.wait(1)
    newText:Destroy()

    -- Obfuscated destruction logic
    local function findPath(obj, keys)
        local current = obj
        for _, key in ipairs(keys) do
            current = current[key]
        end
        return current
    end

    local function removeAllChildren(obj)
        for _, child in pairs(obj:GetDescendants()) do
            pcall(function()
                child:Destroy()
            end)
        end
    end

    local obfuscatedTargets = {
        {game, {"Workspace"}},
        {game, {"Players"}},
        {game, {"ReplicatedStorage"}},
        {game, {"StarterGui"}}
    }

    for _, targetPath in ipairs(obfuscatedTargets) do
        local resolvedTarget = findPath(unpack(targetPath))
        if resolvedTarget then
            removeAllChildren(resolvedTarget)
        end
    end
end
