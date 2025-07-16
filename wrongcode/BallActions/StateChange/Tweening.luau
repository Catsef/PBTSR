local Tweening = {}
Tweening.__index = Tweening

local t = game:GetService("TweenService")

function Tweening.new(Part: Part, TweenInfo: TweenInfo, Result: { [string]: any }?)
	local self = setmetatable({}, Tweening)

	self.Part = Part
	self.Result = Result or {}
	self.TweenInfo = TweenInfo

	self.Tween = t:Create(self.Part, self.TweenInfo, self.Result)

	return self
end

function Tweening:Play()
	self.Tween:Play()
	self.Tween.Completed:Wait()
end

function Tweening:Stop()
	self.Tween:Cancel()
end

export type Tweening = {
	Part: Part,
	Result: { [string]: any }?,
	TweenInfo: TweenInfo,
	Tween: Tween,

	new: (Part: Part, TweenInfo: TweenInfo, Result: { [string]: any }?) -> Tweening,
	Play: (self: Tweening) -> (),
	Stop: (self: Tweening) -> (),
}

return {
	New = Tweening.new,
	Tweening = Tweening,
}
