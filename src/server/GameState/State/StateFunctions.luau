local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

local BallStats = require(script.Parent.BallStats)
local GameState = require(script.Parent.GameState)
local _StatePlayers = require(script.Parent.StatePlayers)

local BallActions = require(ServerScriptService.Balls.BallActionHandler)

local Random = Random.new()

local function OnBallDestroying(Ball)
	for i, v in ipairs(BallStats.run.existingballs) do
		if Ball == v then
			table.remove(BallStats.run.existingballs, i)
		end
	end
end

local State = {}

function State.StepDifficulty()
	-- increase only slightly.
	BallStats.wave.balls += 1

	BallStats.wave.area += 10
	BallStats.wave.delay = math.max(0.5, BallStats.wave.delay - 0.3)

	BallStats.action.stepactions.DoomlingA()

	if GameState.Round % 5 == 0 then
		print("Stepping B-MODE")
		BallStats.run.func.addNextChoiceToWeight()
		print("Added: " .. BallStats.weights[#BallStats.weights]["value"])
	end

	BallStats.run.func.updateChoices()
end

function State.SpawnWave(Origin: Vector3?)
	local SpawnPosition = Origin or (game.Workspace.Baseplate.Position + Vector3.new(0, 50, 0))

	for _ = 1, BallStats.wave.balls do
		task.wait(Random:NextNumber(0, 0.3))
		local type = BallStats.run.choices:Choose()
		local model: Part = ServerStorage.Models[type]
		local clone = model:Clone()
		local actions = BallStats.action.actions[type]

		table.insert(BallStats.run.existingballs, clone)
		clone.Destroying:Connect(function()
			OnBallDestroying(clone)
		end)
		clone.Position = SpawnPosition
			+ Vector3.new(
				Random:NextNumber(-BallStats.wave.area, BallStats.wave.area),
				0,
				Random:NextNumber(-BallStats.wave.area, BallStats.wave.area)
			)

		clone.Parent = game.Workspace.Balls

		task.spawn(BallActions[type], clone, actions)
	end
end

return State
