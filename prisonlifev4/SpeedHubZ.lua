ver = "1.0.0"
local supports_fileio = (type(isfolder) == "function")
	and (type(makefolder) == "function")
	and (type(writefile) == "function")
	and (type(readfile) == "function")

local http_service = game:GetService("HttpService")
arrestcooldown = true
local configSys = {}
configSys.folder_path = "SpeedHubZ"
configSys.file_path = configSys.folder_path .. "/PrisonLifeV4.json"
configSys.defaults = {
	DisableShields = false,
	DisableVests = false,
	TaserBypass = false,
	AutoArrestByUsername = { args = {}, state = false },
	AutoArrestAll = false,
	RemoveDoors = false,
	RemoveFences = false,
	AutoFarmXP = false,
	AutoFarmItems = { args = {}, state = false },
	AutoEat = { args = {}, state = false },
	AntiLaydown = false,
	AutoGetGuns = { args = {}, state = false },
	SpoofWalkspeed = false,
}
local currentcar, carfound, seat = nil, false, nil
local seatConnection, carConnection = nil, nil
function configSys.copy_table(orig)
	if type(orig) ~= "table" then
		return orig
	end
	local new_tbl = {}
	for k, v in pairs(orig) do
		new_tbl[k] = configSys.copy_table(v)
	end
	return new_tbl
end
local HumanModCons = {}
local speed = 16
function configSys.merge_table(default_tbl, loaded_tbl)
	loaded_tbl = loaded_tbl or {}
	for k, def_val in pairs(default_tbl) do
		if type(def_val) == "table" then
			loaded_tbl[k] = configSys.merge_table(def_val, loaded_tbl[k])
		elseif loaded_tbl[k] == nil then
			loaded_tbl[k] = def_val
		end
	end
	return loaded_tbl
end
local Player = game.Players.LocalPlayer
local char = Player.Character
local hum = char:FindFirstChild("Humanoid")
local hrp = char:FindFirstChild("HumanoidRootPart")
function configSys.save_config(data)
	if not supports_fileio then
		return
	end
	if not isfolder(configSys.folder_path) then
		makefolder(configSys.folder_path)
	end
	local ok, encoded = pcall(http_service.JSONEncode, http_service, data)
	if not ok then
		warn("Failed to encode config:", encoded)
		return false
	end
	local write_ok, write_err = pcall(function()
		writefile(configSys.file_path, encoded)
	end)
	if not write_ok then
		warn("Failed to write config file:", write_err)
		return false
	end
	return true
end

function configSys.load_config()
	if not supports_fileio then
		return configSys.copy_table(configSys.defaults)
	end
	if not isfile(configSys.file_path) then
		configSys.save_config(configSys.defaults)
		return configSys.copy_table(configSys.defaults)
	end
	local file_content = readfile(configSys.file_path)
	local loaded_config
	local ok, result = pcall(function()
		return http_service:JSONDecode(file_content)
	end)
	loaded_config = ok and result or {}
	loaded_config = configSys.merge_table(configSys.defaults, loaded_config)
	configSys.save_config(loaded_config)
	return loaded_config
end

local config = configSys.load_config()
local Speed_Library =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/triquqd717/main/main/Modified-Optimized-V5.lua", true))()

local workspace = game.Workspace

local tools = {
	SVD = { tool = workspace.Prison_ITEMS.giver:GetChildren()[200].Union, action = "GetTool" },
}

local connections = {
	arrestEvent = nil,
}

local parts = {
	carspawner = CFrame.new(1613.35278, 153.925903, 2915.22485),
}
arrestadded = false

local curr = {
	["X"] = hrp.CFrame.X,
	["Y"] = hrp.CFrame.Y,
	["Z"] = hrp.CFrame.Z,
	["X_Rotation"] = hrp.CFrame:ToEulerAnglesXYZ(),
	["Y_Rotation"] = hrp.CFrame:ToEulerAnglesXYZ(),
	["Z_Rotation"] = hrp.CFrame:ToEulerAnglesXYZ(),
}

function arrestCriminals()
	if config.AutoArrestAll then
		if #game.Teams.Criminals:GetPlayers() > 0 then
			if arrestcooldown then
				local arrestEvent = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
					and game:GetService("ReplicatedStorage").Events:FindFirstChild("Arrest")
				for _, targetPlayer in pairs(game.Teams.Criminals:GetPlayers()) do
					if targetPlayer ~= Player then
						local playerRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
						local targetRoot = targetPlayer.Character
							and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
						if playerRoot and targetRoot then
							playerRoot.CanCollide = true
							playerRoot.Anchored = false
							for i = 1, 50 do
								local randomYRotation = math.random(-45, 45)
								local randomMovement =
									Vector3.new(math.random(-3, 3), math.random(-2, 1), math.random(-3, 3))
								local randomRotation = CFrame.Angles(0, math.rad(randomYRotation), 0)
								playerRoot.CFrame = targetRoot.CFrame * CFrame.new(randomMovement) * randomRotation
								playerRoot.CanCollide = false
								coroutine.wrap(function()
									arrestEvent:InvokeServer(targetPlayer)
								end)()
								task.wait(1 / 20)
							end
							for i = 1, 2 do
								coroutine.wrap(function()
									arrestEvent:InvokeServer(targetPlayer)
								end)()
							end
							playerRoot.CFrame = CFrame.new(curr["X"], curr["Y"], curr["Z"])
								* CFrame.Angles(curr["X_Rotation"], curr["Y_Rotation"], curr["Z_Rotation"])
							task.wait()
							playerRoot.CanCollide = true

							do
								task.wait(1 / 5)
								playerRoot.CFrame = CFrame.new(1624.52722, 153.736176, 2926.78735)
							end

							for i = 1, 15 do
								task.wait(1 / 15)
								coroutine.wrap(function()
									arrestEvent:InvokeServer(targetPlayer)
								end)()
							end
							arrestcooldown = false
						end
						task.wait(5.1)
						arrestcooldown = true
					end
				end
			else
				repeat
					task.wait()
				until arrestcooldown == true
				if config.AutoArrestAll then
					arrestCriminals()
				end
			end
		end
	else
		return
	end
end

local window = Speed_Library:CreateWindow({
	Title = "Speed Hub Z | Version: " .. ver .. " | discord.gg/speedhubx",
	TabWidth = 120,
	SizeUi = UDim2.fromOffset(550, 315),
})

local players = game:GetService("Players")
local player = players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local function teleportTo(teleportCFrame)
	if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = teleportCFrame
	else
		warn("Unable to teleport: Character or HumanoidRootPart not available.")
	end
end

local tabMain = window:CreateTab({ Name = "Main" })
local sectionMain = tabMain:AddSection("Main", true)
local tabESP = window:CreateTab({ Name = "ESP" })
local tabTeleport = window:CreateTab({ Name = "Teleports" })
local tabAuto = window:CreateTab({ Name = "Auto" })
local tabMisc = window:CreateTab({ Name = "Misc" })
local tabSettings = window:CreateTab({ Name = "Settings" })
local sectCriminal = tabTeleport:AddSection("Criminal's Spawns", false)
local sectGuards = tabTeleport:AddSection("Guard Spawns", false)
local sectHelipads = tabTeleport:AddSection("Helipads", false)
local sectLandmarks = tabTeleport:AddSection("Landmarks", false)
local sectWeapons = tabTeleport:AddSection("Weapons and Stores", false)
local sectSecrets = tabTeleport:AddSection("Secrets", false)
local sectOther = tabTeleport:AddSection("Other", false)

local SecAuto = tabAuto:AddSection("Auto", true)

sectionMain:AddButton({
	Title = "Discord Server Invite",
	Content = "https://discord.com/invite/speedhubx",
	Callback = function()
		setclipboard("https://discord.com/invite/speedhubx")
	end,
})

sectionMain:AddInput({
	Title = "Set Walkspeed",
	Content = "",
	Callback = function(text)
		local num = tonumber(text)
		if num then
			if num >= 0 then
				speed = text
			else
				Speed_Library:SetNotification({
					Title = "Error",
					Content = "Please input a positive number",
				})
			end
		end
	end,
})

sectionMain:AddToggle({
	Title = "Spoof Walkspeed",
	Content = "Enable to zoom around the map",
	Default = config.spoofwalkspeed,
	Callback = function(value)
		config.spoofwalkspeed = value
		configSys.save_config(config)
		if value then
			if char then
				local Human = char and char:FindFirstChildWhichIsA("Humanoid")
				local function WalkSpeedChange()
					if char and Human then
						Human.WalkSpeed = speed
					end
				end
				WalkSpeedChange()
				if HumanModCons.wsLoop then
					HumanModCons.wsLoop:Disconnect()
				end
				HumanModCons.wsLoop = Human:GetPropertyChangedSignal("WalkSpeed"):Connect(WalkSpeedChange)
				if HumanModCons.wsCA then
					HumanModCons.wsCA:Disconnect()
				end
				HumanModCons.wsCA = player.CharacterAdded:Connect(function(nChar)
					char = nChar
					Human = nChar:WaitForChild("Humanoid")
					WalkSpeedChange()
					if HumanModCons.wsLoop then
						HumanModCons.wsLoop:Disconnect()
					end
					HumanModCons.wsLoop = Human:GetPropertyChangedSignal("WalkSpeed"):Connect(WalkSpeedChange)
				end)
			else
				configSys.save_config(config)
				if HumanModCons.wsLoop then
					HumanModCons.wsLoop:Disconnect()
					HumanModCons.wsLoop = nil
				end
				if HumanModCons.wsCA then
					HumanModCons.wsCA:Disconnect()
					HumanModCons.wsCA = nil
				end
			end
		end
	end,
})

function shieldbypass()
	while config.DisableShields do
		task.wait(0.1)
		for _, target in pairs(workspace.Players:GetChildren()) do
			local torso
			local success = pcall(function()
				torso = target:FindFirstChild("Torso")
			end)
			if torso then
				local shieldFolder = torso:FindFirstChild("ShieldFolder")
				if shieldFolder then
					local shield = shieldFolder:FindFirstChild("Shield")
					if shield then
						shield:Destroy()
					end
				end
			end
		end
	end
end

sectionMain:AddToggle({
	Title = "Disable shields",
	Content = "Disable all shields in the game",
	Default = config.DisableShields,
	Callback = function(state)
		config.DisableShields = state
		configSys.save_config(config)
		print("DisableShields state:", state)
		if state then
			task.spawn(shieldbypass)
		end
	end,
})

function tasterbypass()
	while config.TaserBypass do
		task.wait(0.1)
		if player.Character and player.Character:FindFirstChild("ClientInputHandler") then
			local inputHandler = player.PlayerScripts:FindFirstChild("ClientInputHandler")
			if inputHandler and inputHandler.Disabled then
				inputHandler.Disabled = true
			end
			if player.Character:FindFirstChild("Humanoid") then
				player.Character.Humanoid.WalkSpeed = 24
				player.Character.Humanoid.JumpPower = 50
			end
		end
	end
end

sectionMain:AddToggle({
	Title = "Disable taser",
	Content = "WARNING!!! This might break the whole game, keep this in mind",
	Default = config.TaserBypass,
	Callback = function(state)
		config.TaserBypass = state
		configSys.save_config(config)
		print("TaserBypass state:", state)
		if state then
			task.spawn(tasterbypass)
		else
			local inputHandler = player:FindFirstChild("PlayerScripts")
				and player.PlayerScripts:FindFirstChild("ClientInputHandler")
			if inputHandler then
				inputHandler.Disabled = false
				inputHandler.Enabled = true
			end
		end
	end,
})

local teleportLocations = {
	["Criminal Base 1"] = CFrame.new(102.129456, 149.738617, 2477.70728),
	["Cargo Site"] = CFrame.new(55.8240929, 134.433441, 874.408752),
	["Mafia Base"] = CFrame.new(1492.99072, 67.2844391, 1316.92029),
	["Guard Spawn 1"] = CFrame.new(1886.33423, 155.522842, 2734.00024),
	["Guard Spawn 2"] = CFrame.new(2179.97803, 155.393112, 2670.39648),
	["Helipad 1"] = CFrame.new(1770.39905, 179.975189, 2693.81177),
	["Helipad 2"] = CFrame.new(1709.90491, 179.973297, 2693.99536),
	["Helipad 3"] = CFrame.new(88.9042969, 146.946503, 2407.87402),
	["Mountain Top"] = CFrame.new(1551.59021, 430.00592, 3868.20703),
	["Statue"] = CFrame.new(641.116455, 66.9512863, 1470.32971),
	["Mountain Logo"] = CFrame.new(2873.94678, 283.114197, 2819.88403),
	["SVD"] = CFrame.new(2881.87866, 252.463684, 2630.9375),
	["Gun Store"] = CFrame.new(1421.65015, 67.3662262, 1564.87244),
	["Yard"] = CFrame.new(1796.80005, 153.555191, 2916.90576),
	["Soccer"] = CFrame.new(2105.60425, 153.554581, 2877.61646),
	["Gun Boxes"] = CFrame.new(2331.0022, 155.542206, 2909.57666),
	["Metro"] = CFrame.new(702.816467, 76.1555862, 2174.64111),
	["Easter Egg"] = CFrame.new(2605.64771, 110.681999, 2105.89624),
	["Cat Place"] = CFrame.new(1170.49841, 67.0847092, 1580.48022),
	["Gas Station"] = CFrame.new(511.604462, 110.09758, 2006.36877),
}

local gunList = {
	["AA-12"] = CFrame.new(-188.136047, 113.907158, 1755.68311),
	["AK-47"] = CFrame.new(88.696701, 149.219421, 2475.49609),
	["AR-15"] = CFrame.new(846.670044, 123.997871, 3762.4502),
	["AS-50"] = CFrame.new(1432.29053, 65.7525177, 1560.80078),
	["AUG"] = CFrame.new(2226.05884, 159.44751, 2694.76392),
	["C4 Explosive"] = CFrame.new(1580.60413, 70.476944, 1370.38782),
	["DB"] = CFrame.new(920.262146, 108.774384, 2822.37085),
	["Desert Eagle"] = CFrame.new(1179.59131, 213.496643, 3306.69043),
	["FAL"] = CFrame.new(1423.37195, 65.8730011, 1544.72095),
	["FAMAS"] = CFrame.new(1848.7843, 156.138535, 2669.70435),
	["FN P90"] = CFrame.new(1396.32312, 64.7226562, 1567.69141),
	["Flamethrower"] = CFrame.new(201.641617, 110.077385, 1334.26172),
	["G36C"] = CFrame.new(1734.20312, 157.495865, 2797.06641),
	["Glock-17"] = CFrame.new(1409.96191, 65.8316193, 1557.5481),
	["HK G3"] = CFrame.new(846.670044, 123.978935, 3762.4502),
	["HK416"] = CFrame.new(2210.84814, 159.227341, 2724.08154),
	["IA2"] = CFrame.new(1881.05884, 158.276184, 2669.63745),
	["Key"] = CFrame.new(295.3881530761719, 124.19115447998047, 919.0430908203125),
	["M14"] = CFrame.new(846.670044, 123.997871, 3759.16626),
	["M16"] = CFrame.new(1396.18909, 68.9390869, 1558.37585),
	["M16A1"] = CFrame.new(846.670044, 123.997871, 3755.7041),
	["M249"] = CFrame.new(1755.61218, 155.909851, 2804.68481),
	["M4A1"] = CFrame.new(1409.7207, 66.1336136, 1568.03137),
	["M82"] = CFrame.new(23.2418766, 138.271286, 951.470703),
	["M9"] = CFrame.new(1842.24536, 158.969223, 2695.45459),
	["MG4"] = CFrame.new(1850.22156, 160.108734, 2669.78613),
	["MG42"] = CFrame.new(846.670044, 123.997871, 3745.33643),
	["MP5"] = CFrame.new(2210.23633, 155.793289, 2724.1123),
	["MP5SD"] = CFrame.new(44.0023689, 150.729721, 2407.16724),
	["Medkit"] = CFrame.new(94.6815186, 148.534668, 2461.19556),
	["Metal Shield"] = CFrame.new(195.933868, 111.041504, 1348.14612),
	["Minigun"] = CFrame.new(1469.75378, 68.2874451, 1333.27893),
	["Nyan Cat"] = CFrame.new(830.470032, 123.997864, 4046.76855),
	["RPG-7"] = CFrame.new(40.0003662, 148.278351, 915.015747),
	["Remington 700"] = CFrame.new(1737.89282, 156.240082, 2797.45972),
	["Remington 870"] = CFrame.new(2235.55908, 156.552216, 2698.82373),
	["Riot Shield"] = CFrame.new(1864.94543, 157.898544, 2669.69434),
	["Rocket Launcher"] = CFrame.new(1427.98425, 67.3662262, 1540.7738),
	["SCAR"] = CFrame.new(1438.39001, 65.872551, 1563.50232),
	["SPAS-12"] = CFrame.new(1433.03906, 65.9381866, 1544.78076),
	["SVD"] = CFrame.new(2876.73022, 249.057236, 2620.01978),
	["Shrike"] = CFrame.new(79.9646835, 151.285934, 2462.66699),
	["Stun Stick"] = CFrame.new(822.170044, 123.997864, 3780.46265),
	["Thompson"] = CFrame.new(1500.14697, 67.2209473, 1356.57874),
	["USAS-12"] = CFrame.new(838.670044, 123.997864, 3780.46265),
	["UZI"] = CFrame.new(1409.59558, 66.142868, 1571.92639),
}

sectCriminal.Description = "Teleport to Criminal bases"
sectCriminal:AddDropdown({
	Title = "Criminal Bases",
	Content = "Select a base to teleport to",
	Options = { "Criminal Base 1", "Cargo Site", "Mafia Base" },
	Callback = function(selected)
		local location = selected[1]
		local cf = teleportLocations[location]
		if cf then
			teleportTo(cf)
		end
	end,
})

sectGuards.Description = "Teleport to Guard spawns"
sectGuards:AddDropdown({
	Title = "Guard Spawns",
	Content = "Select a spawn to teleport to",
	Options = { "Guard Spawn 1", "Guard Spawn 2" },
	Callback = function(selected)
		local location = selected[1]
		local cf = teleportLocations[location]
		if cf then
			teleportTo(cf)
		end
	end,
})

sectHelipads.Description = "Teleport to helipads"
sectHelipads:AddDropdown({
	Title = "Helipads",
	Content = "Select a helipad to teleport to",
	Options = { "Helipad 1", "Helipad 2", "Helipad 3" },
	Callback = function(selected)
		local location = selected[1]
		local cf = teleportLocations[location]
		if cf then
			teleportTo(cf)
		end
	end,
})

sectLandmarks.Description = "Teleport to landmarks"
sectLandmarks:AddDropdown({
	Title = "Landmarks",
	Content = "Select a landmark to teleport to",
	Options = { "Mountain Top", "Mountain Logo", "Yard", "Soccer" },
	Callback = function(selected)
		local location = selected[1]
		local cf = teleportLocations[location]
		if cf then
			teleportTo(cf)
		end
	end,
})

local weaponNames = {}
for name, _ in pairs(gunList) do
	table.insert(weaponNames, name)
end
table.sort(weaponNames)
sectWeapons:AddDropdown({
	Title = "Weapon and Stores",
	Content = "Select a weapon place to teleport to",
	Options = weaponNames,
	Callback = function(selected)
		local location = selected[1]
		local cf = gunList[location]
		if cf then
			teleportTo(cf)
		end
	end,
})

sectSecrets:AddDropdown({
	Title = "Secret Places",
	Content = "Select a secret place to teleport to",
	Options = { "Easter Egg", "Cat Place" },
	Callback = function(selected)
		local location = selected[1]
		local cf = teleportLocations[location]
		if cf then
			teleportTo(cf)
		end
	end,
})

sectOther:AddDropdown({
	Title = "Other places",
	Content = "Select a place to teleport to",
	Options = { "Metro", "Statue", "Gas Station" },
	Callback = function(selected)
		local location = selected[1]
		local cf = teleportLocations[location]
		if cf then
			teleportTo(cf)
		end
	end,
})

local function cleanup()
	if seatConnection then
		seatConnection:Disconnect()
		seatConnection = nil
	end
	if carConnection then
		carConnection:Disconnect()
		carConnection = nil
	end
end

local function validateCharacter()
	return Player.Character and hum and hum:IsDescendantOf(workspace) and hrp and hrp:IsDescendantOf(workspace)
end

local function attemptSit()
	if not validateCharacter() or not seat then
		return false
	end
	local success, err = pcall(function()
		if seat.Occupant ~= hum then
			seat:Sit(hum)
			return true
		end
	end)
	if not success then
		return false
	end
	return success
end

local getcar
local function processCar(child)
	if child.Name ~= "Squad" then
		return false
	end
	local Body = child:FindFirstChild("Body") or child:WaitForChild("Body", 15)
	if not Body then
		return false
	end
	local VehicleSeat = Body:FindFirstChild("VehicleSeat") or Body:WaitForChild("VehicleSeat", 10)
	if not VehicleSeat then
		return false
	end
	currentcar, seat = child, VehicleSeat
	local seated = false
	for attempt = 1, 8 do
		if attemptSit() then
			seated = true
			task.wait()
			break
		end
	end
	if not seated then
		currentcar = nil
		seat = nil
		carfound = false
		task.wait(10)
		getcar()
		return false
	end
	seatConnection = hum.StateChanged:Connect(function(_, new)
		if new == Enum.HumanoidStateType.Seated then
			cleanup()
			carfound = true
			task.wait(1.5)
			if config.AutoArrestAll then
				while true do
					if seat ~= nil then
						arrestCriminals()
					end
					task.wait()
				end
			end
		end
	end)
	return true
end

getcar = function()
	if not config.AutoArrestAll then
		return
	end
	cleanup()
	currentcar, carfound, seat = nil, false, nil
	local startTime = os.clock()
	pcall(function()
		hrp.CFrame = parts.carspawner
	end)
	task.wait(0.4)
	local success
	if currentcar == nil then
		success = pcall(function()
			game.ReplicatedStorage.Events.Interact:InvokeServer(
				workspace.Prison_ITEMS.buttons["Car Spawner"]["Car Spawner"],
				"Buttons"
			)
		end)
	end
	if not success then
		return
	end
	carConnection = workspace.CarContainer.ChildAdded:Connect(function(child)
		if processCar(child) then
			cleanup()
		end
	end)
	for _, child in ipairs(workspace.CarContainer:GetChildren()) do
		if processCar(child) then
			break
		end
	end
	while os.clock() - startTime < 30 and not carfound do
		task.wait(0.1)
	end
	cleanup()
end

workspace.CarContainer.ChildRemoved:Connect(function(child)
	if child == currentcar then
		currentcar = nil
		carfound = false
		seat = nil
		if config.AutoArrestAll then
			task.wait()
			getcar()
		end
	end
end)

game.Players.LocalPlayer.CharacterAdded:Connect(function(newChar)
	char = newChar
	if char then
		if hum then
			if config.AutoArrestAll then
				task.wait(1)
				if seat ~= nil then
					seat:Sit(hum)
				else
					getcar()
				end
			end
		end
	end
end)

local autoArrestCharAddedConnection = nil

SecAuto:AddToggle({
	Title = "Auto Arrest Criminals",
	Content = "",
	Default = config.AutoArrestAll,
	Callback = function(value)
		config.AutoArrestAll = value
		configSys.save_config(config)
		if not value then
			cleanup()
			seat = nil
			currentcar = nil
			carfound = false
			if autoArrestCharAddedConnection then
				autoArrestCharAddedConnection:Disconnect()
				autoArrestCharAddedConnection = nil
			end
			return
		end
		task.spawn(function()
			if hrp then
				if seat then
					seat, currentcar, carfound = nil, nil, false
					task.wait()
				end
				getcar()
			else
				if autoArrestCharAddedConnection then
					autoArrestCharAddedConnection:Disconnect()
					autoArrestCharAddedConnection = nil
				end
				autoArrestCharAddedConnection = Player.CharacterAdded:Connect(function(newchar)
					local hr = newchar:WaitForChild("HumanoidRootPart")
					if hr then
						if seat then
							local success = pcall(function()
								seat:Sit(hum)
							end)
							if not success then
								currentcar, seat, carfound = nil, nil, false
							end
						else
							currentcar, seat, carfound = nil, nil, false
							task.wait()
							getcar()
						end
					end
				end)
			end
			cleanup()
		end)
	end,
})

hum.StateChanged:Connect(function(old, new)
	if new ~= Enum.HumanoidStateType.Seated then
		if seat then
			seat:Sit(hum)
		end
	end
end)

while true do
	configSys.save_config(config)
	task.wait(5)
end

while true do
	if seat then
		task.wait(3)
		if config.AutoArrestAll then
			local scuccess = pcall(function()
				seat:Sit()
			end)
			if not scuccess then
				local successss = pcall(function()
					currentcar:Destroy()
					seat:Destroy()
				end)
				currentcar, seat, carfound = nil, nil, false
				if hrp then
					getcar()
				else
					repeat task.wait() until hrp
					getcar()
				end
			end
		end
	else
  		print("wtf?")
	end
	task.wait()
end
