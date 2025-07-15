local ToxinCloud = {}
ToxinCloud.__index = ToxinCloud

local ServerScriptService = game:GetService("ServerScriptService")
local TweenService = game:GetService("TweenService")
local Damager = require(ServerScriptService.Util.BallActions.Utility.Damager)

function ToxinCloud.New(Position: Vector3, DamageRadius: number, DamageDealer: Damager.Damager, PresetPart: Part?)
	local self = setmetatable({}, ToxinCloud)

	if not PresetPart then
		self.Instance = Instance.new("Part")
		self.Instance.Shape = Enum.PartType.Ball

		self.Instance.Transparency = 0.5
		self.Instance.CanCollide = false
		self.Instance.Anchored = true
		self.Instance.Color = Color3.fromRGB(78, 17, 15)

		self.Instance.Position = Position
		self.Instance.Name = "ToxinCloud"
		self.Instance.Size = Vector3.new(0.1, 0.1, 0.1) -- Initial size, will be resized later
	else
		self.Instance = PresetPart
		self.Instance.Name = "ToxinCloud"
	end

	self.Damager = DamageDealer
	self.Damager.Hitbox = self.Instance

	self.Tweens = {
		start_Resize = TweenService:Create(
			self.Instance,
			TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
			{ Size = Vector3.new(DamageRadius * 2, DamageRadius * 2, DamageRadius * 2) }
		),
		end_fadeout = TweenService:Create(
			self.Instance,
			TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
			{ Transparency = 1, Size = Vector3.new(0.1, 0.1, 0.1) }
		),
	}

	self.Tweens.start_Resize:Play()

	return self
end

function ToxinCloud:Start()
	self.Damager:Start()
	while task.wait() do
		if self.Damager.Finished then
			break
		end
	end

	self.Tweens.end_fadeout:Play()
end

export type ToxinCloud = {
	Instance: Part,
	Damager: Damager.Damager,
	Tweens: {
		start_Resize: Tween,
		end_fadeout: Tween,
	},
	Start: (self: ToxinCloud) -> (),
}

return {
	New = ToxinCloud.New,
	ToxinCloud = ToxinCloud,
}
