message_sleep <- function(sleep = 0, debug = FALSE) {
  if(debug) {
    cli_alert_info("--SLEEP TIME--")
  }
  if(sleep == "prompt") {
    invisible(readLines(n = 1L))
  } else {
    Sys.sleep(sleep)
  }
  invisible(NULL)
}
