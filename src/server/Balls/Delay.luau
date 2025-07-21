local ServerScriptService = game:GetService("ServerScriptService")
local TweenService = game:GetService("TweenService")
local PBTS = require(ServerScriptService.Enumeration.PBTS)
local UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)
local t = {}

function t.Create(amt)
	local Action = {}
	Action.action = "Delay"
	Action.time = amt
	return Action
end

function t.Action(part, Action)
	task.wait(Action.time)
end

return t
