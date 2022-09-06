# Definitions for the R6 class WARRIOR_ACTION.

WARRIOR_ACTION <- R6Class(
  "WARRIOR_ACTION",
  public = list(
    action = NULL,
    direction = NULL,
    health = NULL,
    look_forward = NULL,
    look_backward = NULL,
    look_left = NULL,
    look_right = NULL,
    initialize = function(game_state) {
      self$health <- game_state$warrior$hp
      private$attack_ability <- game_state$warrior$attack
      private$feel_ability <- game_state$warrior$feel
      private$rest_ability <- game_state$warrior$rest
      private$rescue_ability <- game_state$warrior$rescue
      private$pivot_ability <- game_state$warrior$pivot
      private$look_ability <- game_state$warrior$look
      private$shoot_ability <- game_state$warrior$shoot
      # feel and look arrays
      self$look_forward <- game_state$look_space(game_state$warrior, direction = "forward")
      self$look_backward <- game_state$look_space(game_state$warrior, direction = "backward")
      self$look_left <- game_state$look_space(game_state$warrior, direction = "left")
      self$look_right <- game_state$look_space(game_state$warrior, direction = "right")
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
    shoot = function(direction = "forward") {
      if(private$shoot_ability) {
        private$check_one_action()
        self$action <- "shoot"
        self$direction <- direction
        invisible(self)
      } else {
        stop("Warrior does not yet have the shoot function.")
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
      if(private$feel_ability) {
        direc_l <- give_direction(direction)
        if(direc_l$direction == "forward") {
          self$look_forward[[1]]
        } else if (direc_l$direction == "backward") {
          self$look_backward[[1]]
        } else if (direc_l$direction == "left") {
          self$look_left[[1]]
        } else if (direc_l$direction == "right") {
          self$look_right[[1]]
        }
      } else {
        stop("Warrior does not yet have the feel function.")
      }
    },
    look = function(direction = "forward") {
      if(private$look_ability) {
        direc_l <- give_direction(direction)
        if(direc_l$direction == "forward") {
          self$look_forward
        } else if (direc_l$direction == "backward") {
          self$look_backward
        } else if (direc_l$direction == "left") {
          self$look_left
        } else if (direc_l$direction == "right") {
          self$look_right
        }
      } else {
        stop("Warrior does not yet have the look function.")
      }
    },
    rescue = function(direction = "forward") {
      if(private$rescue_ability) {
        private$check_one_action()
        self$action <- "rescue"
        self$direction <- direction
        invisible(self)
      } else {
        stop("Warrior does not yet have the rescue function.")
      }
    },
    pivot = function(direction = "backward") {
        private$check_one_action()
        self$action <- "pivot"
        self$direction <- direction
        invisible(self)
    }
  ),
  private = list(
    attack_ability = NULL,
    feel_ability = NULL,
    rest_ability = NULL,
    rescue_ability = NULL,
    pivot_ability = NULL,
    look_ability = NULL,
    shoot_ability = NULL,
    check_one_action = function() {
      if(!is.null(self$action)) {
        stop("Cannot call more than one Warrior action on a turn.")
      }
    }
  )
)

