local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local P = Players.LocalPlayer
local Cam = workspace.CurrentCamera

local TiltAmount = 0.05
local CurrentTilt = 0
local TiltLerp = 0.2

local CurrentFovAdded = 0
local FovAddAmount = 15
local FovLerp = 0.1
local BaseFOV = 105

local function GetSideMovement_RelaCam()
	local char = P.Character
	if not char then
		return
	end

	local h = char.Humanoid
	if not h then
		return
	end

	local moveDirection = h.MoveDirection
	return Cam.CFrame.RightVector:Dot(moveDirection)
end

local function GetFrontMovement_RelaCam()
	local char = P.Character
	if not char then
		return
	end

	local h = char.Humanoid
	if not h then
		return
	end

	local moveDirection = h.MoveDirection
	return Cam.CFrame.LookVector:Dot(moveDirection)
end

RunService:BindToRenderStep("TiltMovement", Enum.RenderPriority.Camera.Value + 1, function(_delt)
	local GSM = GetSideMovement_RelaCam()
	local GFM = GetFrontMovement_RelaCam()
	if (not GSM) or not GFM then
		return
	end
	local targetTilt = -GSM * TiltAmount
	CurrentTilt = CurrentTilt + (targetTilt - CurrentTilt) * TiltLerp
	Cam.CFrame = Cam.CFrame * CFrame.Angles(0, 0, CurrentTilt)

	local targetFov = BaseFOV + (FovAddAmount * GFM)
	CurrentFovAdded = CurrentFovAdded + (targetFov - CurrentFovAdded) * FovLerp
	Cam.FieldOfView = CurrentFovAdded
end)
