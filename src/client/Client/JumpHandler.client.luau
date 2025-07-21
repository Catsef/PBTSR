local ReplicatedStorage = game:GetService("ReplicatedStorage")
local cas = game:GetService("ContextActionService")
local jumpRE: RemoteEvent = ReplicatedStorage.Events.InsecureJump

function jump(_n, state: Enum.UserInputState, _o): Enum.ContextActionResult?
	jumpRE:FireServer(state)
	return Enum.ContextActionResult.Pass
end

cas:BindActionAtPriority("Jump", jump, false, 5, Enum.KeyCode.Space)
