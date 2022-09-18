#' R6 Class providing an R Warrior Code interface
#'
#' This class is provides an interface for text and graphics representations of
#' events in R Warrior and implements the game rules.
#'
#' @import R6
#' @export
rwarrior_code_interface <- R6Class(
  "rwarrior_code_interface",
  public = list(
    game_state = NULL,
    game_event = NULL,
    next_event = "level_start", #interface state
    level = NULL,
    levels = NULL,
    tower = NULL,
    points = NULL,
    practice = NULL,
    turn_stack = NULL,
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
      self$level <- level - 1L
      self$tower <- tower
      if(level > length(levels)) {
        stop("Level ", level, " does not exist in the ", tower, " tower.")
      }

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
    event = function() {
      if(self$next_event == "level_start") {
        self$level <- self$level + 1
        self$new_level(self$level)
        self$next_event <- "turn_start"
        game_event$new("start_of_level",
                       glue("Tower {self$tower}, level {self$level}."),
                       level_number = self$level)
      } else if(self$next_event == "turn_start") {
        # Work out what is happening on the turn and fill turn_stack

      } else if(self$next_event == "within_turn") {
        x <- first(self$turn_stack)
        self$turn_stack <- self$turn_stack[-1]
        if(length(self$turn_stack) == 0) {
          self$next_event <- "level_check"
        }
        x
      } else if(self$next_event == "level_check") {
        # Check if the level is complete, if so
        if(self$game_state$complete) {
          if(self$game_state$fail) {
            self$next_event <- "end"
            game_event$new("warrior_dies",
                           turn_number = self$game_state$turn_number,
                           level_number = self$level)
          } else {
            self$next_event <- "level_end"
            game_event$new("level_success",
                           points = self$game_state$points,
                           turn_number = self$game_state$turn_number,
                           level_number = self$level)
          }
        } else {
          # level is not complete, so signify the turn end
          self$next_event <- "turn_start"
          game_event$new("end_of_turn",
                         points = self$game_state$points,
                         turn_number = self$game_state$turn_number,
                         level_number = self$level)
        }
      } else if(self$next_event == "level_end") {
        # End of level, work out if we need to go to the next level or end
        if(self$epic) {
          if(self$level == length(self$levels)) {
            self$next_event <- "end"
            game_event$new("end_of_tower",
                           points = self$game_state$points,
                           turn_number = self$game_state$turn_number,
                           level_number = self$level)
          } else {
            self$next_event <- "level_start"
            game_event$new("end_of_level",
                           points = self$game_state$points,
                           turn_number = self$game_state$turn_number,
                           level_number = self$level)
          }
        } else {
          self$next_event <- "end"
          game_event$new("end_of_game",
                         points = self$game_state$points,
                         turn_number = self$game_state$turn_number,
                         level_number = self$level)
        }
      } else if(self$next_event == "end") {
        return(NULL)
      }
    }
  )
)

# A class representing one event.
# An event may be:
#   * "start_of_level" # with `number` as level number.
#   * "start_of_turn" # with `number` as turn number
#   * "end_of_turn"
#   * "end_of_level"
#   * "end_of_game"
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
  public = list(
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
)
