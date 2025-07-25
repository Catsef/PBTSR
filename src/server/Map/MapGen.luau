local ServerStorage = game:GetService("ServerStorage")

local MapUtil = require(script.Parent.MapUtil)

local F = {}

F.tweens = {}
F.tweens.bounce = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)

function F.RoundStart()
	-- tween the green baseplate to match spawn area
	-- generate base
	-- generate +2 layer with least
	-- generate +1 layer with medium
	-- generate pillars, boxes
end

return F
