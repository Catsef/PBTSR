local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

local GameState = require(ServerScriptService.GameState.GameState)
local UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)

local ReplicatedEvents = ReplicatedStorage.Events
local RespawnPlayers: BindableEvent = ServerStorage.Bindings.GameState.RespawnPlayer
local Respawn: RemoteEvent = ReplicatedEvents.Respawn
local Spectate: RemoteEvent = ReplicatedEvents.Spectate
local Death = require(script.Parent.DeathFunctions)

function FindNextAlivePlayer()
	-- Get every player that's not inside GameState.DeadPlayers
	local AllPlayers = Players:GetPlayers()
	local DeadPlayers = GameState.DeadPlayers

	local Ref = {}
	local Alive = {}

	for _, player in ipairs(AllPlayers) do
		local found = table.find(DeadPlayers, player)
		if found == nil then
			Ref[player] = false
		else
			Ref[player] = true
		end
	end

	for player, dead in pairs(Ref) do
		if dead == false then
			table.insert(Alive, player)
		end
	end

	-- If the number of players that's not inside GameState.DeadPlayers is 0 then game end

	if #Alive == 0 then
		-- Game End
		warn("Find Next Alive Player - 0 alive players; game end")
		return
	end

	-- Else, return 1st alive player
	local SelectedPlayer = Alive[1]
	if SelectedPlayer == nil then
		warn("Selected Player is nil")
	end
	if not SelectedPlayer:IsA("Player") then
		warn("Selected Player isin't a player")
	end

	return SelectedPlayer
end

function PlayerDiedWithinRound(Player: Player)
	-- overwrite Death.WhoEveryoneSpectating[Player]

	table.insert(GameState.DeadPlayers, Player)
	-- players who are already spectating this player to be transferred
	local AlreadySpectating = {}
	for Spectator, Target in pairs(Death.WhoEveryoneSpectating) do
		if Player == Target then
			table.insert(AlreadySpectating, Spectator)
		end
	end

	local SelectedPlayer = FindNextAlivePlayer()
	if SelectedPlayer == nil then
		return -- no need warn messages, already warned in func FindNextAlivePlayer
	end

	for _, player in ipairs(AlreadySpectating) do
		Death.WhoEveryoneSpectating[player] = SelectedPlayer
		Spectate:FireClient(player, SelectedPlayer)
	end

	Death.WhoEveryoneSpectating[Player] = SelectedPlayer
	Spectate:FireClient(Player, SelectedPlayer)

	-- lerp to another player's perspective on the client-side - fired with Spectate remote event
end

local function PlayerAdded(Player: Player)
	Player:LoadCharacter()
	GameState.AllPlayers = Players:GetPlayers()
	Death.WhoEveryoneSpectating[Player] = Death.StillAlive

	local Character = Player.CharacterAdded:Wait()
	local Humanoid: Humanoid = UtilityFunctions.ChildGetter(Character, "Humanoid", "Humanoid", 2, "attach death events")
	Humanoid.Died:Connect(function()
		-- This event listener will only be connected once.
		print("Humanoid died!")

		if GameState.roundStarted then
			PlayerDiedWithinRound(Player)
			return
		end

		Player:LoadCharacter()
	end)
end

RespawnPlayers.Event:Connect(function(_: any)
	for _, player in ipairs(GameState.DeadPlayers) do
		player:LoadCharacter()
		Respawn:FireClient(player)
	end
	GameState.DeadPlayers = {}
end)

Players.PlayerAdded:Connect(PlayerAdded)
Players.CharacterAutoLoads = false
