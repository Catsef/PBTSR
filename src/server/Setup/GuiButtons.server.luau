local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local PlayerProfileManager = require(ServerScriptService.Data.PlayerProfileManager)
local PBTS = require(ServerScriptService.Enumeration.PBTS)
local GameState = require(ServerScriptService.GameState.GameState)
local UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)
local ButtonEvent: BindableEvent = ServerStorage.Bindings.GUI.ButtonSend

local TOOL_ANNIHILATOR = ServerStorage.Tools.Annihilator

-- startbuttons hierarchy:
-- StartButtons
--  └── Round (Start Round textbutton), string attribute "sendid" for remote event trigger - "round"
--  └── Game (Start Game textbutton), string attribute "sendid" for remote event trigger - "game"

ButtonEvent.Event:Connect(function(sendId: string, player: Player)
	UtilityFunctions.SwitchWithCaseTable(sendId, {
		["round"] = function()
			if
				not GameState.roundStarted
				and GameState.buyPhase
				and (not table.find(GameState.AllRoundReadiedPlayers, player))
			then
				table.insert(GameState.AllRoundReadiedPlayers, player)
				print("Round readied by player: " .. player.Name .. "!")
			end
		end,
		["game"] = function()
			if (not GameState.gameStarted) and (not table.find(GameState.AllGameReadiedPlayers, player)) then
				table.insert(GameState.AllGameReadiedPlayers, player)
				print("Game readied by player: " .. player.Name .. "!")
			end
		end,
		["annihilatorstat"] = function()
			-- TODO: finish annihilator stat
		end,
		["annihilatorbuy"] = function()
			-- TODO: finish annihilator buy, item system
			local result = PlayerProfileManager.TransactMoney(player, -50)
			if PBTS.MoneyTransactionResult.Success then
				print("Add da AnniHilator to da player inv")

				local annihi = TOOL_ANNIHILATOR:Clone()
				annihi.Parent = player.Backpack
			end
		end,
		default = function()
			error("GameStateGui - ButtonEvent: unrecognized sendId:" .. sendId)
		end,
	})
end)
