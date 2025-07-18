local Conn = WebSocket.connect("ws://localhost:6070")
local Debounce = 1

local function Signal()
	if Conn then
		Conn:Send("kicked")
	else
		if Debounce < os.time() then
			game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer) -- Rejoin
			Debounce = os.time() + 1
		end
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
	return old(...)
end)
