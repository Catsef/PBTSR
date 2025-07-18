local ButtonsGui = game:GetService("ServerStorage").GUI.StartButtons
local ButtonSendEvent: BindableEvent = game:GetService("ServerStorage").Bindings.GUI.ButtonSend

-- startbuttons hierarchy:
-- StartButtons
--  └── Round (Start Round textbutton), string attribute "sendid" for remote event trigger - "round"
--  └── Game (Start Game textbutton), string attribute "sendid" for remote event trigger - "game"

function InitialiseButtonsGui(player: Player)
	if not player:WaitForChild("PlayerGui"):FindFirstChild("StartButtons") then
		local ButtonsGuiForPlayer = ButtonsGui:Clone()
		ButtonsGuiForPlayer.Parent = player:WaitForChild("PlayerGui")
	end

	local gui = player.PlayerGui:WaitForChild("StartButtons")
	for _, button in ipairs(gui:GetChildren()) do
		if button:IsA("TextButton") then
			local sendId = button:GetAttribute("sendid")
			if sendId then
				button.MouseButton1Click:Connect(function()
					ButtonSendEvent:Fire(sendId, player)
				end)
			end
		end
	end
end

game:GetService("Players").PlayerAdded:Connect(function(player: Player)
	InitialiseButtonsGui(player)

	player.CharacterAppearanceLoaded:Connect(function(_char: Model)
		InitialiseButtonsGui(player)
	end)
end)
