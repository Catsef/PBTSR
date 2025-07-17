local m = {}

local ServerScriptService = game:GetService("ServerScriptService")
local g = require(ServerScriptService.GameState.GameState)
local ps = game:GetService("Players")

function UpdatePlayerButtons()
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
end

function m.BuyPhase() end

function m.RoundStarted() end

return m
