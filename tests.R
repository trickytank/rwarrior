# Warrior AI tests

AI <- function(warrior, memory = NULL, level_state = NULL) {
  action <- "walk"
  list(action = action, memory = memory)
}

play_warrior(AI)
