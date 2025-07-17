local ActionHandler = {}

local DefaultTweenInfo = TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local ServerScriptService = game:GetService("ServerScriptService")
local TweenService = game:GetService("TweenService")

function ActionHandler.Actioner(part: BasePart, actions)
	for _, v in ipairs(actions) do
		local ActionFunction = require(script.Parent[v.action]).Action
		if ActionFunction then
			ActionFunction(part, v)
		else
			error("Action function not found for action: " .. v.action)
		end
	end
end

function ActionHandler.Doomling(doomling, actions)
	local FadeInDoomlingPart = TweenService:Create(doomling, DefaultTweenInfo, { Transparency = 0 })
	local FadeInDoomlingFace = TweenService:Create(doomling.Face, DefaultTweenInfo, { Transparency = 0 })
	FadeInDoomlingPart:Play()
	FadeInDoomlingFace:Play()

	FadeInDoomlingPart.Completed:Wait()

	FadeInDoomlingPart.Actioner(doomling, actions)

	local FadeOutDoomlingPart = TweenService:Create(doomling, DefaultTweenInfo, { Transparency = 1 })
	local FadeOutDoomlingFace = TweenService:Create(doomling.Face, DefaultTweenInfo, { Transparency = 1 })
	FadeOutDoomlingPart:Play()
	FadeOutDoomlingFace:Play()

	FadeOutDoomlingPart.Completed:Wait()
	doomling:Destroy()
end

function ActionHandler.Blessling(blessling, actions)
	local FadeInBlessling = TweenService:Create(blessling, DefaultTweenInfo, { Transparency = 0 })
	FadeInBlessling:Play()
	FadeInBlessling.Completed:Wait()
	ActionHandler.Actioner(blessling, actions)
	local FadeOutBlessling = TweenService:Create(blessling, DefaultTweenInfo, { Transparency = 1 })
	FadeOutBlessling:Play()
	FadeOutBlessling.Completed:Wait()
	blessling:Destroy()
end

return ActionHandler
