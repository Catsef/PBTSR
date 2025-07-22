local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RespawnRE: RemoteEvent = ReplicatedStorage.Events.Respawn
local cam = workspace.CurrentCamera

function ChildGetter(ParentInstance: Instance, childName: string, className: string, maxTime, usageInfo: string)
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

RespawnRE.OnClientEvent:Connect(function()
	local Character = Players.LocalPlayer.CharacterAdded:Wait()
	local Humanoid = ChildGetter(Character, "Humanoid", "Humanoid", 5, "reset the player camera subject")
	cam.CameraSubject = Humanoid
end)
