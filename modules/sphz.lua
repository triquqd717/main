
local sphz = {}
local modulever = "1.0.6"
function sphz:Initialize()
	self.rs = game:GetService("ReplicatedStorage")
	self.vim = game:GetService("VirtualInputManager")
	self.players = game:GetService("Players")
	self.player = game.Players.LocalPlayer
	self.httpservice = game:GetService("HttpService")
	self.playergui = self.player.PlayerGui
	self.backpack = self.player.Backpack
	self.player.CharacterAdded:Connect(function(char)
		self.char = char
		self.hum = char:WaitForChild("Humanoid")
		self.root = char:WaitForChild("HumanoidRootPart")
	end)
	if self.player.Character then
		self.char = self.player.Character
		self.hum = self.char:WaitForChild("Humanoid")
		self.root = self.char:WaitForChild("HumanoidRootPart")
	end
	print("module initalized, module version: " .. modulever)
end

function sphz:GetTo(pos)
	if not self.root or not self.root.Parent then
		warn("char not initialized, function: GetTo")
		return
	end
	local success, err = pcall(function()
		if self.char and self.root then
			self.root.CFrame = pos
		else
			print("nuh uh")
			return
		end
	end)
	if not success then
		warn("error: " .. tostring(err))
	end
end

function sphz:TweenTo(pos)
	local targetCFrame = pos
	if not self.root or not self.root.Parent then
		warn("char not initialized, function: TweenTo")
		return
	end
	local success, err = pcall(function()
		local tween = game:GetService("TweenService"):Create(
			self.root,
			TweenInfo.new(1, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
			{ CFrame = targetCFrame }
		)
		tween:Play()
	end)
	if not success then
		warn("function: TweenTo, error: " .. tostring(err))
	end
end

function sphz:FireServer(func, ...)
	local args = { ... }
	local success, err = pcall(function()
		func:FireServer(unpack(args))
	end)
	if not success then
		warn("function: FireServer, error: " .. tostring(err))
	end
end

function sphz:FirePrompt(prompt)
	local success, err = pcall(function()
		fireproximityprompt(prompt)
	end)
	if not success then
		warn("function: FirePrompt, error: " .. tostring(err))
	end
end

function sphz:HasRod(rod)
	local playerStats = game:GetService("ReplicatedStorage").playerstats:FindFirstChild(self.player.Name)
	if not playerStats then
		return false
	end
	return playerStats.Rods:FindFirstChild(rod) ~= nil
end

function sphz:SelectRod(rod)
	local success, err = pcall(function()
		game:GetService("ReplicatedStorage").packages.Net["RE/Rod/Equip"]:FireServer(rod)
	end)
	if not success then
		warn("function: SelectRod, error: " .. tostring(err))
	end
end

function sphz:EquipTool(tool)
	local equip = self.backpack:FindFirstChild(tool)
	if equip then
		game.ReplicatedStorage.packages.Net["RE/Backpack/Equip"]:FireServer(equip)
		return true
	else
		warn("tool was not found, function: EquipTool")
		return false
	end
end

function sphz:UnequipTool(tool)
	local equip = self.char:FindFirstChild(tool)
	if equip then
		game.ReplicatedStorage.packages.Net["RE/Backpack/Equip"]:FireServer(equip)
	end
end

function sphz:CheckTool(tool)
	if not self.backpack or not self.char then
		warn("char/backpack not initialized, function: CheckTool")
		return "not found"
	end
	if self.backpack:FindFirstChild(tool) then
		return "backpack"
	elseif self.char:FindFirstChild("Tool") then
		return "character"
	else
		return "not found"
	end
end

function sphz:GetMagnitude(pos)
	local targetPosition = (typeof(pos) == "CFrame") and pos.Position or pos

	if not (self.char and self.root) then
		warn("player character not found, function: GetMagnitude")
		return 0
	end

	return (targetPosition - self.root.Position).Magnitude
end
local req = Xeno.http_request or Xeno.request or request

function Send(url, title, description, name, value)
	if not req then
		warn("HTTP request library not loaded")
		return
	end

	local payload = {
		["content"] = "",
		["embeds"] = {
			{
				["title"] = title or "nil",
				["description"] = description or "nil",
				["type"] = "rich",
				["color"] = tonumber("0x212f3c"),
				["fields"] = {
					{
						["name"] = name or "Instance ID",
						["value"] = value or Xeno.PID or "none",
						["inline"] = true,
					},
				},
			},
		},
	}

	local data = req({
		Url = url,
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json",
		},
		Body = sphz.httpservice:JSONEncode(payload),
	})
end

function sphz:BuyShop(item, type, amount)
	self.rs.events.purchase:FireServer(item, type, amount)
end

function sphz:NearestPromptCheck(maxDistance, promptName)
    if not self.root then
        warn("Character root not initialized")
        return nil
    end
    local nearestPrompt = nil
    local shortestDistance = maxDistance or math.huge
    for _, obj in ipairs(game.Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            if not promptName or obj.Name == promptName then
                local parentPart = obj.Parent
                if parentPart and parentPart:IsA("BasePart") then
                    local dist = (self.root.Position - parentPart.Position).Magnitude
                    if dist < shortestDistance then
                        shortestDistance = dist
                        nearestPrompt = obj
                    end
                end
            end
        end
    end
    
    return nearestPrompt, shortestDistance
end


function sphz:NearestPrompt(promptName)
	local nearestPrompt, shortestDistance = self:NearestPromptCheck(math.huge, promptName)
	if nearestPrompt then
		self:FirePrompt(nearestPrompt)
	end
end

function sphz:Interact(button)
	local GuiService = game:GetService("GuiService")
	GuiService.SelectedObject = button
	self.vim:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
	self.vim:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
	task.wait(1 / 20)
	GuiService.SelectedObject = nil
end

function sphz:Run_Loop(name, func)
	if not self.activeLoops then
		self.activeLoops = {}
	end
	if self.activeLoops[name] then
		self:Stop_Loop(name)
	end
	self.activeLoops[name] = true
	task.spawn(function()
		while self.activeLoops[name] do
			local success, err = pcall(func)
			if not success then
				warn("Error in loop '" .. name .. "': " .. tostring(err))
			end
			task.wait(0.1)
		end
	end)
end

function sphz:Stop_Loop(name)
	if self.activeLoops and self.activeLoops[name] then
		self.activeLoops[name] = nil
	end
end

return sphz
