# Definitions for the R6 class Warrior_action.

Warrior_action <- R6Class(
  "Warrior_action",
  public = list(
    action = NULL,
    direction = NULL,
    health = NULL,
    initialize = function(level_state) {
      self$health <- level_state$warrior$hp
      private$level_state <- level_state
    },
    walk = function(direction = "forward") {
      private$check_one_action()
      self$action <- "walk"
      self$direction <- direction
      invisible(self)
    },
    attack = function(direction = "forward") {
      private$check_one_action()
      self$action <- "attack"
      self$direction <- direction
      invisible(self)
    },
    rest = function() {
      private$check_one_action()
      self$action <- "rest"
      invisible(self)
    },
    feel = function(direction = "forward") {
      private$level_state$feel(direction)
    }
  ),
  private = list(
    level_state = NULL,
    check_one_action = function() {
      if(!is.null(self$action)) {
        stop("A warrior action has already been defined.")
      }
    }
  )
)

