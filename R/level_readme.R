#' Level read me
#'
#' The starting point for R Warrior.
#' Run this before attempting each level with play_warrior().
#'
#' @param level The level number (or custom level).
#' @param tower The tower the level comes from.
#' @export
#' @examples
#'
#' level_readme(1)
level_readme <- function(level = 1, tower = c("beginner")) {
  tower <- match.arg(tower)
  if(tower == "beginner") {
    levels <- levels_beginner
  }
  if(checkmate::test_int(level)) {
    if(level > length(levels) || level < 1) {
      stop("Level ", level, " does not exist.")
    }
    cat("Level", level, "\n")
    game_state <- GAME_STATE$new(levels[[level]])
  } else if(inherits(level, "GAME_STATE")) {
    game_state <- level
  } else if(inherits(level, "list")) {
    game_state <- GAME_STATE$new(level)
  } else {
    stop("Incorrect level specification")
  }
  cat(game_state$level_description, "\n\n")
  cat("Tip:", game_state$level_tip, "\n\n")
  cat(game_state$ascii, "\n")
  map_icon_description(game_state)
  cat("\n")
  method_description(game_state$warrior)
  invisible(TRUE)
}

map_icon_description <- function(game_state) {
  cat_line("  ", game_state$stairs$symbol, " = Stairs")
  names_so_far <- c()
  for(object in c(list(game_state$warrior), game_state$npcs)) {
    if(object$name %in% names_so_far) next
    cat(glue("  {object$symbol} = {object$name} ({object$hp} HP)\n", .trim = FALSE))
    names_so_far <- c(names_so_far, object$name)
  }
}

method_description <- function(warrior) {
  if(TRUE) {
    cat("- warrior$walk(direction = \"forward\")\n")
    cat("  Move the warrior in the given direction, any of:\n")
    cat('    - "forward"\n')
    cat('    - "backward"\n')
  }
  cli_h3("Warrior actions (can only call one per turn):")
  if(warrior$attack) {
    cat_line('- warrior$attack(direction = "forward")')
    cat_line('  Attack the space in the given direction for ', WARRIOR$new()$attack_power, ' damage.')
  }
  if(warrior$shoot) {
    cat_line('- warrior$shoot(direction = "forward")')
    cat_line('  Shoot an arrow in the given direction for ', WARRIOR$new()$shoot_power, " damage.")
  }
  if(warrior$rest) {
    cat('- warrior$rest()\n')
    cat('  Rest and heal 10% of the your warrior\'s health.\n')
  }
  if(warrior$rescue) {
    cat_line('- warrior$rescue(direction = "forward")')
    cat_line('  Attempts to rescue the NPC in the given direction.')
  }
  if(warrior$pivot) {
    cat_line('- warrior$pivot(direction = "backward")')
    cat_line('  Pivot to another direction, relative to current direction.')
  }
  if(warrior$health || warrior$feel || warrior$look) {
    cli_h3("Information gathering commands (can be called multiple times in one turn):")
    if(warrior$health) {
      cat('- warrior$health\n')
      cat('  Returns the health of the warrior, up to 20HP.\n')
    }
    if(warrior$feel) {
      cat('- warrior$feel(direction = "forward")\n')
      cat('  Checks what is in front (or behind) the warrior.\n')
      cat('  Returns a SPACE object with fields as below:\n')
      cat('    - $empty returns TRUE if the space is empty or the stairs.\n')
      cat('    - $stairs returns TRUE if the space has the stairs.\n')
      cat('    - $enemy returns TRUE if the space has an enemy.\n')
      cat('    - $captive returns TRUE if the space has a captive.\n')
      cat('    - $wall returns TRUE if the space is a wall. You can\'t walk here.\n')
      cat('    - $ticking returns TRUE if the space is a bomb which will explode in time.\n')
      cat('    - $golem returns TRUE if a golem is occupying this space.\n')
    }
    if(warrior$look) {
      cat_line('- warrior$look(direction = "forward")')
      cat_line('  Return a list of 3 SPACE objects, the same as warrior$feel().')
      cat_line('  Access with warrior$look()[[i]] where i is an integer from 1 to 3.')
    }
  }
}
