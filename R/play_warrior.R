# Play the warrior game

#' Play R Warrior
#'
#' @param ai AI function to control your warrior
#' @param level Level number.
#' @param warrior_name Name of your warrior, for flavour.
#' @param sleep Time between text updates.
#' @return A logical that is TRUE on successfully getting to the stairs
#' @export
#' @examples
#' AI <- AI <- function(warrior, memory) {
#'   warrior$walk()
#' }
#' play_warrior(AI, level = 1)
play_warrior <- function(ai, level = 1, warrior_name = "Fisher", sleep = 0.5) {
  play_warrior_inbuilt_levels(ai = ai, level = level, warrior_name = warrior_name, sleep = sleep, debug = FALSE)
}

# For inbuilt levels
play_warrior_inbuilt_levels <- function(ai, level = 1, warrior_name = "Fisher", sleep = 0, debug = TRUE) {
  if(level > length(levels)) {
    if(level <= 18) {
      stop("Level ", level, " does not exist, though it is planned for the future.")
    }
    stop("Level ", level, " does not exist.")
  }
  game_state <- GAME_STATE$new(levels[[level]])
  play_warrior_work(ai, game_state, level = level, warrior_name = warrior_name, sleep = sleep, debug = debug)
}

# The work of the warrior, allowing for custom levels to be used.
# TODO: remove level, and store time bonus etc. in the GAME_STATE class
play_warrior_work <- function(ai, game_state, level = 1, warrior_name = "Fisher", sleep = 0, debug = TRUE) {
  game_state$warrior$name <- warrior_name
  at_stairs <- FALSE
  complete <- FALSE
  turn <- 1L
  alive <- TRUE
  level_score <- 0L
  memory <- NULL
  while(!complete) {
    message("-----------------------------------")
    cat("- Turn", turn, "-\n")
    cat(game_state$ascii)
    x <- game_state$x
    y <- game_state$y
    # clone here to prevent tampering the game_state. Doesn't prevent all cheating such as inspecting the entire game_state.
    w <- WARRIOR_ACTION$new(game_state$deep_clone())
    # w is also modified here
    memory <- ai(w, memory)
    result <- warrior_turn(w, game_state, warrior_name, sleep, debug = debug)
    points <- result$points

    level_score <- level_score + points

    if(game_state$warrior$hp <= 0) {
      message(warrior_name, " died.")
      return(invisible(FALSE))
    }

    if(game_state$at_stairs) {
      complete <- TRUE
      message("-----------------------------------")
      cat(game_state$ascii)
      message("Success, you have found the stairs.")
      time_bonus <- max(0, levels[[level]]$time_bonus - turn)
      clear_bonus <- level * 2
      total_score <- time_bonus + level_score + clear_bonus
      cat("Level Score:", level_score, "\n",
          "Time Bonus:", time_bonus, "\n",
          "Clear Bonus:", clear_bonus, "\n",
          "Total Score:", total_score, "\n")
      # 0 8 2 10
      if(level + 1 > length(levels)) {
        message("Congratulations, you have completed all the levels of R Warrior and reached the precious Hex.")
        if(level <= 18) {
          message(18 - level, " more levels are planned to be ported from Ruby Warrior.")
        }
      } else {
        message(paste0("See the readme for the next level of the tower with level_readme(", level + 1, ")"))
      }
      return(invisible(TRUE))
    }

    turn <- turn + 1L
    if(turn == 101) {
      message("Sorry, you have run out of time.")
      return(invisible(FALSE))
    }
  }
}

