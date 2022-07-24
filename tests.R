# Warrior AI tests

AI <- function(warrior, memory = NULL, level_state = NULL) {
  action <- "walk"
  # warrior.walk()
  list(action = action, memory = memory)
  # warrior.walk(direction = "right", memory = memory) # this is how it should be called, as we need directions
  # warrior.walk(direction = "right")
}


play_warrior(AI)
