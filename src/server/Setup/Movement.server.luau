local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SlideRE: RemoteEvent = ReplicatedStorage.Events.InsecureSlide
local DashRE: RemoteEvent = ReplicatedStorage.Events.InsecureDash
local JumpRE: RemoteEvent = ReplicatedStorage.Events.InsecureJump

local SlideVelocityFactor = 1.5
local PlayersSliding = {} -- [player] = bool
local PlayersSlidingInfo = {} -- [player] = {t=tween, v=linvelo}

local function DestroySlide(P)
	if not PlayersSliding[P] then
		return
	end
	if not PlayersSlidingInfo[P] then
		error("PlayersSliding[p] -> true but PlayersSlidingInfo[p] -> false")
	end

	PlayersSlidingInfo[P].t:Destroy()
	PlayersSlidingInfo[P].v:Destroy()
	PlayersSliding[P] = false
	PlayersSlidingInfo[P] = nil
end
local function CreateSlide(P)
	if not P.Character then
		warn("Character not found, returning")
		return
	end
	local HumanoidRoot = P.Character.HumanoidRootPart
	local Humanoid = P.Character.Humanoid

	if not Humanoid then
		warn("Humanoid not found within Character")
		return
	end

	local LookVector = HumanoidRoot.CFrame.LookVector
	local UnitSlideDirection = Vector3.new(LookVector.X, 0, LookVector.Z).Unit

	local LinVelo = Instance.new("LinearVelocity")
	LinVelo.Name = "SlideLinearVelocity"

	if not HumanoidRoot:FindFirstChild("Root") then
		warn("Couldn't find Root attachment for attachment0 for linvelo")
		return
	end

	LinVelo.Attachment0 = HumanoidRoot.Root

	LinVelo.VectorVelocity = (UnitSlideDirection * Humanoid.WalkSpeed * SlideVelocityFactor)
		+ HumanoidRoot.AssemblyLinearVelocity
	LinVelo.RelativeTo = Enum.ActuatorRelativeTo.World
	LinVelo.Parent = HumanoidRoot

	LinVelo.MaxForce = 1000000 -- Controls slide strength

	local tween = TweenService:Create(
		LinVelo,
		TweenInfo.new(2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
		{ VectorVelocity = Vector3.zero }
	)

	tween:Play()
	PlayersSliding[P] = true
	PlayersSlidingInfo[P] = { t = tween, v = LinVelo }

	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
end

Players.PlayerAdded:Connect(function(P: Player)
	P.CharacterAppearanceLoaded:Connect(function(a0)
		local Human: Humanoid = a0:WaitForChild("Humanoid")
		local Root = a0:WaitForChild("HumanoidRootPart")

		PlayersSliding[P] = false
		PlayersSlidingInfo[P] = nil

		Human.WalkSpeed = 25
		Human.JumpHeight = 5

		Instance.new("Attachment", Root).Name = "Root"
	end)
end)
DashRE.OnServerEvent:Connect(function(P, ...: any)
	local HumanoidRoot = P.Character:FindFirstChild("HumanoidRootPart")

	HumanoidRoot.AssemblyLinearVelocity = HumanoidRoot.AssemblyLinearVelocity
		+ (P.Character.Head.CFrame.LookVector * 1000000)
end)

SlideRE.OnServerEvent:Connect(function(P, inpState: Enum.UserInputState)
	if not P.Character then
		-- warn("Character not found, returning")
		return
	end

	local Humanoid = P.Character:FindFirstChild("Humanoid")
	local HumanoidRoot = P.Character:FindFirstChild("HumanoidRootPart")

	if inpState == Enum.UserInputState.End then
		if PlayersSliding[P] then
			DestroySlide(P)
		end
		return
	end

	if not Humanoid then
		-- warn("Humanoid not found within Character")
		return
	end

	if not HumanoidRoot then
		-- warn("HRP not found within Character")
		return
	end

	for _, RemainingChild in ipairs(HumanoidRoot:GetChildren()) do
		if RemainingChild.Name == "SlideLinearVelocity" then
			-- warn("Existing LinearVelocity found.")
			return -- so u cant just spam slide
		end
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

	if Humanoid.FloorMaterial == Enum.Material.Air or not RayResult then
		return
	end

	-- the actual slide code here

	CreateSlide(P)

	local function CheckIfStillOnGround()
		while Humanoid.FloorMaterial ~= Enum.Material.Air do
			task.wait()
		end
		if not PlayersSliding[P] then
			return
		end
		DestroySlide(P)
		-- warn("Player found not on ground while in slide")
	end
	task.spawn(CheckIfStillOnGround)

	-- PlayersSlidingInfo[P].t.Completed:Connect(function() end)
end)

JumpRE.OnServerEvent:Connect(function(P: Player, ...: any)
	local PlayerSliding = PlayersSliding[P]
	if not PlayerSliding then
		return
	end
	if not PlayersSlidingInfo[P] then
		error("PlayersSliding but not PlayersSlidingInfo?")
	end
	DestroySlide(P)
end)
