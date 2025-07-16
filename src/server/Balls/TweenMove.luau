local TweenService = game:GetService("TweenService")
local t = {}

function t.Action(part: Part, Action)
	-- TweenMove
	-- 	{
	-- 	["action"] = "TweenMove",
	-- 	["to"] = {
	-- 		["target"] = "NEAREST_PLAYER",
	-- 		["by"] = 0.3,
	-- 	},
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
