# Definitions for the R6 class WARRIOR_ACTION.

WARRIOR_ACTION <- R6Class(
  "WARRIOR_ACTION",
  public = list(
    action = NULL,
    direction = NULL,
    health = NULL,
    feel_forward = NULL,
    feel_backward = NULL,
    initialize = function(game_state) {
      self$health <- game_state$warrior$hp
      private$attack_ability <- game_state$warrior$attack
      private$rest_ability <- game_state$warrior$rest
      if(game_state$warrior$feel) {
        self$feel_forward <- SPACE$new(game_state, "forward")
        self$feel_backward <- SPACE$new(game_state, "backward")
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
      if(private$rest_ability) {
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
    rest_ability = NULL,
    check_one_action = function() {
      if(!is.null(self$action)) {
        stop("A warrior action has already been defined.")
      }
    }
  )
)

