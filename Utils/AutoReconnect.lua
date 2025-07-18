local Conn = WebSocket.connect("ws://localhost:6070")

if not Conn then
	return
end

local function Signal()
	Conn:Send("kicked")
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
