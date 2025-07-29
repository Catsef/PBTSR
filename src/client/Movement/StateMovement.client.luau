local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StateChange: RemoteEvent = ReplicatedStorage.Movement.StateChange

StateChange.OnClientEvent:Connect(function(PREV_STATE, NEW_STATE)
	print("Client: state change ")
end)
