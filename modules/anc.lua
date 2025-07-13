local HttpService = game:GetService("HttpService")
local Frame = game:GetService("Players").LocalPlayer.PlayerGui.Top_Notification.Frame

local WS = "ws://localhost:3054/"
local Conn
local Start

local Exact = {
	["No one submitted to the Harvest... No rewards"] = true,
	["You have accepted the trade!"] = true,
	["Your target is ineligible to receive gifts right now! They have too many fruits."] = true,
	["You didnt submit to the Harvest... No rewards"] = true,
	["The Traveling Merchant has arrived"] = true,
	["The Traveling Merchant has left"] = true,
}

local Wildcard = {
	["gift has been sent to"] = true,
	["liked your farm"] = true,
	["stole from"] = true,
}

function check(text)
	text = text:lower()

	for key in pairs(Exact) do
		if text == key:lower() then
			return true
		end
	end

	for key in pairs(Wildcard) do
		if text:find(key:lower()) then
			return true
		end
	end

	return false
end

function notag(text, skip)
	if skip then
		return text
	end

	return text:gsub("<[^>]+>", "")
end

function send(text, skip)
	local CleanText
	CleanText = notag(text, skip == true)
	local Data = {
		content = CleanText,
	}
	local JSONData = HttpService:JSONEncode(Data)
	if not Conn then
		Conn = WebSocket.connect(WS)
		if Conn then
			Start = os.clock()
			Conn.OnClose:Connect(function()
				print("WebSocket connection closed after " .. os.clock() - (Start or 0) .. " seconds")
				Conn = nil
			end)
		else
			warn("Failed to connect to WebSocket")
		end
	end
	if Conn then
		Conn:Send(CleanText)
		print("Sent to WebSocket:", CleanText)
	else
		warn("WebSocket connection is not open")
	end
end

Frame.ChildAdded:Connect(function(notif)
	if notif.Name == "Notification_UI" then
		local Label = notif:FindFirstChild("TextLabel")
		if Label then
			if not string.find(Label.Text, "<font") or string.find(Label.Text, "was restocked") then
				local clean = notag(Label.Text)
				if not check(clean) then
					local Final = clean
					Final = Final == "Not your garden!" and "test message" or Final
					Final = Final:gsub("@everyone", "@eh?veryone"):gsub("@here", "@th?ere")
					if string.find(Label.Text, "was restocked") then
						Final = "```" .. clean .. "```"
					end
					send(Final)
				end
			end
		end
	end
end)

task.spawn(function() -- anti afk
	local Player = game:GetService("Players").LocalPlayer
	Player.Idled:Connect(function()
		local VirtualUser = game:GetService("VirtualUser")
		VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
		task.wait(0.1)
		VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
	end)
end)

local Alias = { -- aliases
	["Obby"] = "🧗 Obby",
	["Gale"] = "🌪️ Gale",
	["SheckleRain"] = "💰 Sheckle Rain",
	["MeteorShower"] = "☄️ Meteor Shower",
	["Disco"] = "🪩 Disco",
	["ChocolateRain"] = "🍫 Chocolate Rain",
	["JandelStorm"] = "⚡ Jandel Storm",
	["DJJhai"] = "🎧 DJ Jhai",
	["Tornado"] = "🌪️ Tornado",
	["JandelLazer"] = "🦸 Jandel Lazer",
	["Blackhole"] = "👽 Black Hole",
	["Rainbow"] = "🌈 Rainbow",
	["JandelFloat"] = "🪁 Floating Jandel",
	["Windy"] = "🍃 Windy",
	["SunGod"] = "🌞 Sun God",
	["Volcano"] = "🌋 Volcano",
	["MeteorStrike"] = "☄️ Meteor Strike",
	["Heatwave"] = "🔥 Heatwave",
	["AlienInvasion"] = "👽 Alien Invasion",
	["SpaceTravel"] = "🚀 Space Travel",
	["UnderTheSea"] = "🌊 Under the Sea",
	["Thunderstorm"] = "⚡ Thunderstorm",
	["SolarFlare"] = "🌞 Solar Flare",
	["Drought"] = "🌞 Drought",
	["TropicalRain"] = "🍋‍🟩 Tropical Rain",
	["ChickenRain"] = "🐔 Chicken Rain",
	["AuroraBorealis"] = "🌌 Aurora Borealis",
	["Sandstorm"] = "🌪 Sandstorm",
	["ShootingStars"] = "🌠 Shooting Stars",
	["DJSandstorm"] = "🎧 DJ Sandstorm",
	["Rain"] = "🌧 Rain",
	["PoolParty"] = "🏊 Pool Party",
	["AirHead"] = "🪂 Air Head",
	["TextCollect"] = "📝 Text Collect",
	["CrystalBeams"] = "🔮 Crystal Beams",
	["JandelZombie"] = "🧟 Zombie Attack",
}

game.ReplicatedStorage.GameEvents.WeatherEventStarted.OnClientEvent:Connect(
	function(EventType, Duration) -- weather events
		local EndTime = math.floor(os.time() + Duration)
		send( -- send to redis
			"_"
				.. (Alias[EventType] or EventType)
				.. " weather has started!_ \nDuration: "
				.. Duration
				.. " seconds\nEnds: <t:"
				.. EndTime
				.. ":R>",
			true
		)
	end
)
