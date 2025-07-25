local Players = game:GetService("Players")
local m = {}

local RATE = Instance.new("NumberValue")
RATE.Parent = Players
RATE.Name = "SpeedlineRate"

m.Rate = RATE

return m
