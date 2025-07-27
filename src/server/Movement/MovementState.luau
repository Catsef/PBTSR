local S = {}

S.States = {}
S.States.Jumping = "JUMPING" -- walking jump [STATE]
S.States.Leaping = "LEAPING" -- running jump [STATE] [ANIMATION]
S.States.Diving = "DIVING" -- jumping/leaping + [SPACE] [ANIMATION]
S.States.Walking = "WALK" -- press W for 0 to 0.49 seconds [STATE]
S.States.Running = "RUN" -- pressing W after 0.5 seconds [STATE]
S.States.Dashing = "DASHING" -- leaping/diving [Q] [ANIMATION]
S.States.Sliding = "SLIDING" -- walk/run [Q] [LIMIT_MOVEMENT] [ANIMATION]
S.States.Sneaking = "TAUNT" -- none [Q] [NO_MOVEMENT]
S.States.Standing = "NONE" -- not pressing any button
S.States.Dead = "IGNORE" -- humanoid/character dead [STATE]

S.PlayerState = {} -- [player] = S.States.State

return S
