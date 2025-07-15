local Damager = {}
Damager.__index = Damager

function Damager.New(
	Hitbox: Part,
	Damage: number,
	DamageRepetitions: number,
	DelayPerDamage: number,
	SingleTarget: boolean
)
	local self = setmetatable({}, Damager)
	self.Hitbox = Hitbox
	self.Damage = Damage
	self.DamageRepetitions = DamageRepetitions
	self.Delay = DelayPerDamage
	self.ToBreak = false
	self.SingleTarget = SingleTarget or false
	self.Finished = false
	return self
end

function Damager:Break()
	self.ToBreak = true
end

function Damager:Start()
	local Hitbox: Part = self.Hitbox

	if not Hitbox then
		error(
			"Check Damager:Start - Hitbox is not set... was it destroyed or is it supposed to be initialized somewhere else?"
		)
	end

	for _ = 1, self.DamageRepetitions do
		local HitParts = Hitbox:GetTouchingParts()
		for _, part in ipairs(HitParts) do
			if part.Parent and part.Parent:FindFirstChild("Humanoid") then
				local humanoid = part.Parent.Humanoid
				humanoid:TakeDamage(self.Damage)
				if self.SingleTarget then
					break
				end
			end
		end
		task.wait(self.Delay)
		if self.ToBreak then
			break
		end
	end
	self.Finished = true
end

export type Damager = {
	Hitbox: Part,
	Damage: number,
	DamageRepetitions: number,
	Delay: number,
	ToBreak: boolean,
	SingleTarget: boolean,
	Finished: boolean,
	Break: (self: Damager) -> (),
	Start: (self: Damager) -> (),
}

return {
	New = Damager.New,
	Damager = Damager,
}
