local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

local Buy = require(ServerScriptService.GUI.Specific.Buy)
local Cata = require(ServerScriptService.GUI.Specific.Cata)
local init = require(script.Parent.GuiInitializer)

local ButtonsGui = ServerStorage.GUI.StartButtons
local RoundCounter = ServerStorage.GUI.RoundCounter
local BuyGui = ServerStorage.GUI.BuyGUI
local Balance = ServerStorage.GUI.Money
local Catalogue = ServerStorage.GUI.Balltalogue

local BuyGuiTrigger: ProximityPrompt = game.Workspace.Shop.Shop
local BallCatalogueTrigger: ProximityPrompt = game.Workspace.Book.ProximityPrompt

Players.PlayerAdded:Connect(function(P: Player)
	print("player joined, initating gui transfers")
	init.InitGuiForPlayer(P, ButtonsGui, true)
	init.InitGuiForPlayer(P, BuyGui, true)
	init.InitGuiForPlayer(P, RoundCounter, false)
	init.InitGuiForPlayer(P, Balance, false)
	init.InitGuiForPlayer(P, Catalogue, true)

	init.InitProximityPrompts(BuyGuiTrigger, "buy", Buy.TriggerRUN)
	init.InitProximityPrompts(BallCatalogueTrigger, "cata", Cata.TriggerRUN)

	P.CharacterAdded:Connect(function(_C: Model)
		init.InitGuiForPlayer(P, ButtonsGui, true)
		init.InitGuiForPlayer(P, BuyGui, true)
		init.InitGuiForPlayer(P, RoundCounter, false)
		init.InitGuiForPlayer(P, Balance, false)
		init.InitGuiForPlayer(P, Catalogue, true)
	end)
end)

local Specifics = script.Parent.Specific

for _, GuiModule in ipairs(Specifics:GetChildren()) do
	local Module = require(GuiModule)
	Module.REG_BTN() -- no nil checks because you're supposed to FOLLOW THE RULES
end
