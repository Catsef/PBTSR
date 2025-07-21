local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)
local DeathFunctions = require(script.Parent.DeathFunctions)

local function PlayerAdded(Player: Player)
	local Character = UtilityFunctions.ChildGetter(Player, "Character", "Model", "attach death event")
end

Players.PlayerAdded:Connect(PlayerAdded)
