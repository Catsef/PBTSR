local Damager = {}
Damager.__index = Damager

function Damager.New(Damage: number, DamageReps: number, Delay: number, SingleTarget: boolean)
	local self = setmetatable({}, Damager)
	self.Damage = Damage
	self.DamageReps = DamageReps
	self.Delay = Delay
	self.ToBreak = false
	self.SingleTarget = SingleTarget or false
	self.Finished = false
	return self
end

function Damager:StartWithHitbox(Hitbox: Part)
	if not Hitbox then
		error(
			"Damager:StartWithHitbox - Hitbox is not set... was it destroyed or is it supposed to be initialized somewhere else?"
		)
	end

	self.Hitbox = Hitbox

	for _ = 1, self.DamageReps do
		local HitParts = self.Hitbox:GetTouchingParts()
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
