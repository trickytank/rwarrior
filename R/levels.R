# level 1

levels <- list()
levels[[1]] <- list(
  description = "You see before yourself a long hallway with stairs at the end. There is nothing in the way.",
  map = matrix(c("@", " ", " ", " ", " ", " ", " ", ">"), nrow = 1, byrow = TRUE),
  tip = "Call warrior$walk() to walk forward in your AI.",
  time_bonus = 15,
  ace_score = 10,
  methods = c("walk")
)

levels[[2]] <- list(
  description = "It is too dark to see anything, but you smell sludge nearby.",
  matrix(c("@", " ", " ", " ", "s", " ", " ", ">"), nrow = 1, byrow = TRUE),
  tip = "Use warrior$feel$empty to see if there is anything in front of you, and warrior$attack() to fight it.\nRemember, you can only do one actionper turn.",
  time_bonus = 20,
  ace_score = 26,
  methods = c("walk", "attack", "feel$empty")
)
