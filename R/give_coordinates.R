give_coordinates <- function(compass, direction, I = 0, J = 0) {
  direc_list <- give_direction(direction)
  direc_complex <- direc_list$complex
  direction <- direc_list$direction
  # Using complex math to calculate the compass direction!
  offset_complex <- compass * direc_complex
  # We need to flip the y direction as indexes increase as you go down.
  I_subject <- I + Re(offset_complex)
  J_subject <- J + Im(offset_complex)
  list(direc = direction, I_subject = I_subject, J_subject = J_subject)
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
