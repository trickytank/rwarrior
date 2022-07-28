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
play_warrior <- function(ai, level = 1, sleep = 0.5) {
  level_state <- Level_state$new(levels[level])
  at_exit <- FALSE
  complete <- FALSE
  turns_left <- 100L
  alive <- TRUE
  health = 20L
  while(!complete) {
    message("Turns left: ", turns_left)
    lss <- level_state$vec
    x <- which(lss == "@")
    feel_left <- ifelse(x == 1, "|", lss[x-1])
    feel_right <- ifelse(x == length(lss), "|", lss[x+1])
    w <- Warrior_action$new(health, feel_left, feel_right)
    ai(w)
    at_exit  <- warrior_turn(w, health, level_state)


    message_level_state(level_state)
    if(health <= 0) {
      message("Your warrior died.")
      return(FALSE)
    }

    if(at_exit) {
      message("You found the exit!")
      complete <- TRUE
      message("Success, you have completed level ", level, ".")
      return(invisible(NULL))
    }

    turns_left <- turns_left - 1L
    if(turns_left == 0) {
      message("Sorry, you have run out of time.")
      return(FALSE)
    }

    message("-----------------------------------")
    Sys.sleep(sleep)
  }
  return(invisible(NULL))
}

