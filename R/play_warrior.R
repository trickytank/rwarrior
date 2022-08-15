# Play the warrior game

#' Play R Warrior
#'
#' @param ai AI function to control your warrior
#' @param y Level number.
#' @return A logical that is TRUE on successfully getting to the exit
#' @export
#' @examples
#' AI <- AI <- function(warrior, level_state) {
#'   warrior <- warrior.walk()
#'   warrior
#' }
#' play_warrior(AI, level = 1)
play_warrior <- function(ai, level = 1, sleep = 0.5, warrior_name = "Fisher") {
  level_state <- Level_state$new(levels[[level]])
  level_state$warrior$name <- warrior_name
  at_exit <- FALSE
  complete <- FALSE
  turn <- 1L
  alive <- TRUE
  level_score <- 0L
  memory <- NULL
  while(!complete) {
    message("-----------------------------------")
    cat("- Turn", turn, "-\n")
    cat(level_state$ascii)
    x <- level_state$x
    y <- level_state$y
    # clone here to prevent tampering the level_state. Doesn't prevent all cheating such as inspecting the entire level_state.
    w <- Warrior_action$new(level_state$clone())
    # w is also modified here
    memory <- ai(w, memory)
    result <- warrior_turn(w, level_state, warrior_name, sleep)
    points <- result$points

    level_score <- level_score + points

    message_level_state(level_state)

    if(level_state$warrior$hp <= 0) {
      message(warrior_name, " died.")
      return(invisible(FALSE))
    }

    if(level_state$at_exit) {
      complete <- TRUE
      message("-----------------------------------")
      cat(level_state$ascii)
      message("Success, you have found the stairs.")
      time_bonus <- max(0, levels[[level]]$time_bonus - turn)
      clear_bonus <- level * 2
      total_score <- time_bonus + level_score + clear_bonus
      cat("Level Score:", level_score, "\n",
          "Time Bonus:", time_bonus, "\n",
          "Clear Bonus:", clear_bonus, "\n",
          "Total Score:", total_score, "\n")
      # 0 8 2 10
      message(paste0("See the readme for the next level of the tower with level_readme(", level + 1, ")"))
      return(invisible(TRUE))
    }

    turn <- turn + 1L
    if(turn == 101) {
      message("Sorry, you have run out of time.")
      return(invisible(FALSE))
    }

    Sys.sleep(sleep)
  }
  return(invisible(NULL))
}

