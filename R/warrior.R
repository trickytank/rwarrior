# Definitions for the S3 class warrior.

warrior_new <- function() {
  w <- list()
  w$x <- 1L # Position on the x axis
  w$health <- 20L # Health of our warrior
  w$memory <- NULL # Warrior memory for the user to define.
  structure(w, class = c("warrior"))
}

# Walk the warrior
# direction is "+" or "right" to move to the right (default), or "-" or "left" to the left.
walk.warrior <- function(w, direction = "right") {
  if(direction == "+" || durection == "right" ) {
    w$x <- "try_right"
  } elsif(direction == "-" || durection == "left" ) {
    w$x <- "try_left"
  } else {
    stop("Invalid direction specified in walk()")
  }
  update_level_state()
}

feel.warrior <- function(w) {

}

attack.warrior <- function(w)

}
