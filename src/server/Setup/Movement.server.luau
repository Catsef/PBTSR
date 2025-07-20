local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local JumpRemote: RemoteEvent = ReplicatedStorage.Events.Jumped

Players.PlayerAdded:Connect(function(P: Player)
	P.CharacterAppearanceLoaded:Connect(function(a0)
		local Human: Humanoid = a0:WaitForChild("Humanoid")

		Human.WalkSpeed = 30
	end)
end)

JumpRemote.OnServerEvent:Connect(function(a0: Player, Head, HRP)
	print("Fired")
	local LookV = Head.CFrame.LookVector
	LookV = Vector3.new(LookV.X, 0, LookV.Z)
	LookV = LookV * 30

	HRP:ApplyImpulse(LookV)
end)
