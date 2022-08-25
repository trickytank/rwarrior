give_coordinates <- function(compass, direction, y = 0, x = 0) {
  direc_list <- give_direction(direction)
  direc_complex <- direc_list$complex
  direction <- direc_list$direction
  # Using complex math to calculate the compass direction!
  offset_complex <- compass * direc_complex
  y_subject <- y - Im(offset_complex)
  x_subject <- x + Re(offset_complex)
  list(direc = direction, y_subject = y_subject, x_subject = x_subject)
}

#' @importFrom dplyr case_when
give_direction <- function(direction = c("forward", "backward", "left", "right")) {
  direction <- match.arg(direction)
  direc_complex <- case_when(
    direction == "forward" ~ 1 + 0i,
    direction == "backward" ~ -1 + 0i,
    direction == "left" ~ 1i,
    direction == "right" ~ -1i,
    TRUE ~ NA_complex_
  )
  list(direction = direction, complex = direc_complex)
}
