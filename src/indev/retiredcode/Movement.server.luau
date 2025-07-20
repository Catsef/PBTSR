local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local JumpRemote: RemoteEvent = ReplicatedStorage.Events.Jumped

local PlayerHeartBeatConnections = {}
local PlayerAirstrafes = {} -- [Player] = {Airstrafe}

Players.PlayerAdded:Connect(function(P: Player)
	P.CharacterAppearanceLoaded:Connect(function(a0)
		local Human: Humanoid = a0:WaitForChild("Humanoid")
		local HRP = a0.HumanoidRootPart

		Human.WalkSpeed = 30
		Human.JumpHeight = 5
	end)
end)

function ApplyBoostVelo(Player)
	local Success, Error = pcall(function(...)
		local LookV = Player.Character.Head.CFrame.LookVector
		local HRP = Player.Character.HumanoidRootPart
		local BoostBodyVelo: BodyVelocity = Instance.new("BodyVelocity")
		BoostBodyVelo.Velocity = LookV * Player.Character.Humanoid.WalkSpeed
		BoostBodyVelo.MaxForce = Vector3.new(40000, 0, 40000)
		BoostBodyVelo.Parent = HRP
		if PlayerAirstrafes[Player] ~= nil then
			PlayerAirstrafes[Player]:Destroy()
		end
		PlayerAirstrafes[Player] = BoostBodyVelo

		-- task.delay(0.1, function()
		-- 	if BoostBodyVelo and BoostBodyVelo.Parent then
		-- 		BoostBodyVelo:Destroy()
		-- 	end
		-- end)
	end)
	if not Success then
		warn(Error)
	end
end
JumpRemote.OnServerEvent:Connect(function(Player, InputState)
	if InputState == Enum.UserInputState.Begin then
		PlayerHeartBeatConnections[Player] = RunService.Heartbeat:Connect(function(_: number)
			ApplyBoostVelo(Player)
		end)
	end

	if InputState == Enum.UserInputState.End then
		PlayerHeartBeatConnections[Player]:Disconnect()
		if PlayerAirstrafes[Player] ~= nil then
			PlayerAirstrafes[Player]:Destroy()
		end
	end
end)
