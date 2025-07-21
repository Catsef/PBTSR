game.Players.LocalPlayer.CharacterAdded:Connect(function(_char: Model)
	local cam: Camera = game.Workspace.CurrentCamera
	cam.FieldOfView = 105
end)
