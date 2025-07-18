local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local GameState = require(ServerScriptService.GameState.GameState)
local GameStateRunner = require(ServerScriptService.GameState.GameStateRunner)
local ButtonsGui = ServerStorage.GUI.StartButtons
local RoundCounter = ServerStorage.GUI.RoundCounter
local BuyGui = ServerStorage.GUI.BuyGUI

local BuyGuiTrigger: ProximityPrompt = game.Workspace.Shop.Shop
local BuyGuiTriggerConnection: RBXScriptConnection

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

function InitialiseBuyTriggers()
	if BuyGuiTriggerConnection then
		return
	end
	BuyGuiTriggerConnection = BuyGuiTrigger.Triggered:Connect(function(p: Player)
		local buygui = p:WaitForChild("PlayerGui"):FindFirstChild("BuyGUI")
		if not buygui then
			error(
				"somehow, player "
					.. p.Name
					.. " triggered BuyGuiTrigger before BuyGui was cloned into the player - InitialiseBuyTriggers"
			)
		end

		if not GameState.buyPhase then
			return
		end

		buygui.Enabled = true
	end)
end

function InitialiseBuyGui(player: Player)
	-- BuyGUI -- triggered enable from ProxPrompt
	-- 		MF
	--			main
	-- 				Annihilator
	-- 					T (text)
	--					L (stats)
	--					U (buy)
	--			topbar
	--				exit
	-- 				TextLabel

	if not player:WaitForChild("PlayerGui"):FindFirstChild("BuyGUI") then
		local Buy: ScreenGui = BuyGui:Clone()
		Buy.Parent = player:WaitForChild("PlayerGui")
		print("InitialiseBuyGui - added buy gui to player: " .. player.Name)
	end

	local Buy = player.PlayerGui:WaitForChild("BuyGUI")
	-- Initiate buttonsend events
	for _, child in ipairs(Buy:GetDescendants()) do
		if child:IsA("TextButton") then
			local sendid = child:GetAttribute("sendid")
			if not sendid then
				continue
			end
			if sendid == "exitbuy" then
				child.MouseButton1Click:Connect(function()
					Buy.Enabled = false
				end)
				continue
			end
			child.MouseButton1Click:Connect(function()
				ButtonSendEvent:Fire(sendid, player)
			end)
		end
	end
end

game:GetService("Players").PlayerAdded:Connect(function(player: Player)
	print("player joined, initiating GUI...")
	InitialiseButtonsGui(player)
	InitialiseRoundCounter(player)
	InitialiseBuyGui(player)
	InitialiseBuyTriggers()
	print("..done")

	player.CharacterAppearanceLoaded:Connect(function(_char: Model)
		InitialiseButtonsGui(player)
		InitialiseRoundCounter(player)
		InitialiseBuyGui(player)
		GameStateRunner.UpdatePlayerButtons()
		GameStateRunner.UpdateRoundCounter()
	end)
end)
