local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)
-- local DeathFunctions = require(script.Parent.DeathFunctions)

local function PlayerAdded(Player: Player)
	-- Settings!

	local Character = Player.CharacterAdded:Wait()
	local Humanoid: Humanoid = UtilityFunctions.ChildGetter(Character, "Humanoid", "Humanoid", 2, "attach death events")
	Humanoid.Died:Connect(function()
		-- This event listener will only be connected once.

		Player:LoadCharacter()
	end)
end

Players.PlayerAdded:Connect(PlayerAdded)
Players.CharacterAutoLoads = false
