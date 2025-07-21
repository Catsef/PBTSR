-- SERVER: Spectate System (No Ground Checks)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local m = {}

local UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)
local GameState = require(script.Parent.GameState)

local SpectateRE: RemoteEvent = ReplicatedStorage.Events.Spectate
local RespawnRE: RemoteEvent = ReplicatedStorage.Events.Respawn

local function respawn(player)
	if not player then
		return
	end
	warn("RESPAWN RAN FOR " .. player.Name)

	player:LoadCharacter()
	RespawnRE:FireClient(player)
end

local function ResetGame()
	warn("RESET GAME RAN")
	GameState.gameStarted = false
	GameState.buyPhase = false
	GameState.roundStarted = false

	GameState.AllGameReadiedPlayers = {}
	GameState.AllRoundReadiedPlayers = {}
	GameState.SpectateTargets = {}
	GameState.DeadPlayers = {}
	GameState.currentRound = 0

	for _, player in Players:GetPlayers() do
		respawn(player)
	end
end

local function GetAlivePlayers()
	local alive = {}
	for _, player in Players:GetPlayers() do
		if not GameState.DeadPlayers[player] and player.Character then
			local humanoid = player.Character:FindFirstChild("Humanoid")
			if humanoid and humanoid.Health > 0 then
				table.insert(alive, player)
			end
		end
	end
	return alive
end

local function SelectSpectateTarget(excludePlayer)
	local alive = GetAlivePlayers()

	-- Filter out excluded player
	local candidates = {}
	for _, player in ipairs(alive) do
		if player ~= excludePlayer then
			table.insert(candidates, player)
		end
	end

	if #candidates == 0 then
		return nil
	end

	-- Select random player to spectate
	return candidates[math.random(1, #candidates)]
end

local function SetSpectateTarget(spectator, target)
	if not spectator or not target then
		return
	end

	GameState.SpectateTargets[spectator] = target
	SpectateRE:FireClient(spectator, target)
end

local function OnPlayerDeath(deadPlayer)
	if not deadPlayer then
		return
	end

	-- Mark player as dead
	GameState.DeadPlayers[deadPlayer] = true

	if GameState.roundStarted then
		warn("Player died during round: " .. deadPlayer.Name)

		-- Update all spectators watching this player
		for spectator, target in pairs(GameState.SpectateTargets) do
			if target == deadPlayer then
				local newTarget = SelectSpectateTarget(deadPlayer)
				if newTarget then
					SetSpectateTarget(spectator, newTarget)
				else
					-- No valid targets, clear spectating
					GameState.SpectateTargets[spectator] = nil
					SpectateRE:FireClient(spectator, nil)
				end
			end
		end

		-- Find new target for dead player
		local spectateTarget = SelectSpectateTarget(deadPlayer)

		if spectateTarget then
			SetSpectateTarget(deadPlayer, spectateTarget)
		else
			warn("No valid spectate targets found, ending game")
			ResetGame()
		end
	else
		-- Game not in round, just respawn
		respawn(deadPlayer)
	end
end

-- Handle player leaving
Players.PlayerRemoving:Connect(function(player)
	GameState.DeadPlayers[player] = nil
	GameState.SpectateTargets[player] = nil

	-- Clean up spectators watching this player
	for spectator, target in pairs(GameState.SpectateTargets) do
		if target == player then
			local newTarget = SelectSpectateTarget(player)
			if newTarget then
				SetSpectateTarget(spectator, newTarget)
			else
				GameState.SpectateTargets[spectator] = nil
				SpectateRE:FireClient(spectator, nil)
			end
		end
	end
end)

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")
		if not humanoid:IsA("Humanoid") then
			return
		end

		humanoid.Died:Connect(function()
			OnPlayerDeath(player)
		end)
	end)
end)

function m.HANGING_DeathChecker()
	while task.wait(2) do
		if GameState.roundStarted then
			local alive = GetAlivePlayers()
			if #alive == 0 and #Players:GetPlayers() > 0 then
				ResetGame()
			end
		end
		if GameState.buyPhase then
			local PS = Players:GetPlayers()
			for _, p in ipairs(PS) do
				respawn(p)
			end
		end
	end
end

return m

-- local Players = game:GetService("Players")
-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local ServerScriptService = game:GetService("ServerScriptService")
-- local m = {}

-- local UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)
-- local GameState = require(script.Parent.GameState)

-- local SpectateRE: RemoteEvent = ReplicatedStorage.Events.Spectate
-- local RespawnRE: RemoteEvent = ReplicatedStorage.Events.Respawn

-- local function respawn(player)
-- 	warn("RESPAWN RAN FOR " .. player.Name)
-- 	player:LoadCharacter()
-- 	local human = player:WaitForChild("Character"):WaitForChild("Humanoid")
-- 	RespawnRE:FireClient(human)
-- end

-- local function ResetGame()
-- 	warn("RESET GAME RAN")
-- 	GameState.gameStarted = false
-- 	GameState.buyPhase = false
-- 	GameState.roundStarted = false

-- 	GameState.AllGameReadiedPlayers = {}
-- 	GameState.AllRoundReadiedPlayers = {}
-- 	GameState.SpectateTargets = {}
-- 	GameState.DeadPlayers = {}
-- 	GameState.currentRound = 0

-- 	GameState.stats = GameState.OriginalStats

-- 	for _, player in Players:GetPlayers() do
-- 		respawn(player)
-- 	end
-- end

-- local function GetAlivePlayers()
-- 	local allPlayers = Players:GetPlayers()
-- 	GameState.AllPlayers = allPlayers
-- 	local alive = {}
-- 	local deadSet = {}
-- 	for _, p in ipairs(GameState.DeadPlayers) do
-- 		deadSet[p] = true
-- 	end
-- 	for _, p in ipairs(allPlayers) do
-- 		if not deadSet[p] then
-- 			table.insert(alive, p)
-- 		end
-- 	end
-- 	warn("ALL ALIVE:")
-- 	print(alive)
-- 	return alive
-- end

-- local function SelectSpectateTarget()
-- 	local alive = GetAlivePlayers()
-- 	if #alive == 0 then
-- 		return nil
-- 	else
-- 		warn("SELECTED SPEC TARGET:" .. alive[1].Name)
-- 		return alive[1]
-- 	end
-- end

-- local function SetSpectateTarget(spectator, target)
-- 	GameState.SpectateTargets[spectator] = target
-- 	if spectator and target then
-- 		warn("SUCCESSFULLY FIRED SPECTATERE")
-- 		SpectateRE:FireClient(spectator, target)
-- 	end
-- end

-- local function OnPlayerDeath(deadPlayer)
-- 	if GameState.roundStarted then
-- 		table.insert(GameState.DeadPlayers, deadPlayer)
-- 		warn("Player died!!")

-- 		for spectator, target in pairs(GameState.SpectateTargets) do
-- 			if target == deadPlayer then
-- 				local spectateTarget = SelectSpectateTarget()
-- 				if spectateTarget == nil then
-- 					ResetGame()
-- 				else
-- 					SetSpectateTarget(spectator, spectateTarget)
-- 				end
-- 			end
-- 		end

-- 		-- GET NEXT PLAYER TO SPECTATE, IF NOT FOUND, GAME END

-- 		local spectateTarget = SelectSpectateTarget()

-- 		if spectateTarget == nil then
-- 			ResetGame()
-- 			return
-- 		else
-- 			SetSpectateTarget(deadPlayer, spectateTarget)
-- 		end
-- 	else
-- 		respawn(deadPlayer)
-- 	end
-- end

-- Players.PlayerAdded:Connect(function(P: Player)
-- 	P.CharacterAdded:Connect(function(C: Model)
-- 		print("attaching died to humanoid....")
-- 		local Humanoid = C:WaitForChild("Humanoid")
-- 		if not (Humanoid:IsA("Humanoid")) then
-- 			return
-- 		end
-- 		Humanoid.Died:Connect(function(_)
-- 			print("player died")
-- 			OnPlayerDeath(P)
-- 		end)
-- 	end)
-- end)

-- function m.INROUND()
-- 	GameState.AllPlayers = Players:GetPlayers()
-- 	if UtilityFunctions.CompareUnorderedSets(GameState.AllPlayers, GameState.DeadPlayers) then
-- 		-- game end
-- 		ResetGame()
-- 		return
-- 	end
-- end

-- function m.HANGING_DeathChecker()
-- 	while task.wait() do
-- 		if GameState.roundStarted then
-- 			print("ran INROUND")
-- 			m.INROUND()
-- 		end
-- 	end
-- end

-- return m
