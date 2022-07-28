#' @import stringr
warrior_turn <- function(w, health, level_state) {
  if(is.null(w$action)) {
    stop("No warrior action was provided.")
  }
  at_exit = FALSE
  lss <- level_state$vec
  x <- level_state$x

  if(w$action == "walk") {
    #if(str_detect(w$direction, "^r(i(g(ht?)?)?)?")) {
    if(!is.na(pmatch(w$direction, "right"))) {
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
    } else if (!is.na(pmatch(w$direction, "left"))) {
      if(lss[x - 1L] == " ") {
        lss[x] <- " "
        lss[x - 1L] <- "@"
      } else if (lss[x - 1L] == ">") {
        lss[x] <- " "
        lss[x - 1L] <- "@"
        at_exit = TRUE
      } else {
        message("Warrior is blocked and doesn't move.")
      }
      x <- x + 1L
    } else {
      stop("Invalid direction specified in walk()")
    }
  }

  level_state$vec <- lss
  at_exit
}


