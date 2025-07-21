local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local P = Players.LocalPlayer
local Cam = workspace.CurrentCamera

local MaxTilt = 0.15

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
end
