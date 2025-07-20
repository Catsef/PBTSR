local CAS = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
local Remote: RemoteEvent = ReplicatedStorage.Events.Jumped

function jump(actionName: string, inputState: Enum.UserInputState, inputObject: InputObject): Enum.ContextActionResult?
	print("jumped(client)")
	local Character = Player:FindFirstChild("Character")
	if not Character then
		return
	end
	local Humanoid: Humanoid = Character.Humanoid
	if not Humanoid then
		return
	end

	local Head = Character.Head
	local RootPart = Character.HumanoidRootPart

	Remote:FireServer(Head, RootPart)
	print("FireServerd")

	return Enum.ContextActionResult.Pass
end

CAS:BindActionAtPriority("jump", jump, false, 3, Enum.KeyCode.Space)
