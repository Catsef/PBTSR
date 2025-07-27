local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MovementState = require(script.Parent.MovementState)

local RemoteEvents = {}
RemoteEvents.MovementKey = ReplicatedStorage.Movement.MovementKey

RemoteEvents.MovementKey.OnServerEvent:Connect(function(Player: Player, State: Enum.UserInputState, Object: InputObject)
	print("MovementKey serverevent fired")
	if MovementState.PlayerState[Player] == MovementState.States.Dead then
		return
	end

	if State == Enum.UserInputState.Begin then
		MovementState.KeysAdd(Player, Object.KeyCode)
	elseif State == Enum.UserInputState.End then
		-- if more than one key is pressed at once, we have to handle accordingly.
		-- if not, incorrect state changes will introduce desync into state system
		-- errorchecks have been added to MovementState
		MovementState.KeysRemove(Player, Object.KeyCode)
	end
end)
