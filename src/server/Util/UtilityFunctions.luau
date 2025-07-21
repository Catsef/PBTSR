local m = {}

function m.SwitchWithCaseTable(Parameter, CaseTable)
	local case = CaseTable[Parameter]
	if case then
		return case()
	end
	local def = CaseTable["default"]
	return def and def() or nil
end

function m.CompareUnorderedSets(ListA, ListB)
	if (#ListA == 0) or (#ListB == 0) then
		return false
	end
	if #ListA ~= #ListB then
		return false
	end -- if they r different lengths, return false

	local Lookup = {} -- lookup tables
	for _, player in ipairs(ListB) do
		Lookup[player] = true
	end

	for _, player in ipairs(ListA) do
		if not Lookup[player] then
			return false
		end
	end

	return true
end

function m.FindNearestPlayer(maxDist, refPart)
	local mD = maxDist or 100000
	local nearestDist, nearestPlayer
	for _, v in pairs(game:GetService("Players"):GetPlayers()) do
		local char = v.Character
		local dist = v:DistanceFromCharacter(refPart.Position)
		if not char or dist > mD or (nearestDist and dist >= nearestDist) then
			continue
		end
		nearestDist = dist
		nearestPlayer = v
	end

	if
		not nearestPlayer
		or (not nearestPlayer:FindFirstChild("Character"))
		or (not nearestPlayer:FindFirstChild("Character"):FindFirstChild("Humanoid"))
	then
		warn("Nearest player missing some components!")
		return nil
	end

	return nearestPlayer
end

return m
