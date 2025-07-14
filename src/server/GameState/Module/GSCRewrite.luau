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

function GameState.Round.StepStats() end

return GameState
