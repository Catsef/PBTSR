local m = {}

local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

local ps = game:GetService("Players")

local b = require(ServerScriptService.GameState.Rewriting.BallStats)
local g = require(ServerScriptService.GameState.Rewriting.GameState)
local f = require(ServerScriptService.GameState.Rewriting.StateFunctions)
local p = require(ServerScriptService.GameState.Rewriting.StatePlayers)

local UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)

local Respawn: BindableEvent = ServerStorage.Bindings.GameState.RespawnPlayer

local BuyTrigger = workspace.Shop.Shop

function m.UpdatePlayerButtons()
	local Players = ps:GetPlayers()

	for _, Player in ipairs(Players) do
		local PlayerButtons = Player.PlayerGui:WaitForChild("StartButtons")

		if not g.PhaseGame then
			PlayerButtons.Round.Visible = false
			PlayerButtons.Game.Visible = true
		end
		if g.PhaseBuy then
			PlayerButtons.Round.Visible = true
			PlayerButtons.Game.Visible = false
		end
		if g.PhaseRound then
			PlayerButtons.Round.Visible = false
			PlayerButtons.Game.Visible = false
		end
	end
end

function m.UpdateRoundCounter()
	local Players = ps:GetPlayers()

	for _, Player in ipairs(Players) do
		local PlayerRoundCounter = Player.PlayerGui:WaitForChild("RoundCounter")
		if not g.PhaseGame then
			PlayerRoundCounter.TextLabel.Visible = false
		end
		if g.PhaseBuy then
			PlayerRoundCounter.TextLabel.Visible = true
			PlayerRoundCounter.TextLabel.Text = "round " .. g.Round
		end
		if g.PhaseRound then
			PlayerRoundCounter.TextLabel.Visible = true
			PlayerRoundCounter.TextLabel.Text = "round " .. g.Round
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
	p.AllPlayers = ps:GetPlayers()
	if UtilityFunctions.CompareUnorderedSets(p.AllPlayers, p.Readied.Game) then
		g.PhaseGame = true
		g.PhaseBuy = true
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
	p.AllPlayers = ps:GetPlayers()
	if UtilityFunctions.CompareUnorderedSets(p.AllPlayers, p.Readied.Round) then
		g.PhaseBuy = false
		g.PhaseRound = true
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
	g.Round += 1
	m.UpdateRoundCounter()

	for _ = 1, b.wave.amount do
		if not g.PhaseGame then
			return
		end

		f.SpawnWave()
		task.wait(b.wave.delay)
	end

	while task.wait() do
		if #b.run.existingballs == 0 then
			break
		else
			warn("Stalling!")
		end
	end

	if not g.PhaseGame then
		m.UpdatePlayerButtons()
		warn("Resetting game, not stepping difficulty")
		Respawn:Fire()
		return
	end
	g.PhaseRound = false
	g.PhaseBuy = true
	p.Readied.Round = {}
	m.UpdatePlayerButtons()
	f.StepDifficulty()
	Respawn:Fire()
end

return m
