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
  level_state <- Level_state$new(levels[[level]]$map)
  at_exit <- FALSE
  complete <- FALSE
  turn <- 1L
  alive <- TRUE
  health = 20L
  while(!complete) {
    message("-----------------------------------")
    cat("- Turn", turn, "-\n")
    cat(level_state$ascii)
    map <- level_state$map
    x <- level_state$x
    y <- level_state$y
    feel_left <- level_state$map[y, x-1]
    feel_right <- level_state$map[y, x+1]
    # TODO: feel_up, feel_down
    w <- Warrior_action$new(health, feel_left, feel_right)
    ai(w)
    at_exit <- warrior_turn(w, health, level_state, warrior_name)



    message_level_state(level_state)
    if(health <= 0) {
      message("Your warrior died.")
      return(invisible(FALSE))
    }

    if(at_exit) {
      complete <- TRUE
      message("Success, you have found the stairs.")
      cat("Level Score: NA\n",
          "Time Bonus:", max(0, levels[[level]]$time_bonus - turn), "\n",
          "Clear Bonus: NA\n",
          "Total Score: NA\n")
      # 0 8 2 10
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

