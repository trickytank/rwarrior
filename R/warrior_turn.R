#' @import stringr
#' @import glue
warrior_turn <- function(w, game_state, warrior_name, sleep = 0, debug = FALSE, output = FALSE) {
  if(is.null(w$action)) {
    return("No Warrior action was called in the AI function.")
  }
  J <- game_state$warrior$J
  I <- game_state$warrior$I
  points <- 0
  # Prepare for enemies to attack if they are close enough
  enemys_to_attack <- list()
  enemys_to_shoot <- list()
  for(enemy in game_state$npcs) {
    if(enemy$attack) {
      # Check if warrior is within attack range
      if(game_state$feel_object(enemy)$player) {
        # Prepare to attack
        enemys_to_attack <- c(list(enemy), enemys_to_attack)
      }
    }
    if(enemy$shoot) {
      # Check if warrior is within shooting range
      if(game_state$look_first_object(enemy)$player) {
        # Prepare to shoot
        enemys_to_shoot <- c(list(enemy), enemys_to_shoot)
      }
    }
  }

  if(w$action %in% c("walk", "attack", "rescue", "shoot")) {
    coord <- give_coordinates(game_state$warrior$compass, w$direction, I, J)
    I_subject <- coord$I_subject
    J_subject <- coord$J_subject
    direc <- coord$direc
    target <- game_state$return_object(I_subject, J_subject)
  }
  if(w$action %in% c("shoot")) {
    target <- game_state$look_first_object(game_state$warrior, w$direction)
  }
  if(w$action == "walk") {
    if(target$empty) {
      if(output) cli_text(warrior_name, style_bold(" walks "), direc)
      game_state$warrior$I <- I_subject
      game_state$warrior$J <- J_subject
    } else {
      if(output) cli_alert_warning("{warrior_name} is blocked and doesn't move.")
    }
  } else if (w$action %in% c("attack", "shoot")) {
    if(target$empty) {
      if(output) cli_alert_warning(paste(warrior_name, style_bold("{w$action}s"), "{direc} and hits nothing."))
    } else if (target$name == "Wall") {
      if(output) cli_alert_warning(paste(warrior_name, style_bold("{w$action}s"), "{direc} and hits the wall."))
    } else {
      points <- points + game_state$attack_routine(game_state$warrior, target, direc,
                attack_type = glue("{w$action}s"), sleep = sleep, debug = debug, output = output)
    }
  } else if(w$action == "rest") {
    if(game_state$warrior$hp >= game_state$warrior$max_hp) {
      if(output) cli_text("{warrior_name} is already fit as a fiddle.")
    } else if(game_state$warrior$hp == game_state$warrior$max_hp - 1L) {
      game_state$warrior$hp <- game_state$warrior$hp + 1L
      if(output) cli_text("{warrior_name} receives 1 health from ", style_bold("resting"), ", up to {game_state$warrior$hp} health.")
    } else {
      game_state$warrior$hp <- game_state$warrior$hp + 2L
      if(output) cli_text("{warrior_name} receives 2 health from ", style_bold("resting"), ", up to {game_state$warrior$hp} health.")
    }
  } else if (w$action == "rescue") {
    if(target$empty) {
      if(output) cli_alert_warning(paste(warrior_name, style_bold("rescues"), "{direc} into empty space."))
    } else if (target$enemy || target$name == "Wall") {
      if(output) cli_alert_warning(paste(warrior_name, "attempts to", style_bold("rescue"), "{direc} on {target$name} but is not bound."))
    } else if (target$rescuable) {
      if(output) cli_text("{warrior_name} unbinds {direc} and ", style_bold("rescues"), " {target$name}.")
      if(output) cli_text("{warrior_name} gains {target$points} points.")
      points <- points + target$points
      game_state$remove_npc(target)
    }
  } else if (w$action == "pivot") {
    game_state$warrior$pivot_self(w$direction, warrior_name = warrior_name, output = output)
  } else {
    return(paste0("Invalid warrior action: ", w$action, "."))
  }

  message_sleep(sleep, debug)

  # Let enemies attack if they are close enough
  for(enemy in enemys_to_attack) {
    if(enemy$death_flag) { next }
    # Do the attacking
    game_state$attack_routine(enemy, game_state$warrior, "forward", sleep = sleep, debug = debug, output = output)
    message_sleep(sleep, debug)
  }
  for(enemy in enemys_to_shoot) {
    if(enemy$death_flag) { next }
    # check the warrior is still within range
    if(game_state$look_first_object(enemy)$player) {
      # Do the shooting
      game_state$attack_routine(enemy, game_state$warrior, "forward", attack_type = "shoots", sleep = sleep, debug = debug, output = output)
      message_sleep(sleep, debug)
    }
  }

  list(points = points)
}
