#' @import R6
Level_state <- R6Class(
  "Level_state",
  public = list(
    state = NULL,
    initialize = function(level_map) {
      self$state <- level_map
      invisible(self$state)
    }
  ),
  active = list(
    vec = function(value) {
      if (missing(value)) {
        strsplit(self$state, "")[[1]]
      } else {
        self$state <- paste0(value, collapse = "")
      }
    },
    x = function(value) {
      if (missing(value)) {
        which(self$vec == "@")
      } else {
        stop("Cannot assign X")
      }
    }
  )
)
