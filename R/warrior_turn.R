#' @import stringr
warrior_turn <- function(w, health, level_state, warrior_name) {
  if(is.null(w$action)) {
    stop("No warrior action was provided.")
  }
  at_exit = FALSE
  map <- level_state$map
  x <- level_state$x
  y <- level_state$y

  if(w$action == "walk") {
    if(!is.na(pmatch(w$direction, "right"))) {
      if(map[y, x + 1L] == " ") {
        map <- swap_positions(map, x, y, x+1, y)
        cat(warrior_name, "walks forward.")
      } else if (map[y, x + 1L] == ">") {
        map[y, x] <- " "
        map[y, x + 1L] <- "@"
        cat(warrior_name, "walks forward.")
        at_exit = TRUE
      } else {
        message(warrior_name, "is blocked and doesn't move.")
      }
      x <- x + 1L
    } else if (!is.na(pmatch(w$direction, "left"))) {
      if(map[y, x - 1L] == " ") {
        map <- swap_positions(map, x, y, x-1, y)
        cat(warrior_name, "walks back.")
      } else if (map[y, x - 1L] == ">") {
        map[y, x] <- " "
        map[y, x - 1L] <- "@"
        cat(warrior_name, "walks back.")
        at_exit = TRUE
      } else {
        message(warrior_name, "is blocked and doesn't move.")
      }
      x <- x - 1L
    } else {
      stop("Invalid direction specified in walk()")
    }
  }
  level_state$map <- map
  at_exit
}

swap_positions <- function(M, x1, y1, x2, y2) {
  temp <- M[y1, x1]
  M[y1, x1] <- M[y2, x2]
  M[y2, x2] <- temp
  M
}


