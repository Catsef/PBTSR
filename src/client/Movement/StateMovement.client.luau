local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StateChange: RemoteEvent = ReplicatedStorage.Movement.StateChange
local run_Track: AnimationTrack = nil

Players.LocalPlayer.CharacterAdded:Connect(function(C: Model)
	-- INITIALIZE ALL ANIMATIONS
	local H = C:WaitForChild("Humanoid")
	local A = H:WaitForChild("Animator")
	local run = Instance.new("Animation")
	run.AnimationId = "rbxassetid://118600440110169"

	run_Track = A:LoadAnimation(run)
end)

StateChange.OnClientEvent:Connect(function(PREV_STATE, NEW_STATE)
	print("Client: state change")
	-- 118600440110169
	-- S.States.Jumping = "JUMPING" -- walking jump [STATE]
	-- S.States.Leaping = "LEAPING" -- running jump [STATE] [ANIMATION]
	-- S.States.Diving = "DIVING" -- jumping/leaping + [SPACE] [ANIMATION]
	-- S.States.Walking = "WALK" -- press W for 0 to 0.49 seconds [STATE]
	-- S.States.Running = "RUN" -- pressing W after 0.5 seconds [STATE]
	-- S.States.Dashing = "DASHING" -- leaping/diving [Q] [ANIMATION]
	-- S.States.Sliding = "SLIDING" -- walk/run [Q] [LIMIT_MOVEMENT] [ANIMATION]
	-- S.States.Sneaking = "TAUNT" -- none [Q] [NO_MOVEMENT] [ANIMATION]
	-- S.States.Standing = "NONE" -- not pressing any button
	-- S.States.Dead = "IGNORE" -- humanoid/character dead [STATE]
	if PREV_STATE == "WALK" and NEW_STATE == "RUN" then
		if run_Track then
			run_Track:Play(0, 100, 1)
		end
	end
end)
