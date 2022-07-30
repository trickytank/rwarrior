# Definitions for the R6 class Warrior_action.

Warrior_action <- R6Class(
  "Warrior_action",
  public = list(
    action = NULL,
    direction = NULL,
    health = NULL,
    initialize = function(health, level_state) {
      self$health <- health
      private$level_state <- level_state
    },
    walk = function(direction = "forward") {
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
    },
    feel = function() {
      c(empty = level_state$map[y, x+1] %in% c(" ", ">"))
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

