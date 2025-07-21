local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local GameState = require(ServerScriptService.GameState.GameState)
local UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)

local ReplicatedEvents = ReplicatedStorage.Events
local Respawn: RemoteEvent = ReplicatedEvents.Respawn
local Spectate: RemoteEvent = ReplicatedEvents.Spectate
local Death = require(script.Parent.DeathFunctions)

function PlayerDiedWithinRound(Player: Player)
	-- overwrite Death.WhoEveryoneSpectating[Player]
	-- lerp to another player's perspective on the client-side.
end

local function PlayerAdded(Player: Player)
	Death.WhoEveryoneSpectating[Player] = Death.StillAlive

	local Character = Player.CharacterAdded:Wait()
	local Humanoid: Humanoid = UtilityFunctions.ChildGetter(Character, "Humanoid", "Humanoid", 2, "attach death events")
	Humanoid.Died:Connect(function()
		-- This event listener will only be connected once.

		if GameState.roundStarted then
			PlayerDiedWithinRound(Player)
			return
		end

		Player:LoadCharacter()
	end)
end

Players.PlayerAdded:Connect(PlayerAdded)
Players.CharacterAutoLoads = false
