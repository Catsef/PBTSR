local ServerStorage = game:GetService("ServerStorage")
local Grass = ServerStorage.Map.RefPartGrass

local u = {}

function u.SetMatGrass(otherPart: Part)
	-- non-optional
	otherPart.Anchored = true

	otherPart.Color = Grass.Color
	otherPart.Material = Grass.Material
end

return u
