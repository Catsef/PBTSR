local ServerScriptService = game:GetService("ServerScriptService")

local ServerStorage = game:GetService("ServerStorage")

local GameState = require(ServerScriptService.GameState.GameState)
local UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)
local ButtonEvent: BindableEvent = ServerStorage.Bindings.GUI.ButtonSend
local g = {}
local ButtonConnection

function PlayerClickedRound(player: Player)
	if
		not GameState.roundStarted
		and GameState.buyPhase
		and (not table.find(GameState.AllRoundReadiedPlayers, player))
	then
		table.insert(GameState.AllRoundReadiedPlayers, player)
		print("Round readied by player: " .. player.Name .. "!")
	end
end

function PlayerClickedGame(player: Player)
	if (not GameState.gameStarted) and (not table.find(GameState.AllGameReadiedPlayers, player)) then
		table.insert(GameState.AllGameReadiedPlayers, player)
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
