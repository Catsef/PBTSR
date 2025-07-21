local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RespawnRE: RemoteEvent = ReplicatedStorage.Events.Respawn
local cam = workspace.CurrentCamera

RespawnRE.OnClientEvent:Connect(function(SpawnedHumanoid: Humanoid)
	cam.CameraSubject = SpawnedHumanoid
end)
