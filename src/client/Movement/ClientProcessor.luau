local Players = game:GetService("Players")
local m = {}

local LP = Players.LocalPlayer
local C = LP.Character or LP.CharacterAppearanceLoaded
local HRP = C:WaitForChild("HumanoidRootPart")

LP.CharacterAdded:Connect(function(a0: Model)
	C = LP.Character
end)

local function GROUNDED() end
