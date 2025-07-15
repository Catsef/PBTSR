local GameState = {}

GameState.GameStarted = false
GameState.DebugEnabled = true
GameState.RoundCount = 0

GameState.AllBallsDefault = {
	Doomling = {
		ApproachingWaves = 5,
		MovementSpeed = 5,
		Delay = 1,
		Health = 3,
		RangeOfToxin = 7,
		ToxinDamage = 2,
	},
}

GameState.AllBallsMaxed = {
	Doomling = {
		ApproachingWaves = 10,
		MovementSpeed = 10,
		Delay = 0.5,
		Health = 10,
		RangeOfToxin = 15,
		ToxinDamage = 4,
	},
}

GameState.Round = {}
GameState.Round.RoundDuration = 3
GameState.Round.WaveDelay = 10 -- in seconds, - by 0.7* per round
GameState.Round.BallsToSpawn = 3 -- + by 1.5* per
GameState.Round.BallPool = {
	{
		Name = "Doomling",
		Weight = 1, -- weight for random spawn
		Stats = GameState.AllBallsDefault.Doomling:Clone(),
		SpawnRange = 20,
	},
}

GameState.AllBallsStep = {
	Doomling = function()
		GameState.Round.BallPool[1].Stats.ApproachingWaves += (1 / 3)
		GameState.Round.BallPool[1].Stats.MovementSpeed += 0.5
		GameState.Round.BallPool[1].Stats.Delay -= 0.1
		GameState.Round.BallPool[1].Stats.Health += 0.2
		GameState.Round.BallPool[1].Stats.RangeOfToxin += 0.5
		GameState.Round.BallPool[1].Stats.ToxinDamage += 0.2
	end,
}

function GameState.Round.StepStats()
	GameState.Round.SpawnRange += 3
	if GameState.RoundCount % 3 == 0 then
		GameState.Round.RoundDuration += 1
		GameState.Round.WaveDelay *= 0.7
		GameState.Round.BallsToSpawn += 1
	end
	if GameState.RoundCount % 10 == 0 then
		GameState.Round.BallsToSpawn *= 2
	end
	for name, func in pairs(GameState.AllBallsStep) do
		func()
	end
end

return GameState
