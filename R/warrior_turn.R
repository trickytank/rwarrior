#' @import stringr
#' @import glue
warrior_turn <- function(w, level_state, warrior_name, sleep = 0, debug = FALSE) {
  if(is.null(w$action)) {
    stop("No warrior action was provided.")
  }
  at_exit = FALSE
  map <- level_state$map
  x <- level_state$warrior$x
  y <- level_state$warrior$y
  points <- 0
  # Prepare for enemies to attack if they are close enough
  enemys_to_attack <- list()
  for(enemy in level_state$npcs) {
    if(enemy$attack) {
      # check if they are within range
      if(level_state$feel(enemy) == "@") {
        # Prepare to attack
        enemys_to_attack <- c(list(enemy), enemys_to_attack)
      }
    }
    if(enemy$shoot) {
      # Not implemented
    }
  }

  if(w$action %in% c("walk", "attack")) {
    coord <- give_coordinates(level_state$warrior$compass, w$direction, y, x)
    y_subject <- coord$y_subject
    x_subject <- coord$x_subject
    direc <- coord$direc
  }
  if(w$action == "walk") {
    if(is.null(level_state$return_object(y_subject, x_subject))) {
      cat(glue("{warrior_name} walks {direc}.\n\n"))
      level_state$warrior$y <- y_subject
      level_state$warrior$x <- x_subject
    } else {
      message(glue("{warrior_name is blocked and doesn't move."))
    }
  } else if (w$action == "attack") {
    enemy <- level_state$return_object(y_subject, x_subject)
    if(is.null(enemy)) {
      message(warrior_name, " attacks forward and hits nothing.")
    } else {
      points <- points + level_state$attack_routine(level_state$warrior, enemy, direc, sleep, debug = debug)
    }
  } else if(w$action == "rest") {
    if(level_state$warrior$hp >= level_state$warrior$max_hp) {
      message(warrior_name, " is already fit as a fiddle.")
    } else if(level_state$warrior$hp == level_state$warrior$max_hp - 1L) {
      level_state$warrior$hp <- level_state$warrior$hp + 1L
      message(warrior_name, " receives 1 health from resting, up to ", level_state$warrior$hp, " health.")
    } else {
      level_state$warrior$hp <- level_state$warrior$hp + 2L
      message(warrior_name, " receives 2 health from resting, up to ", level_state$warrior$hp, " health.")
    }
  } else {
    stop("Invalid warrior action (this is a bug).")
  }

  message_sleep(sleep, debug)

  # Let enemies attack if they are close enough
  for(enemy in enemys_to_attack) {
    # Do the attacking
    level_state$attack_routine(enemy, level_state$warrior, "forward", sleep, debug = debug)
    message_sleep(sleep, debug)
  }

  list(points = points)
}
