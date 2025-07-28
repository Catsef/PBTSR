-- UTIL
local function isOnGround(character)
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return false
	end

	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = { character }
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.IgnoreWater = true

	local origin = hrp.Position
	local downDirection = Vector3.new(0, -3.1, 0) -- cast 5 studs downward

	local raycastResult = workspace:Raycast(origin, downDirection, raycastParams)

	return raycastResult
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MovementProcessor = require(script.Parent.MovementProcessor)
local MovementState = require(script.Parent.MovementState)

local RemoteEvents = {}
RemoteEvents.MovementKey = ReplicatedStorage.Movement.MovementKey

RemoteEvents.MovementKey.OnServerEvent:Connect(
	function(Player: Player, State: Enum.UserInputState, KeyCode: Enum.KeyCode, InputType: Enum.InputActionType)
		print("MovementKey serverevent fired")
		if MovementState.PlayerState[Player] == MovementState.States.Dead then
			return
		end

		if not State then
			error("State is nil!")
		end

		if State == Enum.UserInputState.Begin then
			MovementState.KeysAdd(Player, KeyCode)
		elseif State == Enum.UserInputState.End then
			-- if more than one key is pressed at once, we have to handle accordingly.
			-- if not, incorrect state changes will introduce desync into state system
			-- errorchecks have been added to MovementState
			MovementState.KeysRemove(Player, KeyCode)
		end
	end
)

-- tickloop
function LOOP()
	while task.wait() do
		for _, player in Players:GetPlayers() do
			if MovementState.PlayerState[player] == nil then
				continue -- not initiated yet
			end

			if MovementState.PlayerMovementKeys[player] == nil then
				continue -- not initiated yet
			end

			MovementProcessor.PROCESS(player, MovementState)

			if #MovementState.PlayerMovementKeys[player] == 0 then
				-- temporary!
				MovementState.Update(player, MovementState.States.Standing)
			else
				-- temporary!
				MovementState.Update(player, MovementState.States.Walking)
			end
		end
	end
end

task.spawn(LOOP)
