# Play the warrior game

#' Play R Warrior
#'
#' @param ai AI function to control your warrior
#' @param level Level number.
#' @param warrior_name Name of your warrior, for flavour.
#' @param sleep Time between text updates. Set to "prompt" to only progress when pressing the return key.
#' @return A logical that is TRUE on successfully getting to the stairs
#' @import cli
#' @export
#' @examples
#' AI <- AI <- function(warrior, memory) {
#'   warrior$walk()
#' }
#' play_warrior(AI, level = 1)
play_warrior <- function(ai, level = 1, warrior_name = "Fisher", sleep = getOption("Rwarrior.sleep", 0.6)) {
  play_warrior_inbuilt_levels(ai = ai, level = level, warrior_name = warrior_name, sleep = sleep, debug = FALSE, output = TRUE)
}

# For inbuilt levels
play_warrior_inbuilt_levels <- function(ai, level = 1, warrior_name = "Fisher",
                                        sleep = 0, debug = FALSE, output = FALSE,
                                        max_turns = 100L) {
  if(level > length(levels)) {
    if(level <= 18) {
      stop("Level ", level, " does not exist, though it is planned for the future.")
    }
    stop("Level ", level, " does not exist.")
  }
  game_state <- GAME_STATE$new(levels[[level]])
  play_warrior_work(ai, game_state, level = level, warrior_name = warrior_name,
                    sleep = sleep, debug = debug, output = output, max_turns = max_turns)
}

# The work of the warrior, allowing for custom levels to be used.
play_warrior_work <- function(ai, game_state, level = NULL, warrior_name = "Fisher",
                              sleep = 0, debug = TRUE, output = FALSE, max_turns = 100L) {
  game_state$warrior$name <- warrior_name
  at_stairs <- FALSE
  complete <- FALSE
  turn <- 1L
  alive <- TRUE
  level_score <- 0L
  memory <- NULL
  while(!complete) {
    if(output) cli_h1("Turn {turn}")
    if(output) cat(game_state$ascii)
    x <- game_state$x
    y <- game_state$y
    # clone here to prevent tampering the game_state. Doesn't prevent all cheating such as inspecting the entire game_state.
    w <- WARRIOR_ACTION$new(game_state$deep_clone())
    # w is also modified here
    memory <- ai(w, memory)
    result <- warrior_turn(w, game_state, warrior_name, sleep, debug = debug, output = output)
    points <- result$points

    level_score <- level_score + points

    if(game_state$warrior$hp <= 0) {
      if(output) cli_text("{warrior_name} died.")
      complete <- TRUE
      next
    }

    if(game_state$at_stairs) {
      complete <- TRUE
      if(output) {
        cli_h1("Found stairs")
        cat(game_state$ascii)
        cli_text("Success, you have found the stairs.")
        time_bonus <- max(0, game_state$level_time_bonus - turn)
        clear_bonus <- game_state$level_clear_bonus
        total_score <- time_bonus + level_score + clear_bonus
        cli_text("Level Score: {level_score}")
        cli_text("Time Bonus:  {time_bonus}") # TODO: preserve this whitespace
        cli_text("Clear Bonus: {clear_bonus}")
        cli_text("Level Score: {level_score}")
        cli_text("Total Score: {total_score}")
        # 0 8 2 10
        if(is.null(level)) {
          cli_text("Congratulations, you have completed this custom level.")
        } else {
          if(level + 1 > length(levels)) {
            cli_text("Congratulations, you have completed all the levels of R Warrior and reached the precious Hex.")
            if(level <= 18) {
              cli_text("{18 - level} more levels are planned to be ported from Ruby Warrior.")
            }
          } else {
            cli_text("See the readme for the next level of the tower with level_readme({level + 1})")
          }
        }
      }
      return(invisible(TRUE))
    }

    turn <- turn + 1L
    if(turn > max_turns) {
      if(output) cli_text("Sorry, you have run out of time.")
      complete <- TRUE
      next
    }
  }
  if(askYesNo("Would you like a clue for this level?")){
    cli_text(game_state$level_clue)
  }
  return(invisible(FALSE))
}

