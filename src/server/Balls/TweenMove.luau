local ServerScriptService = game:GetService("ServerScriptService")
local TweenService = game:GetService("TweenService")
local UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)
local t = {}

function t.Create(
	target: string,
	by: number,
	tweenInfo: TweenInfo,
	rotateToFacePlayer: boolean,
	toMaxDist: number?,
	posOffset: Vector3?,
	pos: Vector3?
)
	local Action = {}
	Action.action = "TweenMove"

	Action.to = {}
	Action.tweenInfo = tweenInfo
	Action.rotateToFacePlayer = rotateToFacePlayer

	UtilityFunctions.SwitchWithCaseTable(target, {
		["NEAREST_PLAYER"] = function()
			Action.to.target = target
			Action.to.by = by
			if toMaxDist then
				Action.to.maxDistance = toMaxDist
			end
		end,
		["POSITION_OFFSET"] = function()
			Action.to.target = target
			Action.to.by = by
			Action.to.positionOffset = posOffset
		end,
		["POSITION_ABSOLUTE"] = function()
			Action.to.target = target
			Action.to.by = by
			Action.to.position = pos
		end,
		default = function()
			error(
				"TweenMove.Create(): Unrecognized target..."
					.. target
					.. "; only support NEAREST_PLAYER, POSITION_OFFSET, or POSITION_ABSOLUTE"
			)
		end,
	})

	return Action
end

function t.Action(part: Part, Action)
	-- TweenMove
	-- 	{
	-- 	["action"] = "TweenMove",
	-- 	["to"] = {
	-- 		["target"] = "NEAREST_PLAYER" or "POSITION_OFFSET" or "POSITION_ABSOLUTE",
	-- 		["by"] = 0.3,
	-- 		["maxDistance"] = 20, -- optional, only used for NEAREST_PLAYER
	-- 		["positionOffset"] = Vector3.new(0, 0, 0), -- optional, only used for POSITION_OFFSET
	-- 		["position"] = Vector3.new(0, 0, 0), -- optional, only used for POSITION_ABSOLUTE
	-- 	},
	-- 	["tweenInfo"] = TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
	-- 	["speed"] = 2,
	-- 	["rotateToFacePlayer"] = true,
	-- },

	if Action.action ~= "TweenMove" then
		error("Action type not supported: " .. tostring(Action.action))
	end

	local target: Vector3

	if Action.to.target == "NEAREST_PLAYER" then
		local maxDist = Action.to.maxDistance or 20
		local nearestDist, nearestPlayer
		for _, v in pairs(game:GetService("Players"):GetPlayers()) do
			local char = v.Character
			local dist = v:DistanceFromCharacter(part.Position)
			if not char or dist > maxDist or (nearestDist and dist >= nearestDist) then
				continue
			end
			nearestDist = dist
			nearestPlayer = v
		end

		if not nearestPlayer then
			return
		end

		target = part.Position + (nearestPlayer.Character.HumanoidRootPart.Position - part.Position) * Action.to.by
	elseif Action.to.target == "POSITION_OFFSET" then
		target = part.Position + Action.to.positionOffset
	elseif Action.to.target == "POSITION_ABSOLUTE" then
		target = Action.to.position
	else
		error("unrecognized Action.to.target...")
	end

	local tweeninfo = Action.tweenInfo
		or TweenInfo.new(Action.speed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

	local tween = TweenService:Create(part, tweeninfo, { Position = target })

	if Action.rotateToFacePlayer then
		part.CFrame = CFrame.lookAt(part.Position, target)
	end

	tween:Play()
	tween.Completed:Wait()
end

return t
