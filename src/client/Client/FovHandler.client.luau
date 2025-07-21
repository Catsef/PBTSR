game.Players.LocalPlayer.CharacterAdded:Connect(function(a0: Model)
	local cam: Camera = game.Workspace.CurrentCamera
	cam.FieldOfView = 105
end)
