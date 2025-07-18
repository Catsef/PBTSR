local ActionHandler = {}

local DefaultTweenInfo = TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local TweenService = game:GetService("TweenService")

--[[
	Actioner - a function that runs actions within the parent folder (balls) according to the actions list.
	@param part - the part that will be actioned upon. Actions shouldn't be specific about what type it affects.
	@param actions - Actions list. Is unordered, and will be run in order from top to bottom. Every action must be valid, and can be created from one of the action module scripts in the parent folder.
]]
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

----- CUSTOM BALL FUNCTIONS -----

--[[
	Doomling - a function for code for a specific ball. Every ball that is referenced inside GameState's ball lists should have a function here. Also, every function for a specific ball should run Actioner as well. (for it to work properly)
]]
function ActionHandler.Doomling(doomling, actions)
	local FadeInDoomlingPart = TweenService:Create(doomling, DefaultTweenInfo, { Transparency = 0 })
	local FadeInDoomlingFace = TweenService:Create(doomling.Face, DefaultTweenInfo, { Transparency = 0 })
	FadeInDoomlingPart:Play()
	FadeInDoomlingFace:Play()

	FadeInDoomlingPart.Completed:Wait()

	ActionHandler.Actioner(doomling, actions)

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

function ActionHandler.Grappler(grappler, actions)
	local FadeInGrappler = TweenService:Create(grappler, DefaultTweenInfo, { Transparency = 0 })
	local FadeInFace = TweenService:Create(grappler.Face, DefaultTweenInfo, { Transparency = 0 })
	local FadeOutGrappler = TweenService:Create(grappler, DefaultTweenInfo, { Transparency = 1 })
	local FadeOutFace = TweenService:Create(grappler.Face, DefaultTweenInfo, { Transparency = 1 })

	FadeInGrappler:Play()
	FadeInFace:Play()
	FadeInGrappler.Completed:Wait()
	ActionHandler.Actioner(grappler, actions)
	FadeOutGrappler:Play()
	FadeOutFace:Play()
	FadeOutGrappler.Completed:Wait()
	grappler:Destroy()
end

return ActionHandler
