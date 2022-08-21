#' @import stringr
#' @import glue
warrior_turn <- function(w, game_state, warrior_name, sleep = 0, debug = FALSE) {
  if(is.null(w$action)) {
    stop("No warrior action was provided.")
  }
  at_stairs = FALSE
  map <- game_state$map
  x <- game_state$warrior$x
  y <- game_state$warrior$y
  points <- 0
  # Prepare for enemies to attack if they are close enough
  enemys_to_attack <- list()
  enemys_to_shoot <- list()
  for(enemy in game_state$npcs) {
    if(enemy$attack) {
      # Check if warrior is within attack range
      if(game_state$feel_symbol(enemy) == "@") {
        # Prepare to attack
        enemys_to_attack <- c(list(enemy), enemys_to_attack)
      }
    }
    if(enemy$shoot) {
      # Check if warrior is within shooting range
      if(game_state$feel_symbol(enemy) == "@") {
        # Prepare to shoot
        enemys_to_shoot <- c(list(enemy), enemys_to_shoot)
      }
    }
  }

  if(w$action %in% c("walk", "attack")) {
    coord <- give_coordinates(game_state$warrior$compass, w$direction, y, x)
    y_subject <- coord$y_subject
    x_subject <- coord$x_subject
    direc <- coord$direc
  }
  if(w$action == "walk") {
    if(is.null(game_state$return_object(y_subject, x_subject))) {
      cat(glue("{warrior_name} walks {direc}.\n\n"))
      game_state$warrior$y <- y_subject
      game_state$warrior$x <- x_subject
    } else {
      message(glue("{warrior_name} is blocked and doesn't move."))
    }
  } else if (w$action == "attack") {
    enemy <- game_state$return_object(y_subject, x_subject)
    if(is.null(enemy)) {
      message(warrior_name, " attacks forward and hits nothing.")
    } else {
      points <- points + game_state$attack_routine(game_state$warrior, enemy, direc, sleep = sleep, debug = debug)
    }
  } else if(w$action == "rest") {
    if(game_state$warrior$hp >= game_state$warrior$max_hp) {
      message(warrior_name, " is already fit as a fiddle.")
    } else if(game_state$warrior$hp == game_state$warrior$max_hp - 1L) {
      game_state$warrior$hp <- game_state$warrior$hp + 1L
      message(warrior_name, " receives 1 health from resting, up to ", game_state$warrior$hp, " health.")
    } else {
      game_state$warrior$hp <- game_state$warrior$hp + 2L
      message(warrior_name, " receives 2 health from resting, up to ", game_state$warrior$hp, " health.")
    }
  } else {
    stop("Invalid warrior action (this is a bug).")
  }

  message_sleep(sleep, debug)

  # Let enemies attack if they are close enough
  for(enemy in enemys_to_attack) {
    # Do the attacking
    game_state$attack_routine(enemy, game_state$warrior, "forward", sleep = sleep, debug = debug)
    message_sleep(sleep, debug)
  }
  for(enemy in enemys_to_shoot) {
    # Do the attacking
    game_state$attack_routine(enemy, game_state$warrior, "forward", attack_type = "shoots", sleep = sleep, debug = debug)
    message_sleep(sleep, debug)
  }

  list(points = points)
}
