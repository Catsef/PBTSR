local Players = game:GetService("Players")
local P = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local slideRE: RemoteEvent = ReplicatedStorage.Events.InsecureSlide
local dashRE: RemoteEvent = ReplicatedStorage.Events.InsecureDash
local cas = game:GetService("ContextActionService")

local CurrentCamOffset = 0
local CamOffsetAmount = -2
local CamOffsetLerp = 1

local SlideChannel

P.CharacterAdded:Connect(function(a0: Model)
	SlideChannel = nil
end)

local function EaseOutExpo(t)
	if t == 1 then
		return 1
	end
	return 1 - math.pow(2, -10 * t)
end

local function LerpCameraOffset(humanoid, targetOffset, duration)
	local startOffset = CurrentCamOffset
	local startTime = tick()
	while tick() - startTime < duration do
		local linearAlpha = (tick() - startTime) / duration
		local alpha = EaseOutExpo(math.clamp(linearAlpha, 0, 1))
		CurrentCamOffset = startOffset + (targetOffset - startOffset) * alpha
		humanoid.CameraOffset = Vector3.new(0, CurrentCamOffset, 0)
		task.wait()
	end
	CurrentCamOffset = targetOffset
	humanoid.CameraOffset = Vector3.new(0, CurrentCamOffset, 0)
end

function DISABLE(_an, inputState, io)
	return Enum.ContextActionResult.Sink
end

function slide(_an: string, inputState: Enum.UserInputState, _io: InputObject): Enum.ContextActionResult?
	local humanoid: Humanoid = P.Character.Humanoid
	if inputState == Enum.UserInputState.Begin then
		if humanoid.FloorMaterial == Enum.Material.Air then
			dashRE:FireServer(P.Character.HumanoidRootPart.CFrame.LookVector)
			return
		end
	end
	slideRE:FireServer(inputState)

	local animator = humanoid:WaitForChild("Animator")

	local SlideAnimationTrack
	if not SlideChannel then
		local SlideAnimation = Instance.new("Animation")
		SlideAnimation.AnimationId = "rbxassetid://100330252457760"

		SlideAnimationTrack = animator:LoadAnimation(SlideAnimation)
		SlideChannel = SlideAnimationTrack
	else
		SlideAnimationTrack = SlideChannel
	end
	if inputState == Enum.UserInputState.Begin then
		SlideAnimationTrack:Play(0, 1000)
		local cam: Camera = game.Workspace.CurrentCamera
		cam.FieldOfView = 105
		cam.CameraSubject = humanoid
		cam.CameraType = Enum.CameraType.Custom
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
		cas:BindAction(
			"DisableMovement",
			DISABLE,
			false,
			Enum.KeyCode.A,
			Enum.KeyCode.S,
			Enum.KeyCode.W,
			Enum.KeyCode.D,
			Enum.KeyCode.Space
		)
		task.spawn(function()
			LerpCameraOffset(humanoid, CamOffsetAmount, 0.5)
		end)
	end
	if inputState == Enum.UserInputState.End then
		SlideAnimationTrack:Stop(0)
		local cam: Camera = game.Workspace.CurrentCamera
		cam.FieldOfView = 100
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
		cas:UnbindAction("DisableMovement")
		task.spawn(function()
			LerpCameraOffset(humanoid, 0, 0.5)
		end)
	end

	return Enum.ContextActionResult.Pass
end

cas:BindActionAtPriority("Slide", slide, true, 3, Enum.KeyCode.Q)
