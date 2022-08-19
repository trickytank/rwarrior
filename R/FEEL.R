FEEL <- R6Class(
  "FEEL",
  public = list(
    empty = NULL,
    stairs = NULL,
    enemy = NULL,
    captive = NULL,
    wall = NULL,
    ticking = NULL,
    golem = NULL,
    initialize = function(level_state) {
      A <- level_state$feel_object
      self$empty <- is.null(A) || A$name == "Stairs"
      self$stairs <- A$name == "Stairs"
      self$enemy <- A$enemy
      self$captive <- A$name == "Captive"
      self$wall <- A$name == "Wall"
      self$ticking <- A$name == "Bomb"
      self$golem <- A$name == "Golem"
    }
  )
)
