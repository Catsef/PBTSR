local ServerScriptService = game:GetService("ServerScriptService")

local ServerStorage = game:GetService("ServerStorage")

local UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)
local ButtonEvent: BindableEvent = ServerStorage.Bindings.GUI.ButtonSend
local g = {}
local ButtonConnection

function g.REG_BTN()
	if ButtonConnection then
		return
	end
	ButtonConnection = ButtonEvent.Event:Connect(function(id: string, player: Player)
		UtilityFunctions.SwitchWithCaseTable(id, {

			["round"] = function() end,
			["game"] = function() end,
		})
	end)
end

return g
