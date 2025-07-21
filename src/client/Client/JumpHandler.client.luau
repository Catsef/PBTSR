local Players = game:GetService("Players")
local P = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local cas = game:GetService("ContextActionService")
local jumpRE: RemoteEvent = ReplicatedStorage.Events.InsecureJump

function jump(name, state: Enum.UserInputState, object): Enum.ContextActionResult?
	jumpRE:FireServer(state)
	return Enum.ContextActionResult.Pass
end

cas:BindActionAtPriority("Jump", jump, false, 5, Enum.KeyCode.Space)
