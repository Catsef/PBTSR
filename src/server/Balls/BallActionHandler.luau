local a = {}

local DTI = TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local t = game:GetService("TweenService")

function a.Actioner(part: BasePart, actions)
	for _, v in ipairs(actions) do
		local ActionFunction = require(script.Parent[v.action]).Action
		if ActionFunction then
			ActionFunction(part, v)
		else
			error("Action function not found for action: " .. v.action)
		end
	end
end

function a.Doomling(doomling, actions)
	local _tt = t:Create(doomling, DTI, { Transparency = 0 })
	local _dt = t:Create(doomling.Face, DTI, { Transparency = 0 })
	_tt:Play()
	_dt:Play()

	_tt.Completed:Wait()

	a.Actioner(doomling, actions)

	_tt = t:Create(doomling, DTI, { Transparency = 1 })
	_dt = t:Create(doomling.Face, DTI, { Transparency = 1 })
	_tt:Play()
	_dt:Play()

	_tt.Completed:Wait()
	doomling:Destroy()
end

return a
