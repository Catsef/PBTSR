local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local P = Players.LocalPlayer
local Cam = workspace.CurrentCamera

local TiltAmount = 0.01
local CurrentTilt = 0
local Lerp = 0.2

local function GetSideMovement_RelaCam()
	local char = P.Character
	if not char then
		warn("could not find char when running GetSideMovement")
		return
	end

	local h = char.Humanoid
	if not h then
		warn("could not find humanoid when running getSideMovement")
		return
	end

	local moveDirection = h.MoveDirection
	return Cam.CFrame.RightVector:Dot(moveDirection)
end

RunService:BindToRenderStep("TiltMovement", Enum.RenderPriority.Camera.Value + 1, function(_delt)
	local GSM = GetSideMovement_RelaCam()
	if not GSM then
		return
	end
	local targetTilt = -GSM * TiltAmount
	CurrentTilt = CurrentTilt + (targetTilt - CurrentTilt) * Lerp
	Cam.CFrame = Cam.CFrame * CFrame.Angles(0, 0, CurrentTilt)
end)
