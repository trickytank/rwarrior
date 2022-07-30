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
    },
    feel = function(direction = "right") {
      if(str_detect(direction, "^r(i(g(ht?)?)?)?")) {
        level_state$map[y, x+1]
      } else if (str_detect(direction, "^l(e(ft?)?)?")) {
        level_state$map[y, x-1]
      } else {
        stop("Unspecified direction in $feel.")
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

