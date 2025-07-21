local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)
local DeathFunctions = require(script.Parent.DeathFunctions)

local function PlayerAdded(Player: Player)
	local Character = Player.CharacterAdded:Wait()
end

Players.PlayerAdded:Connect(PlayerAdded)
