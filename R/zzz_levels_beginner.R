# level 1

levels_beginner <- list()

# Level 1
# ----------
# |@      >|
# ----------
levels_beginner[[1]] <- list(
  description = "You see before yourself a long hallway with stairs at the end. There is nothing in the way.",
  size = c(1,8),
  warrior = WARRIOR$new()$set_loc(1, 1),
  npcs = list(),
  stairs = c(1,8),
  tip = "Call warrior$walk() to walk forward in your AI.",
  clue = "Just follow the level tip.",
  time_bonus = 15,
  clear_bonus = 2,
  ace_score = 10
)

# ----------
# |@   s  >|
# ----------
levels_beginner[[2]] <- list(
  description = "It is too dark to see anything, but you smell sludge nearby.",
  size = c(1,8),
  warrior = WARRIOR$new(feel = TRUE, attack = TRUE)$set_loc(1, 1),
  npcs = list(
    sludge_here(1, 5)
  ),
  stairs = c(1,8),
  tip = "Use warrior$feel$empty to see if there is anything in front of you, and warrior$attack() to fight it.\nRemember, you can only do one action per turn.",
  clue = "Add an if/else condition using warrior$feel$empty to decide whether to warrior$attack() or warrior$walk().",
  time_bonus = 20,
  clear_bonus = 4,
  ace_score = 26
)

# -----------
# |@ s ss s>|
# -----------
levels_beginner[[3]] <- list(
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
  clue = "When there is no enemy ahead of you, call warrior$rest() until health is full before walking forward.",
  time_bonus = 35,
  clear_bonus = 6,
  ace_score = 71
)


# ---------
# |@ Sa S>|
# ---------
levels_beginner[[4]] <- list(
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


# ---------
# |@ CaaSC|
# ---------
levels_beginner[[5]] <- list(
  description = "You hear cries for help. Captives must need rescuing.",
  size = c(1,7),
  warrior = WARRIOR$new(feel = TRUE, attack = TRUE, health = TRUE, rest = TRUE, rescue = TRUE)$set_loc(1L, 1L),
  npcs = list(
    captive_here(1,3),
    archer_here(1, 4),
    archer_here(1, 5),
    thick_sludge_here(1, 6),
    captive_here(1,7)
  ),
  stairs = c(1, 7),
  tip = "Use warrior$feel()$captive to see if there is a captive and warrior$rescue() to rescue him. Don't attack captives.",
  clue = "Don't forget to constantly check if you're taking damage. Rest until your health is full if you aren't taking damage.",
  time_bonus = 45,
  clear_bonus = 10,
  ace_score = 123
)


# ----------
# |C @ S aa|
# ----------
levels_beginner[[6]] <- list(
  description = "The wall behind you feels a bit further away in this room. And you hear more cries for help.",
  size = c(1,8),
  warrior = WARRIOR$new(feel = TRUE, attack = TRUE, health = TRUE, rest = TRUE, rescue = TRUE)$set_loc(1L, 3L),
  npcs = list(
    captive_here(1,1),
    thick_sludge_here(1, 5),
    archer_here(1, 7),
    archer_here(1, 8)
  ),
  stairs = c(1, 8),
  tip = "You can walk backward by passing \"backward\" as an argument to warrior$walk(). For example, warrior$walk(\"backward\"). Same goes for feel(), rescue() and attack(). Archers have a limited attack distance.",
  clue = "Walk backward if you are taking damage from afar and do not have enough health to attack. You may also want to consider walking backward until warrior$feel(\"backward\")$wall.",
  time_bonus = 55,
  clear_bonus = 12,
  ace_score = 105
)


# --------
# |>a S @|
# --------
levels_beginner[[7]] <- list(
  description = "You feel a wall right in front of you and an opening behind you.",
  size = c(1,6),
  warrior = WARRIOR$new(feel = TRUE, attack = TRUE, health = TRUE, rest = TRUE, rescue = TRUE, pivot = TRUE)$set_loc(1L, 6L),
  npcs = list(
    thick_sludge_here(1, 4, compass = "east"),
    archer_here(1, 2, compass = "east")
  ),
  stairs = c(1, 1),
  tip = "You are not as effective at attacking backward. Use warrior$feel()$wall and warrior$pivot() to turn around.",
  clue = "After callig warrior$pivot(), you have turned around and warrior$walk() sends you west.",
  time_bonus = 30,
  clear_bonus = 14,
  ace_score = 50
)


# ---------
# |@  Cww>|
# ---------
levels_beginner[[8]] <- list(
  description = "You hear the mumbling of wizards. Beware of their deadly wands! Good thing you found a bow.",
  size = c(1,7),
  warrior = WARRIOR$new(feel = TRUE, attack = TRUE, health = TRUE, rest = TRUE, rescue = TRUE,
                        pivot = TRUE, look = TRUE, shoot = TRUE)$set_loc(1L, 1L),
  npcs = list(
    captive_here(1, 4),
    wizard_here(1, 5),
    wizard_here(1, 6)
  ),
  stairs = c(1, 7),
  tip = "Use warrior$look() to determine your surroundings, and warrior$shoot() to fire an arrow.",
  clue = "Wizards are deadly but low in health. Kill them before they have time to attack.",
  time_bonus = 20,
  clear_bonus = 16,
  ace_score = 46
)


# -------------
# |>Ca  @ S wC|
# -------------
levels_beginner[[9]] <- list(
  description = "Time to hone your skills and apply all of the abilities that you have learned.",
  size = c(1,11),
  warrior = WARRIOR$new(feel = TRUE, attack = TRUE, health = TRUE, rest = TRUE, rescue = TRUE,
                        pivot = TRUE, look = TRUE, shoot = TRUE)$set_loc(1L, 6L),
  npcs = list(
    captive_here(1, 2, compass = "east"),
    archer_here(1, 3, compass = "east"),
    thick_sludge_here(1, 8),
    wizard_here(1, 10),
    captive_here(1, 11)
  ),
  stairs = c(1, 1),
  tip = "Watch your back.",
  clue = "Don't just keep shooting the bow while you are being attacked from behind.",
  time_bonus = 40,
  clear_bonus = 18,
  ace_score = 100
)
