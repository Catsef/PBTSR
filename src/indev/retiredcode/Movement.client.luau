local CAS = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Remote: RemoteEvent = ReplicatedStorage.Events.Jumped

function jump(actionName: string, inputState: Enum.UserInputState, inputObject: InputObject): Enum.ContextActionResult?
	local Character = Player.Character

	local Head = Character.Head
	local RootPart = Character.HumanoidRootPart
	Remote:FireServer(inputState)

	return Enum.ContextActionResult.Pass
end

CAS:BindActionAtPriority("jump", jump, false, 3, Enum.KeyCode.Space)
