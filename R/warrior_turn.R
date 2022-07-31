#' @import stringr
warrior_turn <- function(w, health, level_state, warrior_name, sleep = 0) {
  if(is.null(w$action)) {
    stop("No warrior action was provided.")
  }
  at_exit = FALSE
  map <- level_state$map
  x <- level_state$x
  y <- level_state$y
  points <- 0
  if(w$action %in% c("walk", "attack")) {
    if(!is.na(pmatch(w$direction, "forward"))) {
      direc <- "forward"
      offset <- 1L
    } else if (!is.na(pmatch(w$direction, "backward"))) {
      direc <- "backward"
      offset <- -1L
    } else {
      stop("Invalid direction specified.")
    }
  }
  if(w$action == "walk") {
    if(map[y, x + offset] == " ") {
      map <- swap_positions(map, x, y, x + offset, y)
      cat(warrior_name, "walks", paste0(direc, "."))
    } else if (map[y, x + offset] == ">") {
      map[y, x] <- " "
      map[y, x + offset] <- "@"
      cat(warrior_name, "walks", paste0(direc, "."))
      at_exit = TRUE
    } else {
      message(warrior_name, "is blocked and doesn't move.")
    }
    x <- x + offset

  } else if (w$action == "attack") {
    if(map[y, x + offset] %in% names(enemy_types)) {
      enemy_short <- map[y, x + offset]
      enemy <- enemy_types[enemy_short]
      level_state$hp[y, x + offset] <- level_state$hp[y, x + offset] - attack_power
      message(warrior_name, " attacks ", direc, " and hits ", enemy, ".")
      Sys.sleep(sleep)
      message(enemy, " takes ", attack_power, " damage, ", level_state$hp[y, x + offset], " health power left.")
      Sys.sleep(sleep)
      if(level_state$hp[y, x + offset] <= 0) {
        map[y, x + offset] <- " "
        level_state$hp[y, x + offset] <- NA
        message(enemy, " dies.")
        Sys.sleep(sleep)
        message(warrior_name, " earns ", enemy_points[enemy_short], " points.")
        points <- points + enemy_points[enemy_short]
      }
    } else {
      message(warrior_name, " attacks forward and hits nothing.")
    }
  } else if(w$action == "rest") {
    if(health >= 20) {
      message(warrior_name, " is already fit as a fiddle.")
    } else if(health == 19) {
      health <- health + 1
      message(warrior_name, " receives 1 health from resting, up to ", health, " health.")
    } else {
      health <- health + 2
      message(warrior_name, " receives 2 health from resting, up to ", health, " health.")
    }
  } else {
    stop("Invalid warrior action (this is a bug).")
  }

  # Check if an enemy is close by
  for(enemy_short in level_state$closeby_enemies) {
    # TODO: This might happen regardless of whether an attack occurred, so move outside.
    # check by doing a rest at the enemy
    health <- health - enemy_power[enemy_short]
    message(enemy_types[enemy_short], " attacks forward and hits ", warrior_name, ".")
    Sys.sleep(sleep)
    message(warrior_name, " takes ", enemy_power[enemy_short], " damage, ", health, " health power left.")
  }
  level_state$map <- map
  list(at_exit = at_exit, health = health, points = points)
}

swap_positions <- function(M, x1, y1, x2, y2) {
  temp <- M[y1, x1]
  M[y1, x1] <- M[y2, x2]
  M[y2, x2] <- temp
  M
}

enemy_types <- c("s" = "Sludge", "S" = "Super Sludge")
enemy_power <- c("s" = 3, "S" = NA)
enemy_points <- c("s" = 12, "S" = NA)
attack_power <- 5


