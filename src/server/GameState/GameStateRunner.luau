local m = {}

local ServerScriptService = game:GetService("ServerScriptService")
local g = require(ServerScriptService.GameState.GameState)
local ps = game:GetService("Players")
local UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)

function m.UpdatePlayerButtons()
	local Players = ps:GetPlayers()

	for _, Player in ipairs(Players) do
		local PlayerButtons = Player.PlayerGui:WaitForChild("StartButtons")

		if not g.gameStarted then
			PlayerButtons.Round.Visible = false
			PlayerButtons.Game.Visible = true
		end
		if g.buyPhase then
			PlayerButtons.Round.Visible = true
			PlayerButtons.Game.Visible = false
		end
		if g.roundStarted then
			PlayerButtons.Round.Visible = false
			PlayerButtons.Game.Visible = false
		end
	end
end

function m.NotGameStarted()
	g.AllPlayers = ps:GetPlayers()
	if UtilityFunctions.CompareUnorderedSets(g.AllPlayers, g.AllGameReadiedPlayers) then
		g.gameStarted = true
		g.buyPhase = true
		m.UpdatePlayerButtons()
	end
end

function m.BuyPhase()
	g.AllPlayers = ps:GetPlayers()
	if UtilityFunctions.CompareUnorderedSets(g.AllPlayers, g.AllRoundReadiedPlayers) then
		g.buyPhase = false
		g.roundStarted = true
		m.UpdatePlayerButtons()
	end
end

function m.RoundStarted()
	g.currentRound += 1

	local function OnBallDeath(Ball)
		for i, v in ipairs(g.AllExistingBalls) do
			if Ball == v then
				table.remove(g.AllExistingBalls, i)
			end
		end
	end

	for _ = 1, g.stats.waves do
		g.SpawnRoundWave(Vector3.new(0, 5, 0))
		task.wait(g.stats.waveDelay)
	end

	while task.wait() do
		if #g.AllExistingBalls == 0 then
			break
		else
			warn("Stalling!")
		end
	end

	g.roundStarted = false
	g.buyPhase = true
	g.AllRoundReadiedPlayers = {}
end

return m
