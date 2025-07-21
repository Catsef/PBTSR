local ServerScriptService = game:GetService("ServerScriptService")
local TweenService = game:GetService("TweenService")
local PBTS = require(ServerScriptService.Enumeration.PBTS)
local UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)
local t = {}

--[[
	the Create function should be a function in every action defined within Balls and used in GameState.
	@param target - the target. supports "NEAREST_PLAYER" or "POSITION_OFFSET" or "POSITION_ABSOLUTE"
	@param by - how much should the ball move by? from 0.000000...1 to 1. when set to 0, bugs out.
	@param tweenInfo - default setting. If manually creating list, can use "speed". but not recommended. just use tween info please
	@param rotateToFacePlayer - does it rotate to face the player? (does not tween btw)
	@param toMaxDist - an optional, but is used in "NEAREST_PLAYER" to see if the ball should travel there or not (too far)
	@param posOffset - an optional, but needed when doing "POSITION_OFFSET"
	@param pos - an optional, but needed when doing "POSITION_ABSOLUTE"
]]
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
	Action.action = PBTS.BallActions.TweenMove.Name

	Action.to = {}
	Action.tweenInfo = tweenInfo
	Action.rotateToFacePlayer = rotateToFacePlayer

	UtilityFunctions.SwitchWithCaseTable(target, {
		[PBTS.BallActions.TweenMove.Options.NearestPlayer] = function()
			Action.to.target = target
			Action.to.by = by
			if toMaxDist then
				Action.to.maxDistance = toMaxDist
			end
		end,
		[PBTS.BallActions.TweenMove.Options.PositionOffset] = function()
			Action.to.target = target
			Action.to.by = by
			Action.to.positionOffset = posOffset
		end,
		[PBTS.BallActions.TweenMove.Options.PositionAbsolute] = function()
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

--[[
	The action function is what runs from BallActionHandler.
	moves the part according to action context
]]
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

	if Action.action ~= PBTS.BallActions.TweenMove.Name then
		error("Action type not supported: " .. tostring(Action.action))
	end

	local target: Vector3

	if Action.to.target == PBTS.BallActions.TweenMove.Options.NearestPlayer then
		local maxDist = Action.to.maxDistance or 20
		local nearestPlayer = UtilityFunctions.FindNearestPlayer(maxDist, part)
		target = part.Position + (nearestPlayer.Character.HumanoidRootPart.Position - part.Position) * Action.to.by
	elseif Action.to.target == PBTS.BallActions.TweenMove.Options.PositionOffset then
		target = part.Position + Action.to.positionOffset
	elseif Action.to.target == PBTS.BallActions.TweenMove.Options.PositionAbsolute then
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
