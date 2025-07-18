local WeightedChoice = {}
WeightedChoice.__index = WeightedChoice

function WeightedChoice.New(ExistingChoices)
	local self = setmetatable({}, WeightedChoice)
	self.Choices = ExistingChoices or {}
	self.Random = Random.new()
	return self
end

function WeightedChoice:AddChoice(weight, value)
	table.insert(self.Choices, { weight = weight, value = value })
end

function WeightedChoice:UseRandomObject(random: Random)
	-- option available for seed
	self.Random = random or Random.new()
end

function WeightedChoice:Choose()
	local totalWeight = 0
	for _, choice in ipairs(self.Choices) do
		totalWeight += choice.weight
	end

	local randomValue = self.Random:NextNumber(0, totalWeight)
	local cumulativeWeight = 0

	for _, choice in ipairs(self.Choices) do
		cumulativeWeight += choice.weight
		if randomValue < cumulativeWeight then
			return choice.value
		end
	end

	error("Error in WeightedChoice:Choose - no choice made, check weights...")
	return nil -- In case no choice is made, though this should not happen with valid weights.
end

export type WeightedChoice = {
	Choices: { weight: number, value: any }?,
	Random: Random,
	New: (ExistingChoices: { weight: number, value: any }?) -> WeightedChoice,
	AddChoice: (self: WeightedChoice, weight: number, value: any) -> (),
	UseRandomObject: (self: WeightedChoice, random: Random) -> (),
	Choose: (self: WeightedChoice) -> any,
}

return {
	New = WeightedChoice.New,
	WeightedChoice = WeightedChoice,
}
