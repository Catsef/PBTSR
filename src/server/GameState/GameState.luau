local ServerScriptService = game:GetService("ServerScriptService")
local WeightedChoice = require(ServerScriptService.Util.Random.WeightedChoice)
local BallActions = require(ServerScriptService.Balls.BallActionHandler)

local ToxinCloud = require(ServerScriptService.Balls.ToxinCloud)
local TweenMove = require(ServerScriptService.Balls.TweenMove)

local g = {}
local r = Random.new()

g.gameStarted = false
g.roundStarted = false
g.buyPhase = false

g.AllPlayers = {}
g.AllGameReadiedPlayers = {}
g.AllRoundReadiedPlayers = {}
g.DeadPlayers = {}
g.AllExistingBalls = {}

g.currentRound = 0

g.stats = {}
g.stats.balls = WeightedChoice.New({
	{
		weight = 90,
		value = "Doomling",
	},
	{
		weight = 10,
		value = "Blessling",
	},
})

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
			TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
			true,
			200
		),
		ToxinCloud.Create(30, 5),
	},
	["Blessling"] = {
		TweenMove.Create(
			"NEAREST_PLAYER",
			0.9,
			TweenInfo.new(2, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut),
			false,
			500
		),
		ToxinCloud.Create(30, -10, Color3.fromRGB(30, 207, 74)),
		TweenMove.Create(
			"NEAREST_PLAYER",
			0.9,
			TweenInfo.new(2, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut),
			false,
			500
		),
		ToxinCloud.Create(30, -10, Color3.fromRGB(30, 207, 74)),
	},
}

g.stats.waveBalls = 3
g.stats.waveDelay = 10
g.stats.waves = 3
g.stats.waveArea = 10

local function OnBallDeath(Ball)
	for i, v in ipairs(g.AllExistingBalls) do
		if Ball == v then
			table.remove(g.AllExistingBalls, i)
		end
	end
end

function g.StepDifficulty()
	-- Increase number of balls per wave
	g.stats.waveBalls += 1

	-- Make "Doomling" more likely and "Blessling" less likely

	-- Optionally, add a new action to each ball type to make them harder
	table.insert(
		g.stats.ballActions.Doomling,
		TweenMove.Create(
			"NEAREST_PLAYER",
			0.3,
			TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
			true,
			1000
		)
	)
	table.insert(g.stats.ballActions.Doomling, ToxinCloud.Create(30, 10, Color3.fromRGB(0, 0, 0)))

	-- You can also make waves faster or increase area, etc.
	g.stats.waveDelay = math.max(0.5, g.stats.waveDelay - 0.1)
	g.stats.waveArea += 30
end

function g.SpawnRoundWave(OriginPosition: Vector3)
	local ValidOrigin = OriginPosition or Vector3.new(0, 0.5, 0)
	for _ = 1, g.stats.waveBalls do
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
