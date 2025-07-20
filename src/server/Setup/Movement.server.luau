local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local JumpRemote: RemoteEvent = ReplicatedStorage.Events.Jumped

Players.PlayerAdded:Connect(function(P: Player)
	P.CharacterAppearanceLoaded:Connect(function(a0)
		local Human: Humanoid = a0:WaitForChild("Humanoid")

		Human.WalkSpeed = 30
	end)

	P.CharacterAdded:Connect(function(character)
		-- Force network ownership when character spawns
		local rootPart = character:WaitForChild("HumanoidRootPart")
		if rootPart:CanSetNetworkOwnership() then
			rootPart:SetNetworkOwner(P) -- Critical line!
		end
	end)
end)

JumpRemote.OnServerEvent:Connect(function(a0: Player, Head, HRP)
	local LookV = Head.CFrame.LookVector
	LookV = Vector3.new(LookV.X, 0, LookV.Z)
	LookV = LookV * 3000
	print(LookV)

	HRP:ApplyImpulse(LookV)
	print("Applied Boost")
end)
