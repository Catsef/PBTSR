local GS = {}

GS.GameStarted = false
GS.DebugEnabled = true
GS.RoundCount = 0

GS.CurrentRoundInfo = {}
GS.CurrentRoundInfo.MoneyMultiplier = 0 -- increase by 0.2 per round
GS.CurrentRoundInfo.RoundDuration = 5 -- in waves
GS.CurrentRoundInfo.WaveDelay = 10 -- in seconds, - by 0.7* per round
GS.CurrentRoundInfo.BallsToSpawn = 3 -- + by 1.5* per round
GS.CurrentRoundInfo.BallPool = {
	"Doomling",
}
GS.CurrentRoundInfo.SpawnRange = 20

function GS.StepRoundInfo()
	if GS.RoundCount % 3 == 0 then
		GS.CurrentRoundInfo.RoundDuration += 1
	end
	if GS.RoundCount % 10 == 0 then
		GS.CurrentRoundInfo.BallsToSpawn *= 2
	end
	GS.CurrentRoundInfo.WaveDelay *= 0.7
	GS.CurrentRoundInfo.BallsToSpawn += 2
	GS.CurrentRoundInfo.SpawnRange += 1
end

GS.CurrentRoundBallStats = {
	doomling = {
		approachingwaves = 5,
		movementspeed = 5,
		delay = 1,
		health = 3,
		rangeoftoxin = 7,
		toxindamage = 5,
	},
}

function GS.StepStats()
	GS.CurrentRoundBallStats.doomling.health += 0.250
	GS.CurrentRoundBallStats.doomling.rangeoftoxin += 0.2
	GS.CurrentRoundBallStats.doomling.toxindamage *= 1.05
	GS.CurrentRoundBallStats.doomling.approachingwaves += 1
	GS.CurrentRoundBallStats.doomling.delay *= 0.95
	GS.CurrentRoundBallStats.doomling.movementspeed *= 1.05
end

GS.RoundStarted = false
GS.BuyWindow = false

function GS.UpdateGameState(GameStarted, RoundCount, RoundStarted, BuyWindow)
	GS.GameStarted = GameStarted
	GS.RoundCount = RoundCount
	GS.RoundStarted = RoundStarted
	GS.BuyWindow = BuyWindow
end

return GS
