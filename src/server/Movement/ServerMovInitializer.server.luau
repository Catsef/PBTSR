local Players = game:GetService("Players")

local MovementState = require(script.Parent.MovementState)
Players.PlayerAdded:Connect(function(a0: Player) 

    -- set every player's state to be Standing
    MovementState

end)