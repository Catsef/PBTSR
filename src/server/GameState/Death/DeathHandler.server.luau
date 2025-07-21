local Players = game:GetService("Players")

local DeathFunctions = require(script.Parent.DeathFunctions)

local function PlayerAdded(Player: Player) end

Players.PlayerAdded:Connect(PlayerAdded)
