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
play_warrior <- function(ai, level = 1) {
  w <- warrior_new()
  level_state <- level_01
  at_exit <- FALSE
  complete <- FALSE
  turns_left <- 100L
  alive <- TRUE
  while(!complete) {
    message("Turns left: ", turns_left)
    result <- warrior_turn(ai, w, level_state)
    w <- result$w
    level_state <- result$level_state
    message_level_state(level_state)
    at_exit <- result$at_exit
    alive <- result$alive
    turns_left <- turns_left - 1L
    if(!alive) {
      message("Your warrior died.")
      return(FALSE)
    }
    if(at_exit) {
      message("You found the exit!")
      complete <- TRUE
    }
    if(turns_left == 0) {
      message("Sorry, you have run out of time.")
      return(FALSE)
    }
    message("-----------------------------------")
  }
  message("Success, you have completed level ", level, ".")
  return(NULL)
}

warrior_turn <- function(ai, w, level_state) {
  ai_result <- ai(w, level_state)
  if(ai_result$action == "walk") {
    if(is.null(ai_result$direction)) {
      ai_result$direction <- "right"
    }
    action_result <- walk(w, ai_result$direction, level_state)
  }
  if(action_result$at_exit) {
    return(action_result)
  }
  #TODO: enemy attacks
  return(action_result)
  #list(w, level_state, at_exit, alive)
}
