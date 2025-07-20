local ServerScriptService = game:GetService("ServerScriptService")
local PBTS = require(ServerScriptService.Enumeration.PBTS)
local EffectsModule = require(script.Parent.EffectsHandler)
local m = {}
m.WalkSpeedModifier = 10
m.BaseWalkSpeed = 30
local r = Random.new()

function m.Effect(Strength: number, Time: number)
	return {
		effect = PBTS.Effects.SLOW,
		strength = Strength,
		time = Time,
		ended = false,
		UNIQUE_IDENTIFIER = r:NextNumber(-10000000, 10000000),
	}
end

function m.Start(Player, Effect)
	if (not Effect.effect) or not Effect.strength or not Effect.time then
		error("Missing args (Slow.luau) to Slow.Start()")
	end

	if Player.Character.Humanoid then
		local Humanoid: Humanoid = Player.Character.Humanoid
		Humanoid.WalkSpeed -= (m.WalkSpeedModifier * Effect.strength)
	else
		print(Player)
		print(Player.Character)
		print(Player.Character.Humanoid)
		-- error("Player: either has no Character, or has no Humanoid within Character (Slow.luau - End())")
	end

	print("Effect SLOW applied to " .. Player.Name)

	table.insert(EffectsModule.PlayersEffects[Player], Effect)

	local function EndWhenTimerExpires()
		task.wait(Effect.time)
		task.spawn(function()
			m.End(Player, Effect)
		end)
	end
	task.spawn(EndWhenTimerExpires)
end

function m.End(Player, Effect)
	if Effect.ended then
		return
	end

	if Player.Character.Humanoid then
		local Humanoid: Humanoid = Player.Character.Humanoid
		Humanoid.WalkSpeed += (m.WalkSpeedModifier * Effect.strength)
		if Humanoid.WalkSpeed > m.BaseWalkSpeed then
			Humanoid.WalkSpeed = m.BaseWalkSpeed
		end
	else
		print(Player)
		print(Player.Character)
		print(Player.Character.Humanoid)
		error("Player: either has no Character, or has no Humanoid within Character (Slow.luau - End())")
	end

	print("Effect SLOW removed from " .. Player.Name)

	for i, v in ipairs(EffectsModule.PlayersEffects[Player]) do
		if v == Effect then
			table.remove(EffectsModule.PlayersEffects[Player], i)
			break
		end
	end
end

return m
