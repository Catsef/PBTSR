local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ClientPredictor = require(script.Parent.ClientPredictor)
-- local RunService = game:GetService("RunService")
local Player: Player = game.Players.LocalPlayer

-- local RenderSteppedConnection = nil

local RemoteEvents = {}
RemoteEvents.MovementKey = ReplicatedStorage.Movement.MovementKey

function CharacterAdded(Character: Model)
	local Humanoid = Character:WaitForChild("Humanoid")
	if not (Humanoid and Humanoid:IsA("Humanoid")) then
		error("Humanoid from Character is not a Humanoid!")
	end
	local _Root = Character:WaitForChild("HumanoidRootPart")

	-- if RenderSteppedConnection then
	-- 	RenderSteppedConnection:Disconnect()
	-- end

	-- RenderSteppedConnection = RunService.RenderStepped:Connect(function(a0: number)
	-- 	if not Humanoid then
	-- 		warn("no Humanoid in RenderSteppedConnection in KeyListener in Movement, client")
	-- 		return
	-- 	end

	-- 	local MoveDirection: Vector3 = Humanoid.MoveDirection

	-- 	-- first get the seperate movement vector, horizontal and vertical
	-- 	local Horizontal = Vector3.new(MoveDirection.X, 0, MoveDirection.Z)
	-- 	local Vertical = Vector3.new(0, MoveDirection.Y, 0)
	-- 	-- but these vectors can be overriden by server code. so lets not do anything with these yet
	-- end)

	-- Humanoid.Died:Connect(function(...: any)
	-- 	RenderSteppedConnection:Disconnect()
	-- 	RenderSteppedConnection = nil
	-- end)
end

Player.CharacterAdded:Connect(CharacterAdded)

function MovementKey(Name: string, State: Enum.UserInputState, Object: InputObject): Enum.ContextActionResult
	RemoteEvents.MovementKey:FireServer(State, Object.KeyCode, Object.UserInputType) -- handle all of movement on server side. the only thing client can control is the orientation and animations
	ClientPredictor.ClientPredictorKeyListen(State, Object.KeyCode, Object.UserInputType)
	return Enum.ContextActionResult.Sink
end

ContextActionService:BindActionAtPriority(
	"MovementKeys",
	MovementKey,
	false,
	5,
	Enum.KeyCode.W,
	Enum.KeyCode.A,
	Enum.KeyCode.S,
	Enum.KeyCode.D
)
