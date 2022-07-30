# Definitions for the R6 class Warrior_action.

Warrior_action <- R6Class(
  "Warrior_action",
  public = list(
    action = NULL,
    feel_right = NULL,
    feel_left = NULL,
    direction = NULL,
    initialize = function(health, feel_left = NA, feel_right = NA) {
      private$health <- health
      self$feel_left <- feel_left
      self$feel_right <- feel_right
    },
    walk = function(direction = "right") {
      private$check_one_action()
      self$action <- "walk"
      self$direction <- direction
      invisible(self)
    },
    fight = function(direction = "right") {
      private$check_one_action()
      self$action <- "fight"
      self$direction <- direction
      invisible(self)
    }
  ),
  private = list(
    health = NULL,
    check_one_action = function() {
      if(!is.null(self$action)) {
        stop("A warrior action has already been defined.")
      }
    }
  )
)

