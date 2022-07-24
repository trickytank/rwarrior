message_level_state <- function(level_state) {
  message(" ", rep("-", length(level_state)), " ")
  message("|", paste0(level_state, collapse = ""), "|")
  message(" ", rep("-", length(level_state)), " ")
}
