local g = {}
local ButtonConnection

local ServerScriptService = game:GetService("ServerScriptService")

local ServerStorage = game:GetService("ServerStorage")

local UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)
local ButtonEvent: BindableEvent = ServerStorage.Bindings.GUI.ButtonSend

function CloseCatalogue(P: Player)
	local PGUI = P:FindFirstChild("PlayerGui")
	if not PGUI then
		warn("couldnt close catalogue because playergui doesnt exist in player")
		return
	end
	local Catalogue = PGUI:FindFirstChild("Balltalogue")
	if not Catalogue then
		warn("couldnt close catalogue because catalogue doesnt exist in player")
	end
	Catalogue.Enabled = false
end

function g.TriggerRUN() end

function g.REG_BTN()
	if ButtonConnection then
		return
	end
	ButtonConnection = ButtonEvent.Event:Connect(function(id: string, player: Player)
		UtilityFunctions.SwitchWithCaseTable(id, {

			["closelogue"] = function()
				CloseCatalogue(player)
			end,
		})
	end)
end

return g
