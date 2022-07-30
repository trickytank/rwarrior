# level 1

levels <- list()
levels[[1]] <- list(
  description = "You see before yourself a long hallway with stairs at the end. There is nothing in the way.",
  map = matrix(c("@", " ", " ", " ", " ", " ", " ", ">"), nrow = 1, byrow = TRUE),
  tip = "Call warrior$walk() to walk forward in your AI.",
  time_bonus = 15,
  ace_score = 10
)
levels[[2]] <- matrix(c("@", " ", " ", "s", " ", " ", " ", ">"), nrow = 1, byrow = TRUE)
