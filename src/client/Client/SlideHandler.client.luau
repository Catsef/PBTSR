local Players = game:GetService("Players")
local P = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local slideRE: RemoteEvent = ReplicatedStorage.Events.InsecureSlide
local cas = game:GetService("ContextActionService")

local SlideChannel
function slide(actionName: string, inputState: Enum.UserInputState, inputObject: InputObject): Enum.ContextActionResult?
	local humanoid: Humanoid = P.Character.Humanoid
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
		SlideAnimationTrack:Play(0)
		local cam: Camera = game.Workspace.CurrentCamera
		cam.FieldOfView = 105
		cam.CameraSubject = humanoid
		cam.CameraType = Enum.CameraType.Custom
		humanoid.CameraOffset = Vector3.new(0, -2, 0)
	end
	if inputState == Enum.UserInputState.End then
		SlideAnimationTrack:Stop(0)
		local cam: Camera = game.Workspace.CurrentCamera
		cam.FieldOfView = 100
		humanoid.CameraOffset = Vector3.new(0, 0, 0)
	end

	return Enum.ContextActionResult.Pass
end

cas:BindActionAtPriority("Slide", slide, true, 3, Enum.KeyCode.LeftShift)
