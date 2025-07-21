local e = {}

e.GuiNames = {}
e.GuiNames.Balance = "Money"

e.BallActions = {}
e.BallActions.EffectCloud = "EffectCloud"

e.BallActions.Grapple = {}
e.BallActions.Grapple.Name = "Grapple"
e.BallActions.Grapple.Options = {}
e.BallActions.Grapple.Options.NearestPlayer = "NEAREST_PLAYER"
e.BallActions.Grapple.Options.MultiplePlayers = "MULTIPLE_PLAYERS"
e.BallActions.Grapple.Options.NearestUnanchored = "NEAREST_UNANCHORED_PART"
e.BallActions.Grapple.Options.MultipleUnanchored = "MULTIPLE_UNANCHORED_PARTS"

e.BallActions.ToxinCloud = "ToxinCloud"

e.BallActions.TweenMove = {}
e.BallActions.TweenMove.Name = "TweenMove"
e.BallActions.TweenMove.Options = {}
e.BallActions.TweenMove.Options.NearestPlayer = "NEAREST_PLAYER"
e.BallActions.TweenMove.Options.PositionOffset = "POSITION_OFFSET"
e.BallActions.TweenMove.Options.PositionAbsolute = "POSITION_ABSOLUTE"

e.Effects = {}
e.Effects.SLOW = "Slow"

e.BallActions.PhysicsPull = "PhysicsPull"

e.MoneyTransactionResult = {}
e.MoneyTransactionResult.Success = 0
e.MoneyTransactionResult.Errored = 1
e.MoneyTransactionResult.Declined = 2

e.ProfileStoreStrings = {}
e.ProfileStoreStrings.DataKey = "PlayerData_PA.3_"

return e
