# level 1

levels <- list()

# Level 1
# ----------
# |@      >|
# ----------
levels[[1]] <- list(
  description = "You see before yourself a long hallway with stairs at the end. There is nothing in the way.",
  size = c(1,8),
  warrior = WARRIOR$new()$set_loc(1, 1),
  npcs = list(),
  stairs = c(1,8),
  tip = "Call warrior$walk() to walk forward in your AI.",
  time_bonus = 15,
  clear_bonus = 2,
  ace_score = 10
)

# ----------
# |@   s  >|
# ----------
levels[[2]] <- list(
  description = "It is too dark to see anything, but you smell sludge nearby.",
  size = c(1,8),
  warrior = WARRIOR$new(feel = TRUE, attack = TRUE)$set_loc(1, 1),
  npcs = list(
    sludge_here(1, 5)
  ),
  stairs = c(1,8),
  tip = "Use warrior$feel$empty to see if there is anything in front of you, and warrior$attack() to fight it.\nRemember, you can only do one actionper turn.",
  clue = "Add an if/else condition using warrior$feel$empty to decide whether to warrior$attack() or warrior$walk().",
  time_bonus = 20,
  clear_bonus = 4,
  ace_score = 26
)

# -----------
# |@ s ss s>|
# -----------
levels[[3]] <- list(
  description = "The air feels thicker than before. There must be a horde of sludge.",
  size = c(1,9),
  warrior = WARRIOR$new(feel = TRUE, attack = TRUE, health = TRUE, rest = TRUE)$set_loc(1L, 1L),
  npcs = list(
    sludge_here(1, 3),
    sludge_here(1, 5),
    sludge_here(1, 6),
    sludge_here(1, 8)
  ),
  stairs = c(1, 9),
  tip = "Be careful not to die! Use warrior.health to keep an eye on your health, and warrior.rest! to earn 10% of max health back.",
  clue = "When there is no enemy ahead of you call warrior$rest() until health is full before walking forward.",
  time_bonus = 35,
  clear_bonus = 6,
  ace_score = 71
)


# ---------
# |@ Sa S>|
# ---------
levels[[4]] <- list(
  description = "You can hear bow strings being stretched.",
  size = c(1,7),
  warrior = WARRIOR$new(feel = TRUE, attack = TRUE, health = TRUE, rest = TRUE)$set_loc(1L, 1L),
  npcs = list(
    thick_sludge_here(1, 3),
    archer_here(1, 4),
    thick_sludge_here(1, 6)
  ),
  stairs = c(1, 7),
  tip = "No new abilities this time, but you must be careful not to rest while taking damage. Save a list called memory with a memory$health item (and return memory in the AI fucntion) and compare it on each turn to see if you're taking damage.",
  clue = "Set memory$health to your current health at the end of the turn. If this is greater than your current health next turn then you know you're taking damage and shouldn't rest.",
  time_bonus = 45,
  clear_bonus = 8,
  ace_score = 90
)
