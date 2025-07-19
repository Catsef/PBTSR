local E = {}
local Players = game:GetService("Players")
E.PlayersEffects = {}

function E.InitiatePlayer(Player: Player)
	E.PlayersEffects[Player] = {
		Effects = {},
	}
end

Players.PlayerAdded:Connect(function(a0: Player)
	a0.CharacterAdded:Connect(function(a1: Model)
		E.InitiatePlayer(a0)
	end)
end)

return E
