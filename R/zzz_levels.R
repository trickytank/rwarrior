# level 1

levels <- list()

# Level 1
# "@      >"
levels[[1]] <- list(
  description = "You see before yourself a long hallway with stairs at the end. There is nothing in the way.",
  size = c(1,8),
  warrior = WARRIOR$new()$set_loc(1, 1),
  npcs = list(),
  stairs = c(1,8),
  tip = "Call warrior$walk() to walk forward in your AI.",
  time_bonus = 15,
  ace_score = 10
)

# "@   s  >"
levels[[2]] <- list(
  description = "It is too dark to see anything, but you smell sludge nearby.",
  size = c(1,8),
  warrior = WARRIOR$new(feel = TRUE, attack = TRUE)$set_loc(1, 1),
  npcs = list(
    sludge$clone()$set_loc(1, 5)
  ),
  stairs = c(1,8),
  tip = "Use warrior$feel$empty to see if there is anything in front of you, and warrior$attack() to fight it.\nRemember, you can only do one actionper turn.",
  time_bonus = 20,
  ace_score = 26
)

# "@ s ss s>"
levels[[3]] <- list(
  description = "The air feels thicker than before. There must be a horde of sludge.",
  size = c(1,9),
  warrior = WARRIOR$new(feel = TRUE, attack = TRUE, health = TRUE, rest = TRUE)$set_loc(1L, 1L),
  npcs = list(
    sludge$clone()$set_loc(1, 3),
    sludge$clone()$set_loc(1, 5),
    sludge$clone()$set_loc(1, 6),
    sludge$clone()$set_loc(1, 8)
  ),
  stairs = c(1, 9),
  tip = "Be careful not to die! Use warrior.health to keep an eye on your health, and warrior.rest! to earn 10% of max health back.",
  time_bonus = 35,
  ace_score = 71
)
