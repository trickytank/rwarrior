#' @import stringr
#' @import glue
warrior_turn <- function(w, level_state, warrior_name, sleep = 0) {
  if(is.null(w$action)) {
    stop("No warrior action was provided.")
  }
  at_exit = FALSE
  map <- level_state$map
  x <- level_state$warrior$x
  y <- level_state$warrior$y
  points <- 0
  x_offset <- 0
  y_offset <- 0
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
      points <- points + level_state$attack_routine(level_state$warrior, enemy, direc, sleep)
      Sys.sleep(sleep)
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

  # Let enemies attack if they are close enough
  for(enemy in level_state$npcs) {
    if(enemy$attack) {
      # check if they are within range
      if(level_state$feel(enemy) == "@") {
        # Do the attacking
        level_state$attack_routine(enemy, level_state$warrior, "forward", sleep)
      }
    }
    if(enemy$shoot) {
      # Not implemented
    }
  }
  Sys.sleep(sleep)

  list(points = points)
}
