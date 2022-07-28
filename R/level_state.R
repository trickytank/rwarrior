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
    vec = function() {
      strsplit(self$state, "")[[1]]
    }
  )
)
