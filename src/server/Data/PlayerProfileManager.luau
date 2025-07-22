local PPM = {}

-- services
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local TweenService = game:GetService("TweenService")

local PBTS = require(ServerScriptService.Enumeration.PBTS)
local ProfileService = require(ServerScriptService.ServerPackages.ProfileService)

-- profiletemplate
PPM.Template = {
	Money = 0,
	TopRoundsSurvived = 0,
}

local GameProfileStore = ProfileService.GetProfileStore(PBTS.ProfileStoreStrings.DataKey, PPM.Template)
local Profiles = {}

function PPM.HANGING_UpdateBalanceGui(player)
	local gui = player.PlayerGui:WaitForChild(PBTS.GuiNames.Balance).TextLabel

	local profile = Profiles[player]
	if profile and profile.Data then
		gui.Text = "$ " .. profile.Data.Money
	end
end

function PPM.TransactMoney(player, amount)
	local profile = Profiles[player]
	if profile and profile.Data then
		if (profile.Data.Money + amount) < 0 then
			return PBTS.MoneyTransactionResult.Declined
		end
		profile.Data.Money = profile.Data.Money + amount
		task.spawn(PPM.HANGING_UpdateBalanceGui, player)

		-- Transact Effect:
		local gui = player.PlayerGui:WaitForChild(PBTS.GuiNames.Balance).TextLabel
		if amount > 0 then
			gui.Color = Color3.fromRGB(18, 172, 57)
		elseif amount < 0 then
			gui.Color = Color3.fromRGB(209, 76, 76)
		end
		local TweenBackToWhite = TweenService:Create(
			gui,
			TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
			{ Color = Color3.fromRGB(255, 255, 255) }
		)
		TweenBackToWhite:Play()

		return PBTS.MoneyTransactionResult.Success
	else
		warn("Attempted to transact money for player without a loaded profile: " .. tostring(player))
		return PBTS.MoneyTransactionResult.Errored
	end
end

function PPM.GetBalance(player)
	local profile = Profiles[player]
	if profile and profile.Data then
		task.spawn(PPM.HANGING_UpdateBalanceGui, player)
		return profile.Data.Money
	else
		warn("Attempted to get balance for player without a loaded profile: " .. tostring(player))
		return 0 -- default balance if no profile
	end
end

local function playerAdded(player)
	local profile = GameProfileStore:LoadProfileAsync("player_" .. player.UserId)

	if profile ~= nil then
		profile:AddUserId(player.UserId)
		profile:Reconcile() -- fill in missing vals
		profile:ListenToRelease(function()
			Profiles[player] = nil
			player:Kick("Profile released")
		end)

		Profiles[player] = profile

		if player:IsDescendantOf(Players) then
			-- do whatever at this point when game starts
			print(player.Name .. " has " .. profile.Data.Money .. " money.")
		else
			profile:Release() -- player left before loading
		end
	else
		warn("Profile could not be loaded for " .. player.Name)
		player:Kick("Profile loaded by other servers simultaeneously..? Unknown error!")
	end

	PPM.TransactMoney(player, 1)
end

function PPM.Init()
	Players.PlayerAdded:Connect(playerAdded)

	Players.PlayerRemoving:Connect(function(player)
		local profile = Profiles[player]
		if profile ~= nil then
			profile:Release()
		end
	end)
end

-- Module functions.....

-- Get Profile
-- gets profile from Profiles list. secure
--[[
	@param player is the player to get
]]
function PPM.GetProfile(player)
	return Profiles[player]
end

-- Set Profile Data
-- sets profile data with checks. secure
--[[
	@param player is the player to set
	@data data is the data to set. same as template btw
]]
function PPM.SetProfileData(player, data)
	local profile = Profiles[player]
	if profile and profile.Data then
		for key, value in pairs(data) do
			profile.Data[key] = value
		end
	end
end

return PPM
