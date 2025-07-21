local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local m = {}

local UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)
local GameState = require(script.Parent.GameState)

local SpectateRE: RemoteEvent = ReplicatedStorage.Events.Spectate
local RespawnRE: RemoteEvent = ReplicatedStorage.Events.Respawn

local function respawn(player)
	player:LoadCharacter()
	local human = player:WaitForChild("Character"):WaitForChild("Humanoid")
	RespawnRE:FireClient(human)
end

local function ResetGame()
	GameState.gameStarted = false
	GameState.buyPhase = false
	GameState.roundStarted = false

	GameState.AllGameReadiedPlayers = {}
	GameState.AllRoundReadiedPlayers = {}
	GameState.SpectateTargets = {}
	GameState.DeadPlayers = {}
	GameState.currentRound = 0

	GameState.stats = GameState.OriginalStats

	for _, player in Players:GetPlayers() do
		respawn(player)
	end
end

local function GetAlivePlayers()
	local allPlayers = Players:GetPlayers()
	GameState.AllPlayers = allPlayers
	local alive = {}
	local deadSet = {}
	for _, p in ipairs(GameState.DeadPlayers) do
		deadSet[p] = true
	end
	for _, p in ipairs(allPlayers) do
		if not deadSet[p] then
			table.insert(alive, p)
		end
	end
	return alive
end

local function SelectSpectateTarget()
	local alive = GetAlivePlayers()
	if #alive == 0 then
		return nil
	else
		return alive[1]
	end
end

local function SetSpectateTarget(spectator, target)
	GameState.SpectateTargets[spectator] = target
	if spectator and target then
		SpectateRE:FireClient(spectator, target)
	end
end

local function OnPlayerDeath(deadPlayer)
	if GameState.roundStarted then
		print("Player died!!")

		for spectator, target in pairs(GameState.SpectateTargets) do
			if target == deadPlayer then
				local spectateTarget = SelectSpectateTarget()
				if spectateTarget == nil then
					ResetGame()
				else
					SetSpectateTarget(spectator, spectateTarget)
				end
			end
		end

		table.insert(GameState.DeadPlayers, deadPlayer)

		-- GET NEXT PLAYER TO SPECTATE, IF NOT FOUND, GAME END

		local spectateTarget = SelectSpectateTarget()

		if spectateTarget == nil then
			ResetGame()
			return
		else
			SetSpectateTarget(deadPlayer, spectateTarget)
		end
	else
		respawn(deadPlayer)
	end
end

Players.PlayerAdded:Connect(function(P: Player)
	P.CharacterAdded:Connect(function(C: Model)
		local Humanoid = C:WaitForChild("Humanoid")
		if not (Humanoid:IsA("Humanoid")) then
			return
		end
		Humanoid.Died:Connect(function(_)
			OnPlayerDeath(P)
		end)
	end)
end)

function m.PREGAME() end

function m.PREROUND() end

function m.INROUND()
	GameState.AllPlayers = Players:GetPlayers()
	if UtilityFunctions.CompareUnorderedSets(GameState.AllPlayers, GameState.DeadPlayers) then
		-- game end
		ResetGame()
		return
	end
end

function m.HANGING_DeathChecker()
	while task.wait() do
		if GameState.roundStarted then
			m.INROUND()
		end
	end
end

return m
