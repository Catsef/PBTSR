local ServerStorage = game:GetService("ServerStorage")
local TweenService = game:GetService("TweenService")
local Grass = ServerStorage.Map.RefPartGrass

local u = {}

function u.SetMatGrass(otherPart: Part)
	-- non-optional
	otherPart.Anchored = true

	otherPart.Color = Grass.Color
	otherPart.Material = Grass.Material
end

function u.TweenUpTrans(otherPart: Part)
	otherPart.Transparency = 1
	local t = TweenService:Create(
		otherPart,
		TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
		{ Transparency = 0 }
	)

	t:Play()

	return t
end

return u
