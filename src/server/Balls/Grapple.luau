local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local _TweenService = game:GetService("TweenService")
local PBTS = require(ServerScriptService.Enumeration.PBTS)
local UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)
local r = Random.new()
local t = {}

local GrappleEventToClient: RemoteEvent = ReplicatedStorage.Events.InsecureGrapple

--[[
	the Create function should be a function in every action defined within Balls and used in GameState.
	@param target - string which can be "NEAREST_PLAYER", "MULTIPLE_PLAYERS", "NEAREST_UNANCHORED_PART" or "MULTIPLE_UNANCHORED_PARTS" according to usage.
	@param force - number which will be the grapple force.
	@param rad - the radius of which the force will be applied.
	@param maximumPartsOrPlayers - an optional, but required for targets: "MULTIPLE_PLAYERS" and "MULTIPLE_UNANCHORED_PARTS", the maximum parts/players to impulse upon.
]]
function t.Create(target: string, force: number, rad: number, maximumPartsOrPlayers: number?)
	local Action = {}
	Action.action = PBTS.BallActions.Grapple.Name
	Action.target = target
	Action.force = force
	Action.radius = rad
	Action.maxP = maximumPartsOrPlayers
	return Action
end

--[[
	Creates a Beam between two parts and tweens its transparency to 1, then cleans up.
	@param parta (Instance) - The first part to attach the beam.
	@param partb (Instance) - The second part to attach the beam.
]]
local function TweenBeam(parta, partb)
	local AttA = Instance.new("Attachment")
	AttA.Parent = parta

	local AttB = Instance.new("Attachment")
	AttB.Parent = partb

	local Beam = Instance.new("Beam")
	Beam.Parent = game.Workspace.FX

	Beam.Attachment0 = AttA
	Beam.Attachment1 = AttB

	local NsTransparency = 0.5

	for i = 1, 100 do
		Beam.Transparency = NumberSequence.new(NsTransparency + (i * 0.005))
		task.wait(0.01)
	end

	Beam:Destroy()
	AttA:Destroy()
	AttB:Destroy()
end

--[[
	The action function is what runs from BallActionHandler.
	if target is nearest player, gets the nearest player and creates beam and applies impulse via remote event
	if target is multiple players does the same thing with a shuffled list of multiple players
	not implemented parts yet
]]
function t.Action(part: Part, Action)
	if Action.action ~= PBTS.BallActions.Grapple.Name then
		error("Action type not supported: " .. Action.action)
	end

	UtilityFunctions.SwitchWithCaseTable(Action.target, {
		[PBTS.BallActions.Grapple.Options.NearestPlayer] = function()
			local maxDist = Action.rad or 10000
			local nearestDist, nearestPlayer
			for _, v in pairs(Players:GetPlayers()) do
				local char = v.Character
				local dist = v:DistanceFromCharacter(part.Position)
				if not char or dist > maxDist or (nearestDist and dist >= nearestDist) then
					continue
				end
				nearestDist = dist
				nearestPlayer = v
			end

			if not nearestPlayer then
				return
			end

			GrappleEventToClient:FireClient(nearestPlayer, part.Position, Action.force)
			if not (nearestPlayer and nearestPlayer.Character and nearestPlayer.Character.HumanoidRootPart) then
				return
			end
			task.spawn(TweenBeam, part, nearestPlayer.Character.HumanoidRootPart)
		end,
		[PBTS.BallActions.Grapple.Options.MultiplePlayers] = function()
			local AllPlayers = Players:GetPlayers()
			local ShuffledPlayers = r:Shuffle(table.clone(AllPlayers))
			local PooledPlayers = {}
			for _, player in ipairs(ShuffledPlayers) do
				if #PooledPlayers <= Action.maxP then
					table.insert(PooledPlayers, player)
					GrappleEventToClient:FireClient(player, part.Position, Action.force)
					if not (player and player.Character and player.Character.HumanoidRootPart) then
						continue
					end
					task.spawn(TweenBeam, part, player.Character.HumanoidRootPart)
				else
					continue
				end
			end
		end,
		[PBTS.BallActions.Grapple.Options.NearestUnanchored] = function()
			-- TODO: implement later
		end,
		[PBTS.BallActions.Grapple.Options.MultipleUnanchored] = function()
			-- TODO: implement later
		end,
		default = function()
			error("Unrecognized target - Grapple.Action")
		end,
	})
end

return t
