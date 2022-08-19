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
      private$attack_ability <- level_state$warrior$attack
      if(level_state$warrior$feel) {
        self$feel_forward <- FEEL$new(level_state, "forward")
        self$feel_backward <- FEEL$new(level_state, "backward")
      }
    },
    walk = function(direction = "forward") {
      private$check_one_action()
      self$action <- "walk"
      self$direction <- direction
      invisible(self)
    },
    attack = function(direction = "forward") {
      if(private$attack_ability) {
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
      if(is.null(self$feel_forward)) {
        stop("Warrior does not yet have the feel function.")
      } else {
        if(!is.na(pmatch(direction, "forward"))) {
          self$feel_forward
        } else if (!is.na(pmatch(direction, "backward"))) {
          self$feel_backward
        } else {
          stop("Invalid direction specified: ", direction, "")
        }
      }
    }
  ),
  private = list(
    attack_ability = NULL,
    check_one_action = function() {
      if(!is.null(self$action)) {
        stop("A warrior action has already been defined.")
      }
    }
  )
)

