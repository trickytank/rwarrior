# Play the warrior game


play_warrior <- function(ai, level = 1) {
  w <- warrior_new()
  level_state <- level_01
  at_exit <- FALSE
  complete <- FALSE
  turns_left <- 100L
  alive <- TRUE
  while(!complete) {
    message("Turns left: " turns_left)
    result <- warrior_turn(ai, w, level_state)
    w <- result$x
    level_state <- result$w
    message_level_state(level_state)
    at_exit <- result$at_exit
    alive <- result$alive
    turns_left <- turns_left - 1L
    if(!alive) {
      message("Your warrior died.")
      return(NULL)
    }
    if(turns_left == 0) {
      message("Sorry, you have run out of time.")
      return(NULL)
    }
    message("-----------------------------------")
  }
  message("Success, you have completed level ", level, ".")
  return(NULL)
}

warrior_turn <- function(ai, w, level_state) {
  w <- ai(w)
  list(w, level_state, at_exit, alive)
}
