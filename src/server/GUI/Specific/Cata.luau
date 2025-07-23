local g = {}
local ButtonConnection

local ServerScriptService = game:GetService("ServerScriptService")

local ServerStorage = game:GetService("ServerStorage")
local TweenService = game:GetService("TweenService")

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
		return
	end
	if not Catalogue:IsA("ScreenGui") then
		warn("couldnt close catalogue because catalogue in player isin't a screengui")
		return
	end

	if not Catalogue:FindFirstChild("MF") then
		warn("couldn't tween catalogue close because mainframe doesnt exist")
	end
	if not Catalogue:FindFirstChild("MF"):IsA("Frame") then
		warn("couldn't tween catalogue close because mainframe isint a frame")
	end

	local Mainframe: Frame = Catalogue:FindFirstChild("MF")

	local OriginalPosition = Mainframe.Position
	local Offsetted = OriginalPosition + UDim2.new(0, 0, 1, 0)

	local tween = TweenService:Create(
		Mainframe,
		TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
		{ Position = Offsetted }
	)

	tween:Play()

	tween.Completed:Wait()

	Catalogue.Enabled = false
end

function g.TriggerRUN(player: Player)
	local playerGui = player:FindFirstChild("PlayerGui")
	if playerGui == nil then
		warn("couldn't open catalogue for player because playergui doesnt exist in player")
		return
	end
	local catalogue = playerGui:FindFirstChild("Balltalogue")
	if catalogue == nil then
		warn("couldn't open catalogue for player because catalogue gui doesnt exist in playergui")
		return
	end

	if not catalogue:IsA("ScreenGui") then
		warn("couldn't open catalogue because player's catalogue is not a screengui")
		return
	end

	if not catalogue:FindFirstChild("MF") then
		warn("couldn't tween catalogue open because mainframe doesnt exist")
	end
	if not catalogue:FindFirstChild("MF"):IsA("Frame") then
		warn("couldn't tween catalogue open because mainframe isint a frame")
	end

	local Mainframe: Frame = catalogue:FindFirstChild("MF")

	catalogue.Enabled = true
	local OriginalPosition = Mainframe.Position
	local Offsetted = OriginalPosition + UDim2.new(0, 0, 1, 0)
	Mainframe.Position = Offsetted
	local tween = TweenService:Create(
		Mainframe,
		TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.In),
		{ Position = OriginalPosition }
	)
	tween:Play()
end

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
