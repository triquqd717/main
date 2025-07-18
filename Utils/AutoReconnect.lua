local Conn = nil

if typeof(WebSocket) == "table" and typeof(WebSocket.connect) == "function" then
	Conn = WebSocket.connect("ws://localhost:6070")
end

local Debounce = 0

local function Signal()
	local now = os.time()
	if Conn then
		pcall(function()
			Conn:Send("kicked")
		end)
	else
		if now > Debounce then
			game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
			Debounce = now + 1
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
