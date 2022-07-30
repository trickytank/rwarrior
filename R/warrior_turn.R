#' @import stringr
warrior_turn <- function(w, health, level_state, warrior_name) {
  if(is.null(w$action)) {
    stop("No warrior action was provided.")
  }
  at_exit = FALSE
  map <- level_state$map
  x <- level_state$x
  y <- level_state$y

  if(w$action == "walk") {
    if(!is.na(pmatch(w$direction, "forward"))) {
      if(map[y, x + 1L] == " ") {
        map <- swap_positions(map, x, y, x+1, y)
        cat(warrior_name, "walks forward.")
      } else if (map[y, x + 1L] == ">") {
        map[y, x] <- " "
        map[y, x + 1L] <- "@"
        cat(warrior_name, "walks forward.")
        at_exit = TRUE
      } else {
        message(warrior_name, "is blocked and doesn't move.")
      }
      x <- x + 1L
    } else if (!is.na(pmatch(w$direction, "backward"))) {
      if(map[y, x - 1L] == " ") {
        map <- swap_positions(map, x, y, x-1, y)
        cat(warrior_name, "walks back.")
      } else if (map[y, x - 1L] == ">") {
        map[y, x] <- " "
        map[y, x - 1L] <- "@"
        cat(warrior_name, "walks back.")
        at_exit = TRUE
      } else {
        message(warrior_name, "is blocked and doesn't move.")
      }
      x <- x - 1L
    } else {
      stop("Invalid direction specified in walk()")
    }
  } else if (w$action == "fight") {
    if(!is.na(pmatch(w$direction, "forward"))) {
      direc <- "forward"
      offset <- 1L
    } else if (!is.na(pmatch(w$direction, "backward"))) {
      direc <- "backward"
      offset <- -1L
    } else {
      stop("Invalid direction specified in fight()")
    }
    if(map[y, x + offset] %in% names(enemy_types)) {
      enemy_short <- map[y, x + offset]
      enemy <- enemy_types[enemy_short]
      level_state$hp[y, x + 1L] <- level_state$hp[y, x + offset] - attack_power
      message(warrior_name, "attacks", direc, "and hits", paste0(enemy, "."))
      message(enemy, "takes", attack_power, "damage,", level_state$hp[y, x + offset], "health power left.")
      health <- health - enemy_power[enemy_short]
      message(enemy, "attacks", direc,"and hits", paste0(warrior_name, "."))
      message(warrior_name, "takes", enemy_power[enemy_short], "damage,", health, "health power left.")
    } else {
      message(warrior_name, "attacks forward and hits nothing.")
    }
  } else {
    stop("Invalid warrior action (this is a bug).")
  }
  level_state$map <- map
  list(at_exit = at_exit, health = health)
}

swap_positions <- function(M, x1, y1, x2, y2) {
  temp <- M[y1, x1]
  M[y1, x1] <- M[y2, x2]
  M[y2, x2] <- temp
  M
}

enemy_types <- c("s" = "Sludge", "S" = "Super Sludge")
enemy_power <- c("s" = 3, "S" = NA)
attack_power <- 5


