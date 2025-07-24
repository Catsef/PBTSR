local ServerScriptService = game:GetService("ServerScriptService")

local ToxinCloud = require(ServerScriptService.Balls.ToxinCloud)
local TweenMove = require(ServerScriptService.Balls.TweenMove)
local WeightedChoice = require(ServerScriptService.Util.Random.WeightedChoice)

local b = {}

b.weights = {
	{
		weight = 1,
		value = "Doomling",
	},
}
b.weightChoice = function()
	return WeightedChoice.New(b.weights)
end

b.tweens = {}
b.tweens.easy = TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
b.tweens.medium = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
b.tweens.hard = TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
b.tweens.extrahard = TweenInfo.new(0.1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
b.tweens.impossible = TweenInfo.new(0.01, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

b.action = {}
b.action.actions = {
	["Doomling"] = {
		TweenMove.Create("NEAREST_PLAYER", 0.3, b.tweens.easy, true, 100),
		ToxinCloud.Create(10, 5),
		TweenMove.Create("NEAREST_PLAYER", 0.3, b.tweens.easy, true, 100),
		ToxinCloud.Create(10, 5),
	},
}
b.action.stepactions = {
	DoomlingA = function() -- list argument
		local l = b.action.actions.Doomling
		table.insert(l, TweenMove.Create("NEAREST_PLAYER", 0.3, b.tweens.medium, true, 100))
		table.insert(l, ToxinCloud.Create(10, 5))
	end,
}

b.wave = {}
b.wave.balls = 3
b.wave.delay = 5
b.wave.amount = 3
b.wave.area = 10

b.run = {}
b.run.choices = b.weightChoice()
b.run.existingballs = {}

b.original = {}
b.original.weights = table.clone(b.weights)
b.original.actions = table.clone(b.action.actions)

return b
