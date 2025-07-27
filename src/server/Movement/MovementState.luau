local S = {}

S.States = {}
S.States.Jumping = "JUMPING" -- walking jump [STATE]
S.States.Leaping = "LEAPING" -- running jump [STATE] [ANIMATION]
S.States.Diving = "DIVING" -- jumping/leaping + [SPACE] [ANIMATION]
S.States.Walking = "WALK" -- press W for 0 to 0.49 seconds [STATE]
S.States.Running = "RUN" -- pressing W after 0.5 seconds [STATE]
S.States.Dashing = "DASHING" -- leaping/diving [Q] [ANIMATION]
S.States.Sliding = "SLIDING" -- walk/run [Q] [LIMIT_MOVEMENT] [ANIMATION]
S.States.Sneaking = "TAUNT" -- none [Q] [NO_MOVEMENT] [ANIMATION]
S.States.Standing = "NONE" -- not pressing any button
S.States.Dead = "IGNORE" -- humanoid/character dead [STATE]

S.PlayerState = {} -- [player] = S.States.State

S.PlayerMovementKeys = {} -- [player] = {Enum.KeyCode.Key ...}

S.KeysAdd = function(Player: Player, KeyCode: Enum.KeyCode)
	if table.find(S.PlayerMovementKeys[Player], KeyCode) then
		error("ran KeysAdd to add a key to playermovementkeys, but key already exists?")
		-- dual input == keysremove error as well
	end
	table.insert(S.PlayerMovementKeys[Player], KeyCode)
end

S.KeysRemove = function(Player: Player, KeyCode: Enum.KeyCode)
	local index = table.find(S.PlayerMovementKeys[Player], KeyCode)
	if not index then
		error("ran KeysRemove to remove a key from playermovementkeys, but no key exists?")
	end
	table.remove(S.PlayerMovementKeys[Player], index)
end

S.Update = function(Player, State)
	S.PlayerState[Player] = State
	print("set player " .. Player.Name .. "'s state to " .. State)
end
return S
