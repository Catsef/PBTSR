local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local PlayerProfileManager = require(ServerScriptService.Data.PlayerProfileManager)
while task.wait(0.5) do
	local Players = Players:GetPlayers()
	for _, player in ipairs(Players) do
		task.spawn(PlayerProfileManager.HANGING_UpdateBalanceGui, player)
	end
end
