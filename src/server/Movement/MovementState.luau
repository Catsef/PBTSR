local S = {}

S.States = {}
S.States.Jumping = "JUMPING"
S.States.Leaping = "LEAPING"
S.States.Diving = "DIVING"
S.States.Walking = "WALK"
S.States.Running = "RUN"
S.States.Dashing = "DASHING"
S.States.Standing = "NONE"
S.States.Dead = "IGNORE"

S.PlayerState = {} -- [player] = S.States.State

return S
