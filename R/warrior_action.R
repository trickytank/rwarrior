# Definitions for the R6 class Warrior_action.

Warrior_action <- R6Class(
  "Warrior_action",
  public = list(
    action = NULL,
    direction = NULL,
    health = NULL,
    feel_forward = NULL,
    feel_backward = NULL,
    initialize = function(level_state) {
      self$health <- level_state$warrior$hp
      if(level_state$warrior$feel) {
        feel_forward <- FEEL$new(level_state, "forward")
        feel_forward <- FEEL$new(level_state, "backward")
      }
      private$level_state <- level_state
    },
    walk = function(direction = "forward") {
      private$check_one_action()
      self$action <- "walk"
      self$direction <- direction
      invisible(self)
    },
    attack = function(direction = "forward") {
      if(private$level_state$warrior$attack) {
        private$check_one_action()
        self$action <- "attack"
        self$direction <- direction
        invisible(self)
      } else {
        stop("Warrior does not yet have the attack function.")
      }
    },
    rest = function() {
      if(private$level_state$warrior$rest) {
        private$check_one_action()
        self$action <- "rest"
        invisible(self)
      } else {
        stop("Warrior does not yet have the rest function.")
      }
    },
    feel = function(direction = "forward") {
      if(private$level_state$warrior$feel) {
        private$level_state$feel(private$level_state$warrior, direction)
      } else {
        stop("Warrior does not yet have the feel function.")
      }
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

