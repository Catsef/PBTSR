local ServerStorage = game:GetService("ServerStorage")

local m = {}
m.ProximityPromptConnections = {}

local ButtonEvent: BindableEvent = ServerStorage.Bindings.GUI.ButtonSend

function m.InitGuiForPlayer(player, guiRef, includingButtons)
	local gui
	if not player:WaitForChild("PlayerGui"):FindFirstChild(guiRef.Name) then
		gui = guiRef:Clone()
		gui.Parent = player:WaitForChild("PlayerGui")
	else
		gui = player.PlayerGui:FindFirstChild(guiRef.Name)
	end

	if not includingButtons then
		return
	end

	for _, descendant in ipairs(gui:GetDescendants()) do
		if descendant:IsA("TextButton") then
			local SEND = descendant:GetAttribute("sendid")
			if SEND == nil then
				error("TextButton missing sendid attribute")
			end
			descendant.MouseButton1Click:Connect(function()
				ButtonEvent:Fire(SEND, player)
			end)
		end
	end
end

function m.InitProximityPrompts(trigger, connectionName, runFunction)
	if m.ProximityPromptConnections[connectionName] then
		return -- already existing connection
	end

	m.ProximityPromptConnections[connectionName] = trigger.Triggered:Connect(function()
		print("proximity prompt connection fired: " .. connectionName)
		runFunction()
	end)
end
return m
