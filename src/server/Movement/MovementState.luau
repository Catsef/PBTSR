local ReplicatedStorage = game:GetService("ReplicatedStorage")
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

S.Limitations = {}
S.Limitations.Slowed = "SLOWED"

S.RemoteEvents = {}
S.RemoteEvents.StateChange = ReplicatedStorage.Movement.StateChange

S.PlayerState = {} -- [player] = S.States.State

S.PlayerMovementKeys = {} -- [player] = {Enum.KeyCode.Key ...}

S.PlayerMovementLimitations = {} -- [player] = {S.Limitations.Limitation ...}

local function ADD_KEY(Player, KeyCode, CTime)
	table.insert(S.PlayerMovementKeys[Player], {
		key = KeyCode,
		time = CTime,
	})
end

function S.GET_KEY(Player, KeyCode)
	local index = nil
	for i, v in ipairs(S.PlayerMovementKeys[Player]) do
		if KeyCode == v.key then
			index = i
		end
	end
	return index
end

S.KeysAdd = function(Player: Player, KeyCode: Enum.KeyCode)
	local index = S.GET_KEY(Player, KeyCode)
	if index then
		error("ran KeysAdd to add a key to playermovementkeys, but key already exists?")
		-- dual input == keysremove error as well
	end
	ADD_KEY(Player, KeyCode, os.clock())
end

S.KeysRemove = function(Player: Player, KeyCode: Enum.KeyCode)
	local index = S.GET_KEY(Player, KeyCode)
	if not index then
		error("ran KeysRemove to remove a key from playermovementkeys, but no key exists?")
	end
	table.remove(S.PlayerMovementKeys[Player], index)
end

S.Update = function(Player, State)
	if S.PlayerState[Player] ~= State then
		S.RemoteEvents.StateChange:FireClient(Player, S.PlayerState[Player], State)
	end
	S.PlayerState[Player] = State
end
return S
