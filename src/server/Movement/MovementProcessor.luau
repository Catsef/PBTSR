local ServerScriptService = game:GetService("ServerScriptService")

local EffectsHandler = require(ServerScriptService.Effects.EffectsHandler)
local m = {}

local function isOnGround(character, hrp)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = { character }
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.IgnoreWater = true

	local origin = hrp.Position
	local downDirection = Vector3.new(0, -3.1, 0) -- cast 5 studs downward

	local raycastResult = workspace:Raycast(origin, downDirection, raycastParams)

	return raycastResult
end

local function isStilled(humanoid: Humanoid)
	return humanoid.MoveDirection.Magnitude == 0
end

function m.PROCESS(Player: Player, MovementState)
	local C = Player.Character or Player.CharacterAdded:Wait()
	if not C then
		warn("Character is nil from MovementProcesser PROCESS")
		return
	end
	local H = C:WaitForChild("Humanoid")
	if not H then
		warn("Humanoid is nil from MovementProcesser PROCESS")
		return
	end
	local HRP = C:WaitForChild("HumanoidRootPart")
	if not HRP then
		warn("Humanoid Root Part is nil from MovementProcesser PROCESS")
		return
	end

	local STILLED = isStilled(H)
	local GROUNDED = isOnGround(C, HRP)

	if STILLED and GROUNDED and #MovementState.PlayerMovementKeys[Player] == 0 then
		MovementState.Update(Player, MovementState.States.Standing)
	end
end

return m
