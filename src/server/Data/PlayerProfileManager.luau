local PPM = {}

-- services
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ProfileService = require(ServerScriptService.ServerPackages.ProfileService)

-- profiletemplate
PPM.Template = {
	Money = 0,
	TopRoundsSurvived = 0,
}

local GameProfileStore = ProfileService.GetProfileStore("PlayerData_PA.3_", PPM.Template)
local Profiles = {}

local function playerAdded(player)
	local profile = GameProfileStore:LoadProfileAsync("player_" .. player.UserId)

	if profile ~= nil then
		profile:AddUserId(player.UserId)
		profile:Reconcile() -- fill in missing vals
		profile:ListenToRelease(function()
			Profiles[player] = nil
			player:Kick("Profile released")
		end)

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
end

Players.PlayerAdded:Connect(playerAdded)

Players.PlayerRemoving:Connect(function(player)
	local profile = Profiles[player]
	if profile ~= nil then
		profile:Release()
	end
end)

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
	else
		warn("Attempted to set profile data for player without a loaded profile: " .. tostring(player))
	end
end

return PPM
