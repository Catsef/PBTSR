local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SlideRE: RemoteEvent = ReplicatedStorage.Events.InsecureSlide

Players.PlayerAdded:Connect(function(P: Player)
	P.CharacterAppearanceLoaded:Connect(function(a0)
		local Human: Humanoid = a0:WaitForChild("Humanoid")

		Human.WalkSpeed = 30
		Human.JumpHeight = 5
	end)
end)
