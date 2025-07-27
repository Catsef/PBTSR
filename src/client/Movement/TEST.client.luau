local ContextActionService = game:GetService("ContextActionService")
local function testAction(name, state, input)
	print("Key pressed:", name, state.Name)
	return Enum.ContextActionResult.Sink
end

ContextActionService:BindAction("TestMovement", testAction, false, Enum.KeyCode.X)
