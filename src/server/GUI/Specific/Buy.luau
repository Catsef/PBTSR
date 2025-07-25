local g = {}
local ButtonConnection

local ServerScriptService = game:GetService("ServerScriptService")

local ServerStorage = game:GetService("ServerStorage")

local PlayerProfileManager = require(ServerScriptService.Data.PlayerProfileManager)
local PBTS = require(ServerScriptService.Enumeration.PBTS)
local UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)
local ButtonEvent: BindableEvent = ServerStorage.Bindings.GUI.ButtonSend

local TOOL_ANNIHILATOR = ServerStorage.Tools.Annihilator

function g.TriggerRUN(player)
	local gui = player.PlayerGui.BuyGUI
	gui.Enabled = true
end

function BoughtItem(RefItem, Price, Player, Message)
	local result = PlayerProfileManager.TransactMoney(Player, -Price)
	if result == PBTS.MoneyTransactionResult.Success then
		print(Message)
		local tool = RefItem:Clone()
		tool.Parent = Player.Backpack
	end
end

function ExitBuyMenu(Player)
	local gui = Player.PlayerGui.BuyGUI
	gui.Enabled = false
end

function g.REG_BTN()
	if ButtonConnection then
		return
	end
	ButtonConnection = ButtonEvent.Event:Connect(function(id: string, player: Player)
		UtilityFunctions.SwitchWithCaseTable(id, {

			["annihilatorbuy"] = function()
				BoughtItem(TOOL_ANNIHILATOR, 50, player, "annihilator bought from store")
			end,
			["annihilatorstat"] = function() end,
			["exitbuy"] = function()
				ExitBuyMenu(player)
			end,
		})
	end)
end

return g
