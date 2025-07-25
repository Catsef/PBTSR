local ServerScriptService = game:GetService("ServerScriptService")

local ServerStorage = game:GetService("ServerStorage")

local GameState = require(ServerScriptService.GameState.State.GameState)
local StatePlayers = require(ServerScriptService.GameState.State.StatePlayers)
local UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)
local ButtonEvent: BindableEvent = ServerStorage.Bindings.GUI.ButtonSend
local g = {}
local ButtonConnection

function PlayerClickedRound(player: Player)
	if not GameState.PhaseRound and GameState.PhaseBuy and (not table.find(StatePlayers.Readied.Round, player)) then
		table.insert(StatePlayers.Readied.Round, player)
		print("Round readied by player: " .. player.Name .. "!")
	end
end

function PlayerClickedGame(player: Player)
	if (not GameState.PhaseGame) and (not table.find(StatePlayers.Readied.Game, player)) then
		table.insert(StatePlayers.Readied.Game, player)
		print("Game readied by player: " .. player.Name .. "!")
	end
end

function g.REG_BTN()
	if ButtonConnection then
		return
	end
	ButtonConnection = ButtonEvent.Event:Connect(function(id: string, player: Player)
		UtilityFunctions.SwitchWithCaseTable(id, {

			["round"] = function()
				PlayerClickedRound(player)
			end,
			["game"] = function()
				PlayerClickedGame(player)
			end,
		})
	end)
end

return g
