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
    initialize = function(game_state, direction) {
      A <- game_state$feel_warrior(direction)
      self$empty <- A$empty
      self$stairs <- A$name == "Stairs"
      self$enemy <- A$enemy
      self$captive <- A$name == "Captive"
      self$wall <- A$name == "Wall"
      self$ticking <- A$name == "Bomb"
      self$golem <- A$name == "Golem"
    }
  )
)
