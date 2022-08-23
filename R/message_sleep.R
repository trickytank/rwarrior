message_sleep <- function(sleep = 0, debug = FALSE) {
  if(debug) {
    cli_alert_info("--SLEEP TIME--")
  }
  if(sleep == "prompt") {
    invisible(readline())
  } else {
    Sys.sleep(sleep)
  }
  invisible(NULL)
}
