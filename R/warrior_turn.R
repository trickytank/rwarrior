
warrior_turn <- function(w, health, level_state) {
  if(is.null(w$action)) {
    stop("No warrior action was provided.")
  }
  at_exit = FALSE
  lss <- level_state$vec
  x <- which(lss == "@")

  if(w$action == "walk") {
    if(w$direction != "+" && w$direction != "-" ) {
      stop("Invalid direction specified in walk()")
    }
    if(w$direction == "+") {
      if(lss[x + 1L] == " ") {
        lss[x] <- " "
        lss[x + 1L] <- "@"
      } else if (lss[x + 1L] == ">") {
        lss[x] <- " "
        lss[x + 1L] <- "@"
        at_exit = TRUE
      } else {
        message("Warrior is blocked and doesn't move.")
      }
      x <- x + 1L
    } else if (w$direction == "-") {
      stop("Action \"try_left\" is not yet implemented.")
    }
  }

  level_state$state <- paste0(lss, collapse = "")
  at_exit
}


