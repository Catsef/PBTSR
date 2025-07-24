local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

local GameStateRunner = require(ServerScriptService.GameState.GameStateRunner)
local BallStats = require(ServerScriptService.GameState.Rewriting.BallStats)
local GameState = require(ServerScriptService.GameState.Rewriting.GameState)
local StatePlayers = require(ServerScriptService.GameState.Rewriting.StatePlayers)

local UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)

local ReplicatedEvents = ReplicatedStorage.Events
local RespawnPlayers: BindableEvent = ServerStorage.Bindings.GameState.RespawnPlayer
local Respawn: RemoteEvent = ReplicatedEvents.Respawn
local Spectate: RemoteEvent = ReplicatedEvents.Spectate
local Death = require(script.Parent.DeathFunctions)

function EndGame()
	print("Ending game!")

	GameState.PhaseRound = false
	GameState.PhaseBuy = false
	GameState.Round = 0
	GameState.PhaseGame = false

	StatePlayers.Readied.Game = {}
	StatePlayers.Readied.Round = {}

	BallStats.action.actions = BallStats.original.actions
	BallStats.weights = BallStats.original.weights

	for _, v in ipairs(BallStats.run.existingballs) do
		if v == nil or v.Parent == nil then
			continue
		end
		v:Destroy()
	end
	GameStateRunner.UpdatePlayerButtons()
	GameStateRunner.UpdateRoundCounter()
	RespawnPlayers:Fire()
end

function FindNextAlivePlayer()
	-- Get every player that's not inside GameState.DeadPlayers
	local AllPlayers = Players:GetPlayers()
	local DeadPlayers = StatePlayers.DeadPlayers

	local Ref = {}
	local Alive = {}

	print("Finding next alive player...")

	for _, player in ipairs(AllPlayers) do
		local found = table.find(DeadPlayers, player)
		if found == nil then
			Ref[player] = false
		else
			Ref[player] = true
		end
	end

	print("Reference:")
	print(Ref)

	for player, dead in pairs(Ref) do
		if dead == false then
			table.insert(Alive, player)
		end
	end

	print("Alive:")
	print(Alive)

	-- If the number of players that's not inside GameState.DeadPlayers is 0 then game end

	if #Alive == 0 then
		-- Game End
		EndGame()
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

	table.insert(StatePlayers.DeadPlayers, Player)
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
	StatePlayers.AllPlayers = Players:GetPlayers()
	Death.WhoEveryoneSpectating[Player] = Death.StillAlive

	print("Waiting for character!")
	local Character = Player.Character
	if Character == nil or Character.Parent == nil then
		Character = Player.CharacterAdded:Wait()
	end
	print("Got character")
	local Humanoid: Humanoid = UtilityFunctions.ChildGetter(Character, "Humanoid", "Humanoid", 2, "attach death events")
	print("Got humanoid")

	Humanoid.Died:Connect(function()
		-- This event listener will be connected one time only
		print("Humanoid died!")

		if GameState.PhaseRound then
			PlayerDiedWithinRound(Player)
			return
		end

		Player:LoadCharacter()
	end)

	Player.CharacterAdded:Connect(function(a0: Model)
		print("Attached events to humanoid die")
		local RH: Humanoid = UtilityFunctions.ChildGetter(a0, "Humanoid", "Humanoid", 2, "attach death events")
		RH.Died:Connect(function()
			-- This event listener will be connected every time Character is added or Player dies and respawns
			print("Humanoid died!")

			if GameState.PhaseRound then
				PlayerDiedWithinRound(Player)
				return
			end

			Player:LoadCharacter()
		end)
	end)
end

RespawnPlayers.Event:Connect(function(_: any)
	for _, player in ipairs(StatePlayers.DeadPlayers) do
		player:LoadCharacter()
		Respawn:FireClient(player)
	end
	StatePlayers.DeadPlayers = {}
end)

Players.PlayerAdded:Connect(PlayerAdded)
Players.CharacterAutoLoads = false
