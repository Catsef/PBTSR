local ServerScriptService = game:GetService("ServerScriptService")
local _TweenService = game:GetService("TweenService")
local _PBTS = require(ServerScriptService.Enumeration.PBTS)
local _UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)
local t = {}

function t.Create(amt)
	local Action = {}
	Action.action = "Delay"
	Action.time = amt
	return Action
end

function t.Action(_part, Action)
	task.wait(Action.time)
end

return t
