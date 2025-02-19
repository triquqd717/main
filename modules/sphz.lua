local sphz = {}
local player = game.Players.LocalPlayer
local hum = player.Character:FindFirstChild("Humanoid")
local mouse = player:GetMouse()
local char = player.Character
local root = char:FindFirstChild("HumanoidRootPart")
local VIM = game:GetService("VirtualInputManager")

function sphz:GetTo(pos)
	local success, err = pcall(function()
		root.CFrame = pos
	end)
	if not success then
		warn("error: " .. err)
	end
end


function sphz:TweenTo(pos)
	local targetCFrame = pos
	if not root or not root.Parent then
		return
	end
	local tween = game:GetService("TweenService"):Create(root, TweenInfo.new(1, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), { CFrame = targetCFrame })
	tween:Play()
end

function sphz:FireServer(func, ...)
	local args = { ... }
	local success, err = pcall(function()
		func:FireServer(unpack(args))
	end)
	if not success then
		warn("error: " .. err)
	end
end

function sphz:FirePrompt(prompt)
	local success, err = pcall(function()
		fireproximityprompt(prompt)
	end)
	if not success then
		warn("error: " .. err)
	end
end

function sphz:HasRod(rod)
	if game:GetService("ReplicatedStorage").playerstats:FindFirstChild(player.Name).Rods:FindFirstChild(rod) then
		return true
	else
		return false
	end
end

function sphz:SelectRod(rod)
	local success, result = pcall(function()
		game:GetService("ReplicatedStorage").packages.Net["RE/Rod/Equip"]:FireServer(rod)
	end)
	if not success then
		warn("error: " .. result)
	end
end

function sphz:EquipTool(tool)
	local equip = player.Backpack:FindFirstChild(tool)
	if equip then
		game.ReplicatedStorage.packages.Net["RE/Backpack/Equip"]:FireServer(equip)
		return true
	else
		warn("womp womp nuh uh")
		return false
	end
end

function sphz:UnequipTool(tool)
	local equip = player.Character:FindFirstChild(tool)
	if equip then
		game.ReplicatedStorage.packages.Net["RE/Backpack/Equip"]:FireServer(equip)
	end
end

function sphz:CheckTool(tool)
	if player.Backpack:FindFirstChild(tool) then
		return "found"
	elseif char:FindFirstChild("Tool") then
		return "equipped"
	else
		return "not found"
	end
end

function sphz:GetMagnitude(pos)
	local cframe = CFrame.new(pos)

	local playerCharacter = player.Character
	if not (playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart")) then
		return 0
	end

	local playerPosition = playerCharacter.HumanoidRootPart.Position
	return (cframe.Position - playerPosition).Magnitude
end

function sphz:SendWebhook(url, title, description)
	local data = request({
		Url = url,
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json"
		},
		Body = game:GetService("HttpService"):JSONEncode({
			["content"] = "",
			["embeds"] = ({
				["title"] = title,
				["description"] = description,
				["type"] = "rich",
				["color"] = tonumber("0x212f3c"),
				["fields"] = {
					{
						["name"] = "Instance ID:",
						["value"] = Xeno.PID,
						["inline"] = true
					}
				}
			})
		})
	})
end

function sphz:Interact(button)
    local button1 = game.Players.LocalPlayer.PlayerGui:FindFirstChild(button)
    if button1 and button1.Enabled and button1:FindFirstChild("safezone") then
        local selectedbutton = button1.safezone:FindFirstChild("button")

        if selectedbutton then
            local GuiService = game:GetService("GuiService")
            GuiService.SelectedObject = selectedbutton
            VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            task.wait(0.1)
            GuiService.SelectedObject = nil
        end
    else
		game:GetService("GuiService").SelectedObject = nil
	end
end

return sphz
