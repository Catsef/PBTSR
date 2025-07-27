local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)
local MovementState = require(script.Parent.MovementState)

Players.PlayerAdded:Connect(function(p: Player)
	-- set every player's state to be Standing
	MovementState.PlayerState[p] = MovementState.States.Standing

	p.CharacterAdded:Connect(function(c: Model)
		MovementState.PlayerState[p] = MovementState.States.Standing

		local h: Humanoid =
			UtilityFunctions.ChildGetter(c, "Humanoid", "Humanoid", 5, "connect death to movementstate dead")

		h.Died:Connect(function(...: any)
			MovementState.PlayerState[p] = MovementState.States.Dead -- until CharacterAdded
		end)
	end)
end)
