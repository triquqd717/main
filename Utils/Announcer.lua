local HttpService = game:GetService("HttpService")
local Frame = game:GetService("Players").LocalPlayer.PlayerGui.Top_Notification.Frame
local Conn
local WS = "ws://localhost:3055/"
local Start

local Exact = {
	["No one submitted to the Harvest... No rewards"] = true,
	["You have accepted the trade!"] = true,
	["Your target is ineligible to receive gifts right now! They have too many fruits."] = true,
	["You didnt submit to the Harvest... No rewards"] = true,
	["The Traveling Merchant has arrived"] = true,
	["The Traveling Merchant has left"] = true,
	["Trade expired!"] = true,
	["You can only place your pets in your garden!"] = true,
	["The Beanstalk is growing!!"] = true,
}

local Wildcard = {
	["gift has been sent to"] = true,
	["liked your farm"] = true,
	["stole from"] = true,
	["kitsune applied"] = true,
	["gets a bonus reward for"] = true,
}

function log(...)
	print(`<t:${os.time()}:t>`, ...)
end

function check(text)
	text = text:lower()
	for key in pairs(Exact) do
		if text == key:lower() then
			log("Exact match found. Skipping:", key)
			return true
		end
	end

	for key in pairs(Wildcard) do
		if text:find(key:lower()) then
			log("Wildcard match found. Skipping:", key)
			return true
		end
	end

	log("No filter matched. Passing:", text)
	return false
end

function notag(text, skip)
	if skip then
		return text
	end
	return text:gsub("<[^>]+>", "")
end

function send(text, skip)
	log("send() called with text:", text, " | skip:", skip)

	local CleanText = notag(text, skip == true)
	log("Cleaned text:", CleanText)

	if not text then
		log("Text is nil, bailing send()")
		return
	end

	local Data = {
		content = CleanText,
	}
	local JSONData = HttpService:JSONEncode(Data)
	log("Encoded JSON data:", JSONData)

	if not Conn then
		log("WebSocket not connected. Trying to connect...")
		Conn = WebSocket.connect(WS)
		print("Conn after WebSocket.connect:", Conn)

		if Conn then
			log("Connected to WebSocket successfully!")
			Start = os.clock()
			Conn.OnClose:Connect(function()
				log("WebSocket connection closed after", os.clock() - (Start or 0), "seconds")
				Conn = nil
			end)
		else
			warn("WebSocket connect failed.")
		end
	else
		log("WebSocket is already connected.")
	end

	if Conn then
		log("Attempting to send CleanText:", CleanText)
		Conn:Send(CleanText)
		log("Sent to WebSocket:", CleanText)
	else
		warn("Cannot send, WebSocket connection is dead")
	end
end

local lastTExt = ""

Frame.ChildAdded:Connect(function(notif)
	if notif.Name == "Notification_UI" or notif.Name == "Notification_UI_Mobile" then
		log("New notification:", notif.Name)
		local Label = notif:FindFirstChild("TextLabel")
		if Label then
			local raw = Label.Text

			local allowFont = raw:find("was restocked")
				or raw:lower():find("jandel</font>")
				or raw:lower():find("elce</font>")
				or raw:lower():find("icial</font>")
				or raw:lower():find("am</font>")

			if not raw:find("<font") or allowFont then
				local clean = notag(raw)
				if not check(clean) then
					local Final = clean
					Final = Final == "Not your garden!" and "test message" or Final
					Final = Final:gsub("@everyone", "@eh?veryone"):gsub("@here", "@eh?ere")
					if raw:find("was restocked") then
						Final = "```" .. clean .. "```"
					end
					Final = Final:gsub("", "")
					if lastTExt == Final then
						return
					end
					send(Final)
					lastTExt = Final
				end
			else
				log("Skipped due to font tag and not allowed exception:", raw)
			end
		end
	end
end)

task.spawn(function() -- anti afk
	local Player = game:GetService("Players").LocalPlayer
	Player.Idled:Connect(function()
		log("Anti-AFK triggered")
		local VirtualUser = game:GetService("VirtualUser")
		VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
		task.wait(0.1)
		VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
	end)
end)
