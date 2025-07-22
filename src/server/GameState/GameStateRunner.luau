local m = {}

local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

local g = require(ServerScriptService.GameState.GameState)
local ps = game:GetService("Players")
local GameState = require(script.Parent.GameState)
local UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)

local Respawn: BindableEvent = ServerStorage.Bindings.GameState.RespawnPlayer

local BuyTrigger = workspace.Shop.Shop

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

function m.UpdateRoundCounter()
	local Players = ps:GetPlayers()

	for _, Player in ipairs(Players) do
		local PlayerRoundCounter = Player.PlayerGui:WaitForChild("RoundCounter")
		if not g.gameStarted then
			PlayerRoundCounter.TextLabel.Visible = false
		end
		if g.buyPhase then
			PlayerRoundCounter.TextLabel.Visible = true
			PlayerRoundCounter.TextLabel.Text = "round " .. GameState.currentRound
		end
		if g.roundStarted then
			PlayerRoundCounter.TextLabel.Visible = true
			PlayerRoundCounter.TextLabel.Text = "round " .. GameState.currentRound
		end
	end
end

function m.CloseAllBuyGuis()
	local Players = ps:GetPlayers()
	for _, Player in ipairs(Players) do
		local BuyGui = Player.PlayerGui:WaitForChild("BuyGUI")
		if not BuyGui.Enabled then
			continue -- you're a good boy
		end
		BuyGui.Enabled = false
	end
end

--[[
	this function should ONLY be ran from GameStart.server.luau
]]
function m.NotGameStarted()
	g.AllPlayers = ps:GetPlayers()
	if UtilityFunctions.CompareUnorderedSets(g.AllPlayers, g.AllGameReadiedPlayers) then
		g.gameStarted = true
		g.buyPhase = true
		m.UpdatePlayerButtons()
		m.UpdateRoundCounter()
		Respawn:Fire()
	end
end

--[[
	this function should ONLY be ran from GameStart.server.luau
]]
function m.BuyPhase()
	BuyTrigger.Enabled = true
	g.AllPlayers = ps:GetPlayers()
	if UtilityFunctions.CompareUnorderedSets(g.AllPlayers, g.AllRoundReadiedPlayers) then
		g.buyPhase = false
		g.roundStarted = true
		m.UpdatePlayerButtons()
		m.UpdateRoundCounter()
	end
end

--[[
	this function should ONLY be ran from GameStart.server.luau
]]
function m.RoundStarted()
	BuyTrigger.Enabled = false
	-- close all buyguis
	m.CloseAllBuyGuis()
	g.currentRound += 1
	m.UpdateRoundCounter()

	for _ = 1, g.stats.waves do
		if not g.gameStarted then
			return
		end

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

	if not g.gameStarted then
		m.UpdatePlayerButtons()
		warn("Resetting game, not stepping difficulty")
		Respawn:Fire()
		return
	end
	g.roundStarted = false
	g.buyPhase = true
	g.AllRoundReadiedPlayers = {}
	m.UpdatePlayerButtons()
	g.StepDifficulty()
end

return m
