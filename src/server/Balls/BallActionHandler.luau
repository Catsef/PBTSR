local ActionHandler = {}

local DefaultTweenInfo = TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local TouchInputService = game:GetService("TouchInputService")
local TweenService = game:GetService("TweenService")
local PlayerProfileManager = require(ServerScriptService.Data.PlayerProfileManager)

--[[
	Actioner - a function that runs actions within the parent folder (balls) according to the actions list.
	@param part - the part that will be actioned upon. Actions shouldn't be specific about what type it affects.
	@param actions - Actions list. Is unordered, and will be run in order from top to bottom. Every action must be valid, and can be created from one of the action module scripts in the parent folder.
]]
function ActionHandler.Actioner(part: BasePart, actions)
	for _, v in ipairs(actions) do
		if not part or not part.Parent then
			return
		end
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
	p: BasePart,
	actions,
	hasFace: boolean,
	tweenInfo: TweenInfo,
	hasClickDetector: boolean,
	lives: number?,
	price: number?,
	livesMinSize: number?
)
	if hasClickDetector and p:FindFirstChild("ClickDetector") then
		local CDT = p:FindFirstChild("ClickDetector")
		if not (CDT and CDT:IsA("ClickDetector")) then
			error("ClickDetector isin't a ClickDetector???")
		end

		if not livesMinSize then
			error("livesMinSize required!")
		end

		local currentLives = lives
		p:SetAttribute("lives", currentLives)

		local function TickCheck()
			while task.wait() do
				if not p.Parent then
					return
				end
				if not p:GetAttribute("playerLastClickedBy") then
					continue
				end
				local playerLastClickedBy = Players:GetPlayerByUserId(p:GetAttribute("playerLastClickedBy"))
				if currentLives <= 0 then
					PlayerProfileManager.TransactMoney(playerLastClickedBy, price)
					PlayerProfileManager.HANGING_UpdateBalanceGui(playerLastClickedBy)
					p:Destroy()
					return
				end
			end
		end

		CDT.MouseClick:Connect(function(player: Player)
			currentLives -= 1
			p:SetAttribute("lives", currentLives)
			p:SetAttribute("playerLastClickedBy", player.UserId)

			local scale = ((currentLives / lives) * (p.Size.Y - livesMinSize) + livesMinSize) / p.Size.Y
			local newSize = p.Size * scale
			p.Size = newSize
		end)

		p:GetAttributeChangedSignal("lives"):Connect(function()
			currentLives = p:GetAttribute("lives")

			local scale = ((currentLives / lives) * (p.Size.Y - livesMinSize) + livesMinSize) / p.Size.Y
			local newSize = p.Size * scale
			p.Size = newSize
		end)

		task.spawn(TickCheck)
	end

	local pA = TweenService:Create(p, tweenInfo, { Transparency = 0 })
	pA:Play()
	if hasFace and p:FindFirstChild("Face") then
		local face = p:FindFirstChild("Face")
		if not face:IsA("Decal") then
			return
		end

		local pB = TweenService:Create(face, tweenInfo, { Transparency = 0 })
		pB:Play()
	end
	pA.Completed:Wait()

	ActionHandler.Actioner(p, actions)

	local dA = TweenService:Create(p, tweenInfo, { Transparency = 1 })
	dA:Play()
	if hasFace and p:FindFirstChild("Face") then
		local face = p:FindFirstChild("Face")
		if not face:IsA("Decal") then
			return
		end
		local dB = TweenService:Create(face, tweenInfo, { Transparency = 1 })
		dB:Play()
	end
	dA.Completed:Wait()
	p:Destroy()
end

function ActionHandler.Boss(p: BasePart, actions, hasFace: boolean, TI: TweenInfo, lives, price, livesMinSize)
	if p:FindFirstChild("ClickDetector") then
		local CDT = p:FindFirstChild("ClickDetector")
		if CDT == nil or (not CDT:IsA("ClickDetector")) then
			warn("click detector is nil or click detector isin't a click detector")
			return
		end
		local currentLives = lives
		p:SetAttribute("lives", currentLives)
		local function TickCheck()
			while task.wait() do
				if not p.Parent then
					return
				end
				if not p:GetAttribute("playerLastClickedBy") then
					continue
				end
				local playerLastClickedBy = Players:GetPlayerByUserId(p:GetAttribute("playerLastClickedBy"))
				if currentLives <= 0 then
					PlayerProfileManager.TransactMoney(playerLastClickedBy, price)
					PlayerProfileManager.HANGING_UpdateBalanceGui(playerLastClickedBy)
					p:Destroy()
					return
				end
			end
		end
		CDT.MouseClick:Connect(function(player: Player)
			currentLives -= 1
			p:SetAttribute("lives", currentLives)
			p:SetAttribute("playerLastClickedBy", player.UserId)

			local scale = ((currentLives / lives) * (p.Size.Y - livesMinSize) + livesMinSize) / p.Size.Y
			local newSize = p.Size * scale
			p.Size = newSize
		end)
		p:GetAttributeChangedSignal("lives"):Connect(function()
			currentLives = p:GetAttribute("lives")

			local scale = ((currentLives / lives) * (p.Size.Y - livesMinSize) + livesMinSize) / p.Size.Y
			local newSize = p.Size * scale
			p.Size = newSize
		end)

		task.spawn(TickCheck)
	else
		error("Missing click detector for boss ball!")
	end

	local pA = TweenService:Create(p, TI, { Transparency = 0 })
	pA:Play()
	if hasFace and p:FindFirstChild("Face") then
		local face = p:FindFirstChild("Face")
		if not face:IsA("Decal") then
			return
		end

		local pB = TweenService:Create(face, TI, { Transparency = 0 })
		pB:Play()
	end
	pA.Completed:Wait()

	-- actioning
	while task.wait() do
		local L = p:GetAttribute("lives")
		if L > 0 then
			ActionHandler.Actioner(p, actions)
		else
			break
		end
	end

	local dA = TweenService:Create(p, TI, { Transparency = 1 })
	dA:Play()
	if hasFace and p:FindFirstChild("Face") then
		local face = p:FindFirstChild("Face")
		if not face:IsA("Decal") then
			return
		end
		local dB = TweenService:Create(face, TI, { Transparency = 1 })
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
	ActionHandler.Default(doomling, actions, true, DefaultTweenInfo, true, 1, 2, 2)
end

function ActionHandler.Blessling(blessling, actions)
	ActionHandler.Default(blessling, actions, false, DefaultTweenInfo, false)
end

function ActionHandler.Grappler(grappler, actions)
	ActionHandler.Default(grappler, actions, true, DefaultTweenInfo, true, 3, 5, 2)
end

function ActionHandler.Shivering(shivering, actions)
	ActionHandler.Default(shivering, actions, true, DefaultTweenInfo, true, 5, 7, 2)
end

function ActionHandler.Bouncy(bouncy, actions)
	ActionHandler.Default(bouncy, actions, true, DefaultTweenInfo, false)
end

function ActionHandler.Master(boss, actions)
	ActionHandler.Boss(boss, actions, true, DefaultTweenInfo, 20, 100, 10)
end

return ActionHandler
