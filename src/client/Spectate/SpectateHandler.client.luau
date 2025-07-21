local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SpectateRE: RemoteEvent = ReplicatedStorage.Events.Spectate
local cam = workspace.CurrentCamera

SpectateRE.OnClientEvent:Connect(function(specTarget: Player)
	local char = specTarget:WaitForChild("Character")
	local human = char:WaitForChild("Humanoid")
	print("initial SpectateRE fired")

	cam.CameraSubject = human
end)
