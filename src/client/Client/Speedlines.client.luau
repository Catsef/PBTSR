local RunService = game:GetService("RunService")

local SpeedlineHandler = require(script.Parent.SpeedlineHandler)
local Camera = game.Workspace.CurrentCamera
local Speedlines = game.StarterPlayer.SPEEDLINES:Clone()

local P = game.Players.LocalPlayer
local Char = P.Character or P.CharacterAdded:Wait()
-- local H = Char:WaitForChild("Humanoid")

local Offset = 10

RunService.RenderStepped:Connect(function()
	local ViewportSize = Camera.ViewportSize
	local Aspect = ViewportSize.X / ViewportSize.Y

	if Aspect > 1.5 then
		Offset = 10
	else
		Offset = 13
	end

	Speedlines.CFrame = Camera.CFrame + Camera.CFrame.LookVector * (Offset / (Camera.FieldOfView / 70))
	Speedlines.Attachment.ParticleEmitter.Rate = SpeedlineHandler.Rate
	Speedlines.Parent = Camera
end)
