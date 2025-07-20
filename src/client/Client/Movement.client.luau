local ReplicatedStorage = game:GetService("ReplicatedStorage")
local cas = game:GetService("ContextActionService")
local slideRE: RemoteEvent = ReplicatedStorage.Events.InsecureSlide
function slide(actionName: string, inputState: Enum.UserInputState, inputObject: InputObject): Enum.ContextActionResult?
	slideRE:FireServer(inputState)

	return Enum.ContextActionResult.Pass
end
cas:BindActionAtPriority("Slide", slide, true, 3, Enum.KeyCode.LeftShift)
