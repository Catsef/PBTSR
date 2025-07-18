local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Event: RemoteEvent = ReplicatedStorage.Events.InsecureGrapple

Event.OnClientEvent:Connect(function(position: Vector3, strength: number)
	local Character = LocalPlayer.Character
	if not Character then
		return
	end

	local HumanoidRootPart: Part = Character:FindFirstChild("HumanoidRootPart")
	if not HumanoidRootPart then
		return
	end

	local direction = (position - HumanoidRootPart.Position).Unit
	local impulseStrength = strength -- Adjust this value as needed
	local impulse = direction * impulseStrength

	HumanoidRootPart:ApplyImpulse(impulse)
end)
