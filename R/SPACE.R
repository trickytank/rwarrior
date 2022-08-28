SPACE <- R6Class(
  "SPACE",
  public = list(
    empty = NULL,
    stairs = NULL,
    enemy = NULL,
    captive = NULL,
    wall = NULL,
    ticking = NULL,
    golem = NULL,
    initialize = function(A) { # A is a game object
      self$empty <- A$empty
      self$stairs <- A$stairs
      self$enemy <- A$enemy
      self$captive <- A$name == "Captive"
      self$wall <- A$name == "Wall"
      self$ticking <- A$name == "Bomb"
      self$golem <- A$name == "Golem"
    }
  )
)
