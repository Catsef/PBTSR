local RunService = game:GetService("RunService")
local m = {}
m.States = {}
m.States.Jumping = "JUMPING" -- walking jump [STATE]
m.States.Leaping = "LEAPING" -- running jump [STATE] [ANIMATION]
m.States.Diving = "DIVING" -- jumping/leaping + [SPACE] [ANIMATION]
m.States.Walking = "WALK" -- press W for 0 to 0.49 seconds [STATE]
m.States.Running = "RUN" -- pressing W after 0.5 seconds [STATE]
m.States.Dashing = "DASHING" -- leaping/diving [Q] [ANIMATION]
m.States.Sliding = "SLIDING" -- walk/run [Q] [LIMIT_MOVEMENT] [ANIMATION]
m.States.Sneaking = "TAUNT" -- none [Q] [NO_MOVEMENT] [ANIMATION]
m.States.Standing = "NONE" -- not pressing any button
m.States.Dead = "IGNORE" -- humanoid/character dead [STATE]
m.State = m.States.Standing
m.MovementKeys = {}

m.ADDKEY = function(KC: Enum.KeyCode, CT: number)
	table.insert(m.MovementKeys, {
		key = KC,
		time = CT,
	})
end

m.GETKEY = function(KC)
	local index = nil
	for i, v in ipairs(m.MovementKeys) do
		if KC == v.key then
			index = i
		end
	end
	return index
end

m.KEYSADD = function(KC: Enum.KeyCode)
	local index = m.GETKEY(KC)
	if index then
		error("ran KEYSADD to a key to PMK, but key already exists")
	end
	m.ADDKEY(KC, os.clock())
end

m.KEYSREMOVE = function(KC)
	local index = m.GETKEY(KC)
	if not index then
		error("ran KEYSREMOVE to remove a key from PMK but no key exists")
	end
	table.remove(m.MovementKeys, index)
end

m.UPD = function(ST)
	if m.State ~= ST then
		print("PD..." .. m.State .. "..T.." .. ST .. "...")
	end
	m.State = ST
end

function m.ClientPredictorKeyListen(State: Enum.UserInputState, Key: Enum.KeyCode, Type: Enum.UserInputType)
	if m.State == m.States.Dead then
		return
	end

	if State == Enum.UserInputState.Begin then
		m.KEYSADD(Key)
	elseif State == Enum.UserInputState.End then
		m.KEYSREMOVE(Key)
	end
end

function m.MAIN()
	RunService.RenderStepped:Connect(function(a0: number) end)
end

return m
