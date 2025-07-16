local ServerScriptService = game:GetService("ServerScriptService")
local WeightedChoice = require(ServerScriptService.Util.Random.WeightedChoice)
local _Utility = require(ServerScriptService.Util.UtilityFunctions)
local BallActions = require(ServerScriptService.Balls.BallActionHandler)
local g = {}
local r = Random.new()

g.gameStarted = false
g.roundStarted = false
g.buyPhase = false

g.currentRound = 0

g.stats = {}
g.stats.balls = WeightedChoice.New({
	{
		weight = 1,
		value = "Doomling",
	},
})

g.stats.ballActions = {
	["Doomling"] = {
		{
			["action"] = "TweenMove",
			["to"] = {
				["target"] = "NEAREST_PLAYER",
				["by"] = 0.3,
			},
			["speed"] = 2,
			["rotateToFacePlayer"] = true,
		},
		{
			["action"] = "ToxinCloud",
			["radius"] = 3,
			["damage"] = 5, -- remember to add player to ignore list so that it doesnt get
			-- hurt more than one time
		},
		{
			["action"] = "TweenMove",
			["to"] = {
				["target"] = "NEAREST_PLAYER",
				["by"] = 0.5,
			},
			["speed"] = 1,
			["rotateToFacePlayer"] = true,
		},
		{
			["action"] = "ToxinCloud",
			["radius"] = 5,
			["damage"] = 10,
		},
	},
}

g.stats.waveBalls = 3
g.stats.waveDelay = 1
g.stats.waves = 3
g.stats.waveArea = 10

function g.SpawnRoundWave(OriginPosition: Vector3)
	local OriginPosition = OriginPosition or Vector3.new(0, 0.5, 0)
	for _ = 1, g.stats.waveBalls do
		local type = g.stats.balls:Choose()
		local model: Part = game.ServerStorage.Model[type]
		local actions = g.stats.ballActions[type]

		local model = model:Clone()

		model.Position = OriginPosition
			+ Vector3.new(
				r:NextNumber(-g.stats.waveArea, g.stats.waveArea),
				0,
				r:NextNumber(-g.stats.waveArea, g.stats.waveArea)
			)

		model.Parent = game.Workspace.Balls
		task.spawn(BallActions[type], model, actions)
	end
end

return g
