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
		if v.Character:FindFirstChild("Humanoid") then
			if v.Character:FindFirstChild("Humanoid").Health == 0 then
				continue
			end
		else
			continue
		end
		local char = v.Character
		local dist = v:DistanceFromCharacter(refPart.Position)
		if not char or dist > mD or (nearestDist and dist >= nearestDist) then
			continue
		end
		nearestDist = dist
		nearestPlayer = v
	end

	if not nearestPlayer or not nearestPlayer.Character or (not nearestPlayer.Character:FindFirstChild("Humanoid")) then
		warn("Nearest player missing some components!")
		return nil
	end

	return nearestPlayer
end

function m.ChildGetter(ParentInstance: Instance, childName: string, className: string, maxTime, usageInfo: string)
	print(
		"ChildGetter(): To "
			.. usageInfo
			.. ", we are attempting to safely retrieve "
			.. childName
			.. " which is a "
			.. className
			.. " directly from the children of "
			.. ParentInstance.Name
	)

	if ParentInstance == nil or ParentInstance.Parent == nil then
		error("ChildGetter(): parentClass is nil or parentClass's Parent is nil.")
	end
	local child = ParentInstance:WaitForChild(childName, maxTime)
	if child == nil or child.Parent == nil then
		warn("ChildGetter(): child is nil or child's Parent is nil!")
	elseif not child:IsA(className) then
		error("ChildGetter(): Child doesn't match class supplied with className.")
	end

	return child
end

function m.DescendantGetter(parent: Instance, rumouredDescendant: string, className: string, usageInfo: string)
	print(
		"DescendantGetter(): To "
			.. usageInfo
			.. ", we are attempting to safely retrieve "
			.. rumouredDescendant
			.. " which is a "
			.. className
			.. " directly from the children of "
			.. parent.Name
	)
	if parent == nil or parent.Parent == nil then
		error("DescendantGetter(): parent is nil or parent's Parent is nil.")
	end

	local Descendants = parent:GetDescendants()

	if #Descendants == 0 then
		warn("DescendantGetter(): " .. parent.Name .. "'s descendants contain 0 children!")
	end

	local result = nil
	for _, descendant in ipairs(Descendants) do
		if descendant.Name ~= rumouredDescendant then
			continue
		end

		if descendant:IsA(className) then
			result = descendant
		else
			warn(
				"DescendantGetter(): Matched name, but type is different. Ref:"
					.. className
					.. "; Cur:"
					.. descendant.ClassName
			)
		end
	end

	if result == nil then
		warn(
			"DescendantGetter(): Couldn't find result. Keep in mind that this doesn't use WaitForChild. Returning nil!"
		)
	end

	return result
end

return m
