local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SlideRE: RemoteEvent = ReplicatedStorage.Events.InsecureSlide
local JumpRE: RemoteEvent = ReplicatedStorage.Events.InsecureJump
-- local WalkRE: RemoteEvent = ReplicatedStorage.Events.InsecureWalk
-- local MaxWalkSpeed = 30
local SlideVelocityFactor = 1.5
-- local SlideAnimationTracks = {} -- [player] = animationtrack
local PlayerWalkSpeeds = {}
-- local PlayerWalkTriggers = {}

Players.PlayerAdded:Connect(function(P: Player)
	P.CharacterAppearanceLoaded:Connect(function(a0)
		local Human: Humanoid = a0:WaitForChild("Humanoid")
		local Root = a0:WaitForChild("HumanoidRootPart")

		Human.WalkSpeed = 25
		Human.JumpHeight = 5

		-- local function setWalkSpeedToA()
		-- 	while task.wait() do
		-- 		if not a0.Parent then
		-- 			return
		-- 		end
		-- 		if PlayerWalkSpeeds[P] ~= nil then
		-- 			Human.WalkSpeed = PlayerWalkSpeeds[P]
		-- 		else
		-- 			continue
		-- 		end
		-- 	end
		-- end
		-- task.spawn(setWalkSpeedToA)

		Instance.new("Attachment", Root).Name = "Root"
		-- local SlideAnimId = 100330252457760
	end)
end)
SlideRE.OnServerEvent:Connect(function(P, inpState: Enum.UserInputState)
	if not P.Character then
		warn("Character not found, returning")
		return
	end

	local Humanoid = P.Character:FindFirstChild("Humanoid")
	local HumanoidRoot = P.Character:FindFirstChild("HumanoidRootPart")

	local Animator: Animator = Humanoid.Animator

	if inpState == Enum.UserInputState.End then
		for _, RemainingChild in ipairs(HumanoidRoot:GetChildren()) do
			if RemainingChild.Name == "SlideLinearVelocity" then
				RemainingChild:Destroy()
				return
			end
		end
		return
	end

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

	if Humanoid.FloorMaterial == Enum.Material.Air then
		warn("Tried to slide when FloorMaterial is air?")
		return
	end

	-- add more checks

	local RayStart = HumanoidRoot.Position + Vector3.new(0, -0.5, 0)
	local RayDirection = Vector3.new(0, -1, 0).Unit
	local RayParams = RaycastParams.new()
	RayParams.FilterDescendantsInstances = { P.Character }
	RayParams.FilterType = Enum.RaycastFilterType.Exclude
	local PlayerHeight = P.Character:GetExtentsSize().Y

	local RayLength = (PlayerHeight / 2)

	local RayResult = workspace:Raycast(RayStart, RayDirection * RayLength, RayParams)
	if not RayResult then
		warn("RayResult returned nothing!")
		return
	end

	-- the actual slide code here

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

	LinVelo.VectorVelocity = (UnitSlideDirection * Humanoid.WalkSpeed * SlideVelocityFactor)
		+ HumanoidRoot.AssemblyLinearVelocity
	LinVelo.RelativeTo = Enum.ActuatorRelativeTo.World
	LinVelo.Parent = HumanoidRoot

	LinVelo.MaxForce = 1000000 -- Controls slide strength

	local function CheckIfStillOnGround()
		while Humanoid.FloorMaterial ~= Enum.Material.Air do
			task.wait()
		end
		if not LinVelo then
			return
		end
		warn("Player found not on ground while in slide")
		LinVelo:Destroy()
		HumanoidRoot.AssemblyLinearVelocity = Vector3.zero
	end

	local tween = TweenService:Create(
		LinVelo,
		TweenInfo.new(2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
		{ VectorVelocity = Vector3.zero }
	)

	tween:Play()
	task.spawn(CheckIfStillOnGround)

	local jumpInterrupt = JumpRE.OnServerEvent:Connect(function(P2: Player, i)
		if P2.UserId == P.UserId then
			if i == Enum.UserInputState.End then
				return
			end
			print("Jump Interrupted")
			local V = HumanoidRoot.AssemblyLinearVelocity
			LinVelo:Destroy()

			HumanoidRoot.AssemblyLinearVelocity = (V * 3) + Vector3.new(0, 5, 0)
		end
	end)

	tween.Completed:Connect(function()
		LinVelo:Destroy()
		jumpInterrupt:Disconnect()
	end)
end)
