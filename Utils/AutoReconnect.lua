local Debounce = 0
local Conn = game.PlaceId == 109983668079237 and WebSocket.connect("ws://localhost:6070/")

local function Signal()
	local now = os.time()
	if now > Debounce then
		if game.PlaceId == 109983668079237 then
			local success = pcall(function()
				Conn:Send("kicked")
			end)
			if not success then
				game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
			end
		elseif game.PlaceId == 126884695634066 then
			game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
		end
		Debounce = now + 1
	end
end

if #game:GetService("GuiService"):GetErrorMessage() > 0 then
	Signal()
end

game:GetService("GuiService").ErrorMessageChanged:Connect(function()
	Signal()
end)

local old
old = hookfunction(game.Players.LocalPlayer.Kick, function(...)
	Signal()
	return nil
end)

if Conn then
	task.spawn(function()
		while true do
			Conn:Send("ping")
			task.wait(5)
		end
	end)
end
