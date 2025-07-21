local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local m = {}

local UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)
local GameState = require(script.Parent.GameState)

local SpectateRE: RemoteEvent = ReplicatedStorage.Events.Spectate

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

function ResetGame() end

function m.PREGAME() end

function m.PREROUND() end

function m.INROUND()
	GameState.AllPlayers = Players:GetPlayers()
	if UtilityFunctions.CompareUnorderedSets(GameState.AllPlayers, GameState.DeadPlayers) then
		-- game end
		ResetGame()
		return
	end
	for _, player: Player in ipairs(GameState.AllPlayers) do
		local Character = player:WaitForChild("Character")
		local Humanoid: Humanoid = Character:WaitForChild("Humanoid")

		if GameState.AlivePlayersDeathConnections[player] ~= nil then
			continue
		end

		GameState.AlivePlayersDeathConnections[player] = Humanoid.Died:Connect(function(...: any)
			table.insert(GameState.DeadPlayers, player)

			-- GET NEXT PLAYER TO SPECTATE, IF NOT FOUND, GAME END

			local spectateTarget = SelectSpectateTarget()

			if spectateTarget == nil then
				ResetGame()
				return
			else
				SpectateRE:FireClient(player, spectateTarget)
			end
		end)
	end
end

function m.HANGING_DeathChecker()
	while task.wait() do
		if not GameState.gameStarted then
			m.PREGAME()
		end

		if GameState.buyPhase then
			m.PREROUND()
		end

		if GameState.roundStarted then
			m.INROUND()
		end
	end
end
