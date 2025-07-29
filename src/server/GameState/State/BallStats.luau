local ServerScriptService = game:GetService("ServerScriptService")

local Delay = require(ServerScriptService.Balls.Delay)
local EffectCloud = require(ServerScriptService.Balls.EffectCloud)
local Grapple = require(ServerScriptService.Balls.Grapple)
local PhysicsPull = require(ServerScriptService.Balls.PhysicsPull)
local ToxinCloud = require(ServerScriptService.Balls.ToxinCloud)
local TweenMove = require(ServerScriptService.Balls.TweenMove)
local Slow = require(ServerScriptService.Effects.Slow)
local WeightedChoice = require(ServerScriptService.Util.Random.WeightedChoice)
local UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)

local b = {}

b.weightsToAdd = {
	{
		weight = 1,
		value = "Grappler",
	},
	{
		weight = 1,
		value = "Shivering",
	},
	{
		weight = 1,
		value = "Bouncy",
	},
}
b.weights = {
	{
		weight = 10,
		value = "Doomling",
	},
	{
		weight = 2,
		value = "Blessling",
	},
}
b.weightChoice = function()
	return WeightedChoice.New(b.weights)
end

b.tweens = {}
b.tweens.extraeasy = TweenInfo.new(2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
b.tweens.easy = TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
b.tweens.medium = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
b.tweens.hard = TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
b.tweens.extrahard = TweenInfo.new(0.1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
b.tweens.impossible = TweenInfo.new(0.01, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

b.action = {}
b.action.actions = {
	["Doomling"] = {
		TweenMove.Create("NEAREST_PLAYER", 0.3, b.tweens.easy, true, 100),
		ToxinCloud.Create(20, 5),
		TweenMove.Create("NEAREST_PLAYER", 0.3, b.tweens.easy, true, 100),
		ToxinCloud.Create(20, 5),
	},
	["Blessling"] = {
		TweenMove.Create("NEAREST_PLAYER", 0.99, b.tweens.medium, false, 10000),
		ToxinCloud.Create(50, -15, Color3.new(0.537255, 0.886275, 0.431373)),
		Delay.Create(3),
		ToxinCloud.Create(50, -15, Color3.new(0.537255, 0.886275, 0.431373)),
	},
	["Grappler"] = {
		Grapple.Create("MULTIPLE_PLAYERS", 1500, 10000, 5),
		Delay.Create(1.5),
	},
	["Shivering"] = {
		TweenMove.Create("NEAREST_PLAYER", 0.999, b.tweens.extraeasy, true, 50),
		EffectCloud.Create(15, Slow.Effect(1, 3), Slow, Color3.fromRGB(46, 224, 255)),
	},
	["Bouncy"] = {
		PhysicsPull.Create(500),
		Delay.Create(0.2),
		ToxinCloud.Create(50, 5, Color3.fromRGB(203, 72, 255)),
		PhysicsPull.Create(500),
		Delay.Create(0.2),
		ToxinCloud.Create(50, 5, Color3.fromRGB(203, 72, 255)),
		PhysicsPull.Create(500),
		Delay.Create(0.2),
		ToxinCloud.Create(50, 5, Color3.fromRGB(203, 72, 255)),
		PhysicsPull.Create(500),
		Delay.Create(0.2),
		ToxinCloud.Create(50, 5, Color3.fromRGB(203, 72, 255)),
		PhysicsPull.Create(500),
		Delay.Create(0.2),
		ToxinCloud.Create(50, 5, Color3.fromRGB(203, 72, 255)),
	},
	["Master"] = {
		Grapple.Create("MULTIPLE_PLAYERS", 500, 10000, 1000),
		Delay.Create(0.5),
		ToxinCloud.Create(75, 10),
	},
}
b.action.stepactions = {
	DoomlingA = function() -- list argument
		local l = b.action.actions.Doomling
		table.insert(l, TweenMove.Create("NEAREST_PLAYER", 0.3, b.tweens.medium, true, 100))
		table.insert(l, ToxinCloud.Create(20, 5))
	end,
}

b.wave = {}
b.wave.balls = 3
b.wave.delay = 5
b.wave.amount = 3
b.wave.area = 10

b.run = {}
b.run.choices = b.weightChoice()
b.run.func = {}
b.run.func.updateChoices = function()
	b.run.choices = b.weightChoice()
end
b.run.func.addNextChoiceToWeight = function()
	if b.weightsToAdd[1] then
		table.insert(b.weights, b.weightsToAdd[1])
		table.remove(b.weightsToAdd, 1)
		return true
	else
		return false
	end
end
b.run.customBallQueue = {}
b.run.existingballs = {}

b.original = {}
b.original.weights = UtilityFunctions.deepClone(b.weights)
b.original.actions = UtilityFunctions.deepClone(b.action.actions)

return b
