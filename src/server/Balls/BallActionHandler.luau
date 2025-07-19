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

--[[
	Default - a function that runs the default action for a ball. It fades in the ball, runs the actions, and then fades it out.
	@param p - the part that will be actioned upon.
	@param actions - Actions list. Is unordered, and will be run in order from top to bottom.
	@param hasFace - whether the part has a face to fade in/out.
	@param tweenInfo - TweenInfo for the fade in/out.
	@param hasClickDetector - whether the part has a ClickDetector to handle mouse clicks.
	@param lives - number of lives for the part, if applicable.
	@param livesMinSize - minimum size of the part when lives reach 0.
]]
function ActionHandler.Default(
	p,
	actions,
	hasFace: boolean,
	tweenInfo: TweenInfo,
	hasClickDetector: boolean,
	lives: number?,
	livesMinSize: number?
)
	if hasClickDetector and p.ClickDetector then
		local CDT: ClickDetector = p.ClickDetector
		local currentLives = lives
		-- lives: 5 to 0
		-- size: currentSize to 2
		-- lives -> size:  ( currentLives / lives ) * (currentSize - 2) + 2
		-- lives: any to 0
		-- size: any to 2
		-- lives -> size: (currentLives / lives) * (p.Size.X - minSize) + minSize
		CDT.MouseClick:Connect(function(a0: Player)
			currentLives -= 1
			if currentLives <= 0 then
				p:Destroy()
			else
				local newSize = ((currentLives / lives) * (p.Size.Y - livesMinSize) + livesMinSize) * Vector3.one
				p.Size = newSize
			end
		end)
	end

	local pA = TweenService:Create(p, tweenInfo, { Transparency = 0 })
	pA:Play()
	if hasFace and p.Face then
		local pB = TweenService:Create(p.Face, tweenInfo, { Transparency = 0 })
		pB:Play()
	end
	pA.Completed:Wait()

	ActionHandler.Actioner(p, actions)

	local dA = TweenService:Create(p, tweenInfo, { Transparency = 1 })
	dA:Play()
	if hasFace and p.Face then
		local dB = TweenService:Create(p.Face, tweenInfo, { Transparency = 1 })
		dB:Play()
	end
	dA.Completed:Wait()
	p:Destroy()
end

----- CUSTOM BALL FUNCTIONS -----

--[[
	Doomling - a function for code for a specific ball. Every ball that is referenced inside GameState's ball lists should have a function here. Also, every function for a specific ball should run Actioner as well. (for it to work properly)
]]
function ActionHandler.Doomling(doomling, actions)
	ActionHandler.Default(doomling, actions, true, DefaultTweenInfo, true, 1, 2)
end

function ActionHandler.Blessling(blessling, actions)
	ActionHandler.Default(blessling, actions, false, DefaultTweenInfo, false)
end

function ActionHandler.Grappler(grappler, actions)
	ActionHandler.Default(grappler, actions, true, DefaultTweenInfo, false)
end

function ActionHandler.Shivering(shivering, actions)
	ActionHandler.Default(shivering, actions, true, DefaultTweenInfo, false)
end

return ActionHandler
