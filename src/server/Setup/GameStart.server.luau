local ServerScriptService = game:GetService("ServerScriptService")

local GameStateRunner = require(ServerScriptService.GameState.GameStateRunner)
local GameState = require(ServerScriptService.GameState.Rewriting.GameState)
local StateFunctions = require(ServerScriptService.GameState.Rewriting.StateFunctions)

while task.wait() do
	if not GameState.PhaseGame then
		GameStateRunner.NotGameStarted()
		continue
	end

	if GameState.PhaseBuy then
		GameStateRunner.BuyPhase()
		continue
	end

	if GameState.PhaseRound then
		GameStateRunner.RoundStarted()
		continue
	end
end

task.wait(3)
StateFunctions.SpawnWave()
