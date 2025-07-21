local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SpectateRE: RemoteEvent = ReplicatedStorage.Events.Spectate
local cam = workspace.CurrentCamera

SpectateRE.OnClientEvent:Connect(function(specTarget: Player)
	if specTarget == nil then
		warn("Tried to spectate nil? Fak yu mean")
		return
	end
	local char = specTarget.Character
	local human = char.Humanoid
	print("initial SpectateRE fired")

	cam.CameraSubject = human
end)
