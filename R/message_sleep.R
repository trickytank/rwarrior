message_sleep <- function(sleep = 0, debug = FALSE) {
  if(debug) {
    message("--SLEEP TIME--")
  }
  Sys.sleep(sleep)
  invisible(NULL)
}
