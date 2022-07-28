# Warrior AI tests for level 1

AI <- function(warrior, memory = NULL) {
  action <- "walk"
  warrior$walk()
}

assert(play_warrior(AI, sleep = 0))
