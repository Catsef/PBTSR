local Players = game:GetService("Players")
local m = {}

local GameState = require(script.Parent.GameState)
-- TO REQUIRE

function m.PREGAME() end

function m.PREROUND() end

function m.INROUND()
	GameState.AllPlayers = Players:GetPlayers()
	for _, player: Player in ipairs(GameState.AllPlayers) do
		local Character = player:WaitForChild("Character")
		local Humanoid: Humanoid = Character:WaitForChild("Humanoid")

		if GameState.AlivePlayersDeathConnections[player] ~= nil then
			continue
		end

		GameState.AlivePlayersDeathConnections[player] = Humanoid.Died:Connect(function(...: any)
			table.insert(GameState.DeadPlayers, player)
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
