local ServerScriptService = game:GetService("ServerScriptService")
local WeightedChoice = require(ServerScriptService.Util.Random.WeightedChoice)
local BallActions = require(ServerScriptService.Balls.BallActionHandler)
local Delay = require(ServerScriptService.Balls.Delay)
local EffectCloud = require(ServerScriptService.Balls.EffectCloud)
local Grapple = require(ServerScriptService.Balls.Grapple)
local PhysicsPull = require(ServerScriptService.Balls.PhysicsPull)

local ToxinCloud = require(ServerScriptService.Balls.ToxinCloud)
local TweenMove = require(ServerScriptService.Balls.TweenMove)
local Slow = require(ServerScriptService.Effects.Slow)

local g = {}
local r = Random.new()

g.gameStarted = false
g.roundStarted = false
g.buyPhase = false

g.AllPlayers = {} -- [player]

g.AllGameReadiedPlayers = {} -- [player]
g.AllRoundReadiedPlayers = {} -- [player]

g.AlivePlayersDeathConnections = {} -- [player] = rbxscriptconnection
g.DeadPlayers = {} -- [player]
g.SpectateTargets = {} -- [dead-spectatorPlayer] = currentSpectateTargetPlayer

g.AllExistingBalls = {} -- [part]

g.currentRound = 0

g.stats = {}
g.stats.ballsWeights = {
	{
		weight = 90, -- 90
		value = "Doomling",
	},
	{
		weight = 30, -- 10
		value = "Blessling",
	},
	{
		weight = 15, -- 10
		value = "Grappler",
	},
	{
		weight = 10,
		value = "Shivering",
	},
	{
		weight = 20,
		value = "Bouncy",
	},
}
g.stats.balls = WeightedChoice.New(g.stats.ballsWeights)

g.stats.ballActions = {
	["Doomling"] = {
		TweenMove.Create(
			"NEAREST_PLAYER",
			0.3,
			TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
			true,
			100
		),
		ToxinCloud.Create(10, 5),
		TweenMove.Create(
			"NEAREST_PLAYER",
			0.5,
			TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
			true,
			200
		),
		ToxinCloud.Create(30, 5),
	},
	["Blessling"] = {
		TweenMove.Create(
			"NEAREST_PLAYER",
			0.9,
			TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut),
			false,
			500
		),
		ToxinCloud.Create(30, -10, Color3.fromRGB(30, 207, 74)),
		TweenMove.Create(
			"NEAREST_PLAYER",
			0.9,
			TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut),
			false,
			500
		),
		ToxinCloud.Create(30, -10, Color3.fromRGB(30, 207, 74)),
	},
	["Grappler"] = {
		-- turn towards player
		TweenMove.Create("NEAREST_PLAYER", 0.01, TweenInfo.new(1), true, 10000),
		-- grappler.create()
		Grapple.Create("NEAREST_PLAYER", 2500, 10000),
	},
	["Shivering"] = {
		TweenMove.Create(
			"NEAREST_PLAYER",
			0.95,
			TweenInfo.new(5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
			true,
			100000
		),
		EffectCloud.Create(10, Slow.Effect(1, 10), Slow, Color3.new(0.584314, 0.937255, 1)),
	},
	["Bouncy"] = {
		PhysicsPull.Create(1),
		Delay.Create(2),
		ToxinCloud.Create(50, 25, Color3.fromRGB(236, 108, 226)),
		PhysicsPull.Create(1),
		Delay.Create(2),
	},
}

g.stepperFunctions = {
	StepDoomlingA = function()
		table.insert(
			g.stats.ballActions.Doomling,
			TweenMove.Create(
				"NEAREST_PLAYER",
				0.1,
				TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
				true,
				1000
			)
		)
		table.insert(g.stats.ballActions.Doomling, ToxinCloud.Create(30, 10, Color3.fromRGB(255, 0, 0)))
	end,
	StepShiveringA = function()
		table.insert(
			g.stats.ballActions.Shivering,
			TweenMove.Create(
				"NEAREST_PLAYER",
				0.99,
				TweenInfo.new(3, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
				true,
				100000
			)
		)
		table.insert(
			g.stats.ballActions.Shivering,
			EffectCloud.Create(10, Slow.Effect(2, 10), Slow, Color3.new(0.584314, 0.937255, 1))
		)
	end,
	StepDoomlingB = function()
		table.insert(
			g.stats.ballActions.Doomling,
			TweenMove.Create(
				"NEAREST_PLAYER",
				0.9,
				TweenInfo.new(2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
				true,
				10000
			)
		)
		table.insert(g.stats.ballActions.Doomling, ToxinCloud.Create(50, 30, Color3.fromRGB(0, 0, 0)))
	end,
	StepBlesslingA = function()
		table.insert(g.stats.ballActions.Blessling, ToxinCloud.Create(30, -10, Color3.fromRGB(30, 207, 74)))
		table.insert(
			g.stats.ballActions.Blessling,
			TweenMove.Create(
				"NEAREST_PLAYER",
				0.9,
				TweenInfo.new(2, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut),
				false,
				500
			)
		)
	end,
	StepGrapplingA = function()
		table.insert(
			g.stats.ballActions.Grappler,
			TweenMove.Create("NEAREST_PLAYER", 0.01, TweenInfo.new(1), true, 10000)
		)
		table.insert(g.stats.ballActions.Grappler, Grapple.Create("NEAREST_PLAYER", 2500, 10000))
	end,
	StepBouncyA = function()
		table.insert(g.stats.ballActions.Bouncy, PhysicsPull.Create(1))
		table.insert(g.stats.ballActions.Bouncy, Delay.Create(2))
		table.insert(g.stats.ballActions.Bouncy, ToxinCloud.Create(50, 25, Color3.fromRGB(236, 108, 226)))
	end,
}

g.stats.waveBalls = 3
g.stats.waveDelay = 5
g.stats.waves = 3
g.stats.waveArea = 10

g.OriginalStats = table.clone(g.stats)

--[[
	onballdeath should be attached to destroying event of every ball spawned.
]]
local function OnBallDeath(Ball)
	for i, v in ipairs(g.AllExistingBalls) do
		if Ball == v then
			table.remove(g.AllExistingBalls, i)
		end
	end
end

--[[
	StepDifficulty steps up the difficulty. This function will be HEAVILY modified across development
]]
function g.StepDifficulty()
	-- Increase number of balls per wave
	g.stats.waveBalls += 1

	-- Make "Doomling" more likely and "Blessling" less likely

	-- Optionally, add a new action to each ball type to make them harder
	g.stepperFunctions.StepDoomlingA()
	g.stepperFunctions.StepGrapplingA()
	g.stepperFunctions.StepShiveringA()
	g.stepperFunctions.StepBouncyA()

	if g.currentRound % 5 == 0 then
		print("STEP B!")
		g.stepperFunctions.StepDoomlingB()
		g.stepperFunctions.StepBlesslingA()
	end

	-- You can also make waves faster or increase area, etc.
	g.stats.waveDelay = math.max(0.5, g.stats.waveDelay - 0.1)
	g.stats.waveArea += 30
end

--[[
	SpawnRoundWave spawns the wave of a round.
]]
function g.SpawnRoundWave(OriginPosition: Vector3)
	local ValidOrigin = OriginPosition or Vector3.new(0, 0.5, 0)
	for _ = 1, g.stats.waveBalls do
		task.wait(r:NextNumber(0, 0.1))
		local type = g.stats.balls:Choose()
		local model: Part = game.ServerStorage.Models[type]
		local actions = g.stats.ballActions[type]

		local cloneOfModel = model:Clone()

		table.insert(g.AllExistingBalls, cloneOfModel)
		cloneOfModel.Destroying:Connect(function(_: any)
			OnBallDeath(cloneOfModel)
		end)

		cloneOfModel.Position = ValidOrigin
			+ Vector3.new(
				r:NextNumber(-g.stats.waveArea, g.stats.waveArea),
				0,
				r:NextNumber(-g.stats.waveArea, g.stats.waveArea)
			)

		cloneOfModel.Parent = game.Workspace.Balls
		task.spawn(BallActions[type], cloneOfModel, actions)
	end
end

return g
