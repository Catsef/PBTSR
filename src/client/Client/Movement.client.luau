local Players = game:GetService("Players")
local P = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local cas = game:GetService("ContextActionService")
local slideRE: RemoteEvent = ReplicatedStorage.Events.InsecureSlide
local jumpRE: RemoteEvent = ReplicatedStorage.Events.InsecureJump
-- local walkRE: RemoteEvent = ReplicatedStorage.Events.InsecureWalk
local SlideChannel
function slide(actionName: string, inputState: Enum.UserInputState, inputObject: InputObject): Enum.ContextActionResult?
	local humanoid: Humanoid = P.Character.Humanoid
	local cam: Camera = game.Workspace.CurrentCamera
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
		cam.CameraSubject = humanoid
		humanoid.CameraOffset = Vector3.new(0, -5, 0)
	end
	if inputState == Enum.UserInputState.End then
		SlideAnimationTrack:Stop(0)
		humanoid.CameraOffset = Vector3.new(0, 0, 0)
	end

	return Enum.ContextActionResult.Pass
end

function jump(name, state: Enum.UserInputState, object): Enum.ContextActionResult?
	jumpRE:FireServer(state)
	return Enum.ContextActionResult.Pass
end

-- function walk(name, state: Enum.UserInputState, object): Enum.ContextActionResult?
-- 	walkRE:FireServer(state)
-- 	return Enum.ContextActionResult.Pass
-- end

cas:BindActionAtPriority("Slide", slide, true, 3, Enum.KeyCode.LeftShift)
cas:BindActionAtPriority("Jump", jump, false, 5, Enum.KeyCode.Space)
-- cas:BindActionAtPriority("Walk", walk, false, 5, Enum.KeyCode.W)
