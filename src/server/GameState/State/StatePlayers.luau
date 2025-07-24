local p = {}

p.AllPlayers = {} -- [player]
p.DeadPlayers = {} -- [player]

p.Readied = {}
p.Readied.Round = {} -- [player]
p.Readied.Game = {} -- [player]

p.Connections = {}
p.Connections.Death = {} -- [player] = [connection]

p.Spectate = {}
p.Spectate.Targets = {} -- [spectator player] = [who is it spectating]

return p
