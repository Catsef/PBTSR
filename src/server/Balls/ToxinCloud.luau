local TweenService = game:GetService("TweenService")
local t = {}

function t.Create(rad: number, dmg: number, col: Color3?)
	local Action = {}
	Action.action = "ToxinCloud"
	Action.radius = rad
	Action.damage = dmg
	if col then
		Action.color = col
	end
	return Action
end

-- 	["action"] = "ToxinCloud",
--  ["radius"] = 3,
--  ["damage"] = 5, -- remember to add player to ignore list so that it doesnt get
-- -- hurt more than one time

function t.Action(part: Part, Action)
	if Action.action ~= "ToxinCloud" then
		error("Action type not supported: " .. tostring(Action.action))
	end

	if not (Action.radius and Action.damage) then
		error("Missing args.. either Action.radius or Action.damage")
	end

	local ToxinCloud = Instance.new("Part")
	ToxinCloud.Shape = Enum.PartType.Ball
	ToxinCloud.Position = part.Position -- add Action.to support
	ToxinCloud.Size = Vector3.one * Action.radius
	ToxinCloud.Color = Action.color or Color3.fromRGB(228, 25, 25)
	ToxinCloud.Transparency = 0.5
	ToxinCloud.Parent = game.Workspace.FX
	ToxinCloud.CanCollide = false
	ToxinCloud.Anchored = true

	local AlreadyHurtPlayers = {}
	for _, v in ipairs(game.Workspace:GetPartBoundsInRadius(ToxinCloud.Position, ToxinCloud.Size.Y / 2)) do
		local player = game.Players:GetPlayerFromCharacter(v.Parent)
		print("ToxinCloud touched part: " .. v.Name)
		if player and not AlreadyHurtPlayers[player] then
			AlreadyHurtPlayers[player] = true
			local humanoid: Humanoid = v.Parent:FindFirstChild("Humanoid")
			if humanoid then
				print("ToxinCloud hit player: " .. player.Name)
				humanoid.Health = humanoid.Health - Action.damage
			end
		end
	end

	local FADE = TweenService:Create(
		ToxinCloud,
		TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
		{ Transparency = 1 }
	)

	FADE:Play()
	local function done()
		FADE.Completed:Wait()
		ToxinCloud:Destroy()
	end

	task.spawn(done)
end
return t
