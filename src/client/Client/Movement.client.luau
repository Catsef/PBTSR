local ReplicatedStorage = game:GetService("ReplicatedStorage")
local cas = game:GetService("ContextActionService")
local slideRE: RemoteEvent = ReplicatedStorage.Events.InsecureSlide
function slide(actionName: string, inputState: Enum.UserInputState, inputObject: InputObject): Enum.ContextActionResult?
	if not Enum.UserInputState.Begin then
		return
	end

	slideRE:FireServer()

	return Enum.ContextActionResult.Pass
end
cas:BindActionAtPriority("Slide", slide, true, 3, Enum.KeyCode.LeftShift)
