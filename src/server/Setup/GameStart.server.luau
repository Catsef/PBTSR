local ServerScriptService = game:GetService("ServerScriptService")
local GameState = require(ServerScriptService.GameState.GameState)
local GameStateRunner = require(ServerScriptService.GameState.GameStateRunner)

while task.wait() do
	if not GameState.gameStarted then
		GameStateRunner.NotGameStarted()
		continue
	end

	if GameState.buyPhase then
		GameStateRunner.BuyPhase()
		continue
	end

	if GameState.roundStarted then
		GameStateRunner.RoundStarted()
		continue
	end
end

task.wait(3)
GameState.SpawnRoundWave(Vector3.new(0, 0.5, 0))
