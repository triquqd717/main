local Debounce = 0
local Conn

local function Signal()
	local now = os.time()
	if now > Debounce then
		if game.PlaceId == 109983668079237 then
			if not Conn then
				Conn = WebSocket.connect("ws://localhost:6070/")
			end

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
