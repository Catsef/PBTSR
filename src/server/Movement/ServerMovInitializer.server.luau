local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)
local MovementState = require(script.Parent.MovementState)

Players.PlayerAdded:Connect(function(p: Player)
	-- set every player's state to be Standing
	MovementState.Update(p, MovementState.States.Standing)

	p.CharacterAdded:Connect(function(c: Model)
		MovementState.Update(p, MovementState.States.Standing)
		local h: Humanoid =
			UtilityFunctions.ChildGetter(c, "Humanoid", "Humanoid", 5, "connect death to movementstate dead")

		h.Died:Connect(function(...: any)
			MovementState.Update(p, MovementState.States.Dead)
		end)
	end)
end)
