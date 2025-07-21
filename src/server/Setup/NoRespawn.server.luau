local Players = game:GetService("Players")
Players.CharacterAutoLoads = false

-- bless newcomers with a body for their soul
Players.PlayerAdded:Connect(function(P: Player)
	P:LoadCharacter()
end)
