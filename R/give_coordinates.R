give_coordinates <- function(compass, direction, y = 0, x = 0) {
  if(compass == "east") {
    x_offset <- 1L
  }
  if(compass == "west") {
    x_offset <- -1L
  }
  if(compass == "north") {
    y_offset <- -1L
  }
  if(compass == "south") {
    y_offset <- 1L
  }
  if(!is.na(pmatch(direction, "forward"))) {
    direc <- "forward"
  } else if (!is.na(pmatch(direction, "backward"))) {
    direc <- "backward"
    x_offset <- x_offset * -1L
    y_offset <- y_offset * -1L
  } else {
    stop("Invalid direction specified: ", direction, "")
  }
  y_subject <- y + y_offset
  x_subject <- x + x_offset
  list(direc, y_offset, x_offset)
}
