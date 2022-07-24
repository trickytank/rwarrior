# Definitions for the S3 class warrior.

warrior_new <- function() {
  w <- list()
  w$x <- 1L # Position on the x axis
  w$health <- 20L # Health of our warrior
  w$memory <- NULL # Warrior memory for the user to define.
  structure(w, class = c("warrior"))
}

#' Walk the warrior
#' direction is "+" or "right" to move to the right (default), or "-" or "left" to the left.
#' @export
walk.warrior <- function(w, direction = "right", level_state) {
  if(direction == "+" || direction == "right" ) {
    action <- "try_right"
  } else if(direction == "-" || direction == "left" ) {
    action <- "try_left"
  } else {
    stop("Invalid direction specified in walk()")
  }
  if(action == "try_right") {
    if(level_state[w$x] == " ") {
      w$x + 1L
      level_state[w$x] <- " "
      level_state[w$x + 1L] <- "@"
    } else if (level_state[w$x] == ">") {
      w$x + 1L
      level_state[w$x] <- " "
      level_state[w$x + 1L] <- "@"
      at_exit = TRUE
    } else {
      message("Warrior is blocked and doesn't move.")
    }
  } else if (action == "try_left") {
    stop("Action \"try_left\" is not yet implemented.")
  }
  list(w = w, level_state = level_state, at_exit = at_exit, alive = TRUE)
}

warrior.feel <- function(w, direction) {

}

warrior.attack <- function(w) {

}
