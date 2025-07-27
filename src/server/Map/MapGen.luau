local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local TweenService = game:GetService("TweenService")

local MapUtil = require(script.Parent.MapUtil)
local BallStats = require(ServerScriptService.GameState.State.BallStats)

local F = {}
local r = Random.new()

F.tweens = {}
F.tweens.bounce = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)

F.gen = {}

function F.GenerateVConfig(XZSizeMinMax, YSizeMinMax, TiltMax, HeightOffsetMax, Options)
	local CF = {}
	CF.minSizeHorizontal = XZSizeMinMax[1]
	CF.maxSizeHorizontal = XZSizeMinMax[2]
	CF.minSizeVertical = YSizeMinMax[1]
	CF.maxSizeVertical = YSizeMinMax[2]
	CF.maxHeightOffset = HeightOffsetMax
	CF.maxTilt = TiltMax
	CF.DistChaotic = false

	if table.find(Options, "ChaoticGeneration") then
		CF.DistChaotic = true
	end
	return CF
end

F.gen.GrassV = F.GenerateVConfig({ 10, 15 }, { 20, 20 }, 5, 2, { "ChaoticGeneration" })

function F.GenerateGrassyLayer(Origin: Vector3, Area: number, Bricks: number, V)
	local minimum = Vector3.new(Origin.X - Area, Origin.Y, Origin.Z - Area)
	local maximum = Vector3.new(Origin.X + Area, Origin.Y, Origin.Z + Area)

	for _ = 1, Bricks do
		local spawnX = r:NextNumber(minimum.X, maximum.X)
		local spawnZ = r:NextNumber(minimum.Z, maximum.Z)
		local spawnY = Origin.Y + r:NextNumber(-V.maxHeightOffset, V.maxHeightOffset)
		local spawnV = Vector3.new(spawnX, spawnY, spawnZ)

		-- distance between spawnV and Origin
		if V.DistChaotic then
			local dist = spawnV - Origin
			V.maxTilt = dist.Magnitude * V.maxTilt * 0.03
		end
		local sizeX = r:NextNumber(V.minSizeHorizontal, V.maxSizeHorizontal)
		local sizeZ = r:NextNumber(V.minSizeHorizontal, V.maxSizeHorizontal)
		local sizeY = r:NextNumber(V.minSizeVertical, V.maxSizeVertical)
		local sizeV = Vector3.new(sizeX, sizeY, sizeZ)

		local orientV = Vector3.new(
			r:NextNumber(-V.maxTilt, V.maxTilt),
			r:NextNumber(-V.maxTilt, V.maxTilt),
			r:NextNumber(-V.maxTilt, V.maxTilt)
		)

		local brick = Instance.new("Part")
		brick.Parent = game.Workspace.MAP
		brick.Position = spawnV
		brick.Size = sizeV
		brick.Orientation = orientV
		task.wait()

		MapUtil.SetMatGrass(brick)
		MapUtil.TweenUpTrans(brick)
	end
end

function F.RoundStart()
	-- tween the green baseplate to match spawn area
	local Area = BallStats.wave.area + 100
	local Baseplate = game.Workspace.Baseplate
	local Tween = TweenService:Create(Baseplate, F.tweens.bounce, { Size = Vector3.new(Area, Baseplate.Size.Y, Area) })
	Tween:Play()

	-- remove past map
	local MapFolder: Folder = game.Workspace.MAP
	local desc = MapFolder:GetDescendants()
	for _, v in ipairs(desc) do
		v:Destroy()
	end

	-- generate grassLayer
	F.GenerateGrassyLayer(Baseplate.Position, Area, 300, F.gen.GrassV)
	-- generate +1 layer with medium
	-- generate pillars, boxes
end

return F
