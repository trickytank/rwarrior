# Warrior AI tests for level 1

AI <- function(warrior, memory = NULL) {
  action <- "walk"
  # warrior.walk()
  warrior$walk()
  # warrior.walk(direction = "right", memory = memory) # this is how it should be called, as we need directions
  # warrior.walk(direction = "right")
}


play_warrior(AI)
