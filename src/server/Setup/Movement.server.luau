local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SlideRE: RemoteEvent = ReplicatedStorage.Events.InsecureSlide
local SlideVelocityFactor = 5

Players.PlayerAdded:Connect(function(P: Player)
	P.CharacterAppearanceLoaded:Connect(function(a0)
		local Human: Humanoid = a0:WaitForChild("Humanoid")
		local Root = a0:WaitForChild("HumanoidRootPart")

		Human.WalkSpeed = 30
		Human.JumpHeight = 5

		Instance.new("Attachment", Root).Name = "Root"
	end)
end)

SlideRE.OnServerEvent:Connect(function(P, ...: any)
	if not P.Character then
		warn("Character not found, returning")
		return
	end

	local Humanoid = P.Character:FindFirstChild("Humanoid")
	local HumanoidRoot = P.Character:FindFirstChild("HumanoidRootPart")

	if not Humanoid then
		warn("Humanoid not found within Character")
		return
	end

	if not HumanoidRoot then
		warn("HRP not found within Character")
		return
	end

	for _, RemainingChild in ipairs(HumanoidRoot:GetChildren()) do
		if RemainingChild.Name == "SlideLinearVelocity" then
			warn("Existing LinearVelocity found.")
			return -- so u cant just spam slide
		end
	end

	local LookVector = HumanoidRoot.CFrame.LookVector
	local UnitSlideDirection = Vector3.new(LookVector.X, 0, LookVector.Z).Unit

	local LinVelo = Instance.new("LinearVelocity")
	LinVelo.Name = "SlideLinearVelocity"

	if not HumanoidRoot:FindFirstChild("Root") then
		warn("Couldn't find Root attachment for attachment0 for linvelo")
		return
	end

	LinVelo.Visible = true
	LinVelo.Color = BrickColor.Blue()

	LinVelo.Attachment0 = HumanoidRoot.Root

	LinVelo.VectorVelocity = UnitSlideDirection * Humanoid.WalkSpeed * SlideVelocityFactor
	LinVelo.RelativeTo = Enum.ActuatorRelativeTo.World
	LinVelo.Parent = HumanoidRoot

	LinVelo.MaxForce = 100000000 -- Controls slide strength

	local tween = TweenService:Create(
		LinVelo,
		TweenInfo.new(2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
		{ VectorVelocity = Vector3.zero }
	)

	tween:Play()

	-- Auto-destroy when completed
	tween.Completed:Connect(function()
		LinVelo:Destroy()
	end)
end)

-- SlideRE.OnServerEvent:Connect(function(P)
-- 	print("SlideRE triggered")
-- 	local YouGoodMud, Err = pcall(function(...)
-- 		local HRP = P.Character.HumanoidRootPart
-- 		local LV = P.Character.Torso.CFrame.LookVector
-- 		local SBV: BodyVelocity = Instance.new("BodyVelocity")
-- 		SBV.P = 1000000
-- 		SBV.Parent = HRP
-- 		local Velo = LV * SlideVelocityFactor * P.Character.Humanoid.WalkSpeed
-- 		Velo = Vector3.new(Velo.X, 0, Velo.Z)
-- 		SBV.Velocity = Velo

-- 		local TVTZ = TweenService:Create(
-- 			SBV,
-- 			TweenInfo.new(2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
-- 			{ Velocity = Vector3.zero }
-- 		)

-- 		TVTZ:Play()
-- 		TVTZ.Completed:Wait()
-- 		SBV:Destroy()
-- 	end)
-- 	if not YouGoodMud then
-- 		warn(Err)
-- 	end
-- end)
