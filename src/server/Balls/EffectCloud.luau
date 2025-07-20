local ServerScriptService = game:GetService("ServerScriptService")
local TweenService = game:GetService("TweenService")
local PBTS = require(ServerScriptService.Enumeration.PBTS)
local UtilityFunctions = require(ServerScriptService.Util.UtilityFunctions)
local t = {}

function t.Create(rad: number, effect, effectModule, col: Color3?)
	local Action = {}
	Action.action = PBTS.BallActions.EffectCloud
	Action.radius = rad
	Action.effect = effect
	Action.effectModule = effectModule
	if col then
		Action.color = col
	end
	return Action
end

function t.Action(part: Part, Action)
	if Action.action ~= PBTS.BallActions.EffectCloud then
		error("Action type not supported: " .. Action.action)
	end

	local EffectCloud = Instance.new("Part")
	EffectCloud.Shape = Enum.PartType.Ball
	EffectCloud.Position = part.Position
	EffectCloud.Size = Vector3.one * Action.radius
	EffectCloud.Material = Enum.Material.Neon
	EffectCloud.Color = Action.color or Color3.fromRGB(255, 255, 255)
	EffectCloud.Transparency = 0.5
	EffectCloud.Parent = game.Workspace.FX
	EffectCloud.CanCollide = false
	EffectCloud.Anchored = true

	local AlreadyAffectedPlayers = {}

	for _, v in ipairs(game.Workspace:GetPartBoundsInRadius(EffectCloud.Position, EffectCloud.Size.Y / 2)) do
		local player = game.Players:GetPlayerFromCharacter(v.Parent)
		if player and not AlreadyAffectedPlayers[player] then
			AlreadyAffectedPlayers[player] = true
			Action.effectModule.Start(player, Action.effect)
		end
	end

	local FADE = TweenService:Create(
		EffectCloud,
		TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
		{ Transparency = 1 }
	)

	FADE:Play()

	local function done()
		FADE.Completed:Wait()
		EffectCloud:Destroy()
	end

	task.spawn(done)
end

return t
