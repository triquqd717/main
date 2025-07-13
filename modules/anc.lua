local Module = require(game:GetService("ReplicatedStorage").Modules.Notification)

Module.CreateNotification = function(...)
	local args = { ... }
	args[1] = false
	return Module.CreateNotification(unpack(args))
end
