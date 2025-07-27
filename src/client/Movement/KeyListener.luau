local RunService = game:GetService("RunService")
local Player: Player = game.Players.LocalPlayer

local RenderSteppedConnection = nil

function CharacterAdded(Character: Model)
	local Humanoid = Character:WaitForChild("Humanoid")
	if not (Humanoid and Humanoid:IsA("Humanoid")) then
		error("Humanoid from Character is not a Humanoid!")
	end
	local _Root = Character:WaitForChild("HumanoidRootPart")

	if RenderSteppedConnection then
		RenderSteppedConnection:Disconnect()
	end

	RenderSteppedConnection = RunService.RenderStepped:Connect(function(a0: number)
		if not Humanoid then
			warn("no Humanoid in RenderSteppedConnection in KeyListener in Movement, client")
			return
		end

		-- if Humanoid.MoveDirection.Magnitude > 0 then
		-- 	-- override keybind state if available
		-- else

		-- end
	end)

	-- if humanoid dies then disconnect to prevent mass erroring, also spectate system
	Humanoid.Died:Connect(function(...: any)
		RenderSteppedConnection:Disconnect()
		RenderSteppedConnection = nil
	end)
end

Player.CharacterAdded:Connect(CharacterAdded)
