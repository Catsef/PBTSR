local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local GameStateRunner = require(ServerScriptService.GameState.GameStateRunner)
local ButtonsGui = ServerStorage.GUI.StartButtons
local RoundCounter = ServerStorage.GUI.RoundCounter
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
	print("InitialiseButtonsGui - added buttons to player; attached event listeners: " .. player.Name)
end

function InitialiseRoundCounter(player: Player)
	if not player:WaitForChild("PlayerGui"):FindFirstChild("RoundCounter") then
		local RoundCounterForPlayer: ScreenGui = RoundCounter:Clone()
		RoundCounterForPlayer.Parent = player:WaitForChild("PlayerGui")
		print("InitialiseRoundCounter - added round counter to player: " .. player.Name)
	end
end

game:GetService("Players").PlayerAdded:Connect(function(player: Player)
	print("player joined, initiating GUI...")
	InitialiseButtonsGui(player)
	InitialiseRoundCounter(player)
	print("..done")

	player.CharacterAppearanceLoaded:Connect(function(_char: Model)
		InitialiseButtonsGui(player)
		InitialiseRoundCounter(player)
		GameStateRunner.UpdatePlayerButtons()
		GameStateRunner.UpdateRoundCounter()
	end)
end)
