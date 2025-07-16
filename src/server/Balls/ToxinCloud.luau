local TweenService = game:GetService("TweenService")
local t = {}

-- 			["action"] = "ToxinCloud",
--  ["radius"] = 3,
--  ["damage"] = 5, -- remember to add player to ignore list so that it doesnt get
-- -- hurt more than one time

function t.Action(part: Part, Action)
	if Action.action ~= "ToxinCloud" then
		error("Action type not supported: " .. tostring(Action.action))
	end
end
