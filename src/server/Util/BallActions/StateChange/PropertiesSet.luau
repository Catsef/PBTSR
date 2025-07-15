local PropertiesSet = {}
PropertiesSet.__index = PropertiesSet

function PropertiesSet.New(Part: Part, Properties: { [string]: any })
	local self = setmetatable({}, PropertiesSet)

	self.Part = Part
	self.Properties = Properties

	return self
end
function PropertiesSet:Apply()
	for property, value in pairs(self.Properties) do
		if self.Part[property] ~= nil then
			self.Part[property] = value
		else
			warn("Property '" .. property .. "' does not exist on Part.")
		end
	end
end

export type PropertiesSet = {
	Part: Part,
	Properties: { [string]: any },

	New: (Part: Part, Properties: { [string]: any }) -> PropertiesSet,
	Apply: (self: PropertiesSet) -> (),
}

return {
	New = PropertiesSet.New,
	PropertiesSet = PropertiesSet,
}
