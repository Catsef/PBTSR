local ServerScriptService = game:GetService("ServerScriptService")
local TweenService = game:GetService("TweenService")
local PBTS = require(ServerScriptService.Enumeration.PBTS)
local UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)
local t = {}

function t.Create(force: number)
	local Action = {}
	Action.action = PBTS.BallActions.PhysicsPull
	Action.force = force
	return Action
end

function t.Action(part: Part, Action)
	if part.Anchored then
		error("tried to run PhysicsPull on an anchord part")
	end
	if Action.action ~= PBTS.BallActions.PhysicsPull then
		error("Unsupported action type (PhysicsPull)")
	end
	local nearestPlayer = UtilityFunctions.FindNearestPlayer(1000000, part)
	if not nearestPlayer then
		return
	end
	local nPHRP = nearestPlayer.Character.HumanoidRootPart
	local target = (part.Position + (nPHRP.Position - part.Position)) * Action.force
	part.AssemblyLinearVelocity = Vector3.new(target.X, 0, target.Z)
end

return t
