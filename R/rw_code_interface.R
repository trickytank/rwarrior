#' R6 Class providing an R Warrior Code interface
#'
#' This class is provides an interface for text and graphics representations of
#' events in R Warrior and implements the game rules.
#'
#' @import R6
#' @export
rw_code_interface <- R6Class(
  "rw_code_interface",
  game_state = NULL,
  level = NULL,
  levels = NULL,
  points = NULL,
  practice = NULL,
  epic = NULL,
  ai = NULL,
  initialize = function(
    ai,
    level = 1,
    tower = c("beginner"),
    warrior_name = "Fisher",
    practice = FALSE,
    epic = FALSE) {
      checkmate::assert_function(ai)
      checkmate::assert_int(level, lower = 1L)
      if(is.list(tower)) {
        self$levels <- tower
        tower <- "custom" # used later
      } else {
        tower <- match.arg(tower)
        if(tower == "beginner") {
          self$levels <- levels_beginner
        }
      }
      self$ai <- ai
      self$practice <- practice
      self$epic <- epic
      if(level > length(levels)) {
        stop("Level ", level, " does not exist in the ", tower, " tower.")
      }
      self$new_level(level)
  },
  new_level = function(level) {
    self$game_state <- GAME_STATE$new(self$levels[[level]])
    self$level <- level
    if(self$practice || self$epic) {
      # Assume that the final level warrior has all the abilities to be used
      cw <- self$game_state$warrior
      self$game_state$warrior <- GAME_STATE$new(last(self$levels))$warrior$set_loc(cw$I, cw$J, cw$compass)
    }
    self
  },
  next_event = function() {

  }

)

# A class representing one event.
# An event may be:
#   * "start_of_level" # with `number` as level number.
#   * "start_of_turn" # with `number` as turn number
#   * "level_success" # Successful completion of the current level, level_scores should have a non-null value.
#   * "tower_success" # Successful completion of in the tower. (level_success is always reported previously)
#   * "warrior_dies" # The Warrior has run out of health and died.
#   * "out_of_time" # The Warrior has run out of time and has missed out on the precious Hex.
#   * "error" # There was an error when calling the AI function.
#   * "walk" # subject walks
#   * "attack" # subject attacks target
#   * "rest" # subject rests
#   * "shoot" # subject shoots target
#   * "rescue" # subject unbinds target
#   * "pivot" # subject pivots to the compass direction specified
game_event <- R6Class(
  "game_event",
  event = NULL, # event name as above
  text = NULL, # An asci escaped string describing the event as in play_warrior() in text mode.
  subject = NULL,
  target = NULL,
  points = 0,
  number = NULL,
  i_offset = 0, # Direction offset North to South
  j_offset = 0, # Direction offset West to East
  i_offset_previous = 0, # previous compass direction North to South
  j_offset_previous = 0, # previous compass direction West to East
  level_scores = NULL,
  initialize = function(event, text = "", subject = NULL, target = NULL,
                        direction_compass = NULL, direction_compass_previous = NULL,
                        points = 0, turn_number = NULL, level_number = NULL,
                        level_scores = NULL) {
    self$event <- event
    self$text <- text
    self$subject <- subject
    self$target <- target
    self$i_offset <- Re(direction_compass)
    self$j_offset <- Im(direction_compass)
    self$i_offset_previous <- Re(direction_compass_previous)
    self$j_offset_previous <- Re(direction_compass_previous)
    self$points <- points
    self$turn_number <- turn_number
    self$level_number <- level_number
    self$level_scores <- level_scores
    self
  }

)
