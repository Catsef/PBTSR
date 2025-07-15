local Model = game.ServerStorage.Model.Doomling
local BallFolder = game.Workspace.Balls

local Helper = require(game.ServerScriptService.Util.UtilityFunctions)

local t = game:GetService("TweenService")
local s = Enum.EasingStyle
local d = Enum.EasingDirection

local Doomling = {}
Doomling.__index = Doomling

local SupportedBallActions = {
	ToxinCloud = require(game.ServerScriptService.Util.BallActions.ToxinCloud),
}

-- Action Format
-- {
-- ["ActionName"]: {args... DamageDealer: DamageDealer}
-- }

function Doomling.New(Position: Vector3, FadeInTime: number, Action: {}, Repetition: number, Delay: number)
	local self = setmetatable({}, Doomling)

	self.Instance = Model:Clone()
	self.Instance.Parent = BallFolder
	self.Instance.Position = Position

	self.Actionings = {
		Action = Action,
		Repetition = Repetition,
		Delay = Delay,
	}

	self.Tweens = {
		start_FadeIn_Part = t:Create(self.Instance, TweenInfo.new(FadeInTime, s.Linear, d.InOut), { Transparency = 0 }),
		start_FadeIn_Decal = t:Create(
			self.Instance.Frown,
			TweenInfo.new(FadeInTime, s.Linear, d.InOut),
			{ Transparency = 0 }
		),
		end_FadeOut_Part = t:Create(self.Instance, TweenInfo.new(FadeInTime, s.Linear, d.InOut), { Transparency = 1 }),
		end_FadeOut_Decal = t:Create(
			self.Instance.Frown,
			TweenInfo.new(FadeInTime, s.Linear, d.InOut),
			{ Transparency = 1 }
		),
	}

	return self
end

function Doomling:Start()
	self.Tweens.start_FadeIn_Part:Play()
	self.Tweens.start_FadeIn_Decal:Play()

	self.Tweens.start_FadeIn_Part.Completed:Wait()

	for _ = 1, self.Actionings.Repetition do
		for ActionName, Arguments in pairs(self.Actionings.Action) do
			Helper.SwitchWithCaseTable(ActionName, {

				ToxinCloud = function()
					local tox = SupportedBallActions.ToxinCloud.New(
						self.Instance.Position,
						Arguments.DamageRadius,
						Arguments.DamageDealer
					)
					task.spawn(function()
						tox:Start()
					end)
				end,
				-- ...add more actions here
				default = function()
					error("Doomling:Start.. Action not recognized! referencing action:" .. ActionName)
				end,
			})
		end

		task.wait(self.Actionings.Delay)
	end

	self.Tweens.end_FadeOut_Part:Play()
	self.Tweens.end_FadeOut_Decal:Play()

	self.Tweens.end_FadeOut_Part.Completed:Wait()

	self.Instance:Destroy()
end

export type Doomling = {
	Instance: Part,
	Actionings: {
		Action: {},
		Repetition: number,
		Delay: number,
	},
	Tweens: {
		start_FadeIn_Part: Tween,
		start_FadeIn_Decal: Tween,
		end_FadeOut_Part: Tween,
		end_FadeOut_Decal: Tween,
	},
	Start: (self: Doomling) -> (),
}

return {
	New = Doomling.New,
	Doomling = Doomling,
}
