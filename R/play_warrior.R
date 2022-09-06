#' Play R Warrior
#'
#' Attempt inbuilt levels of R Warrior.
#'
#' @param ai AI function to control your warrior.
#' @param level Level number.
#' @param tower Tower the level comes from.
#' @param warrior_name Name of your warrior, for flavor.
#' @param sleep Time between text updates in seconds. Set to "prompt" to only progress when pressing the return key.
#' @param practice If TRUE, any functions available for that tower may be used.
#' @return A tibble if successful, FALSE if unsuccessful,
#'         and NA if the AI function caused an error or no action was called.
#' @import cli
#' @import stringr
#' @importFrom utils askYesNo
#' @importFrom dplyr last
#' @export
#' @examples
#' AI <- function(warrior, memory) {
#'   if(is.null(memory)) {
#'     # set memory initial values here
#'   }
#'   # insert AI code here
#'   memory
#' }
#' play_warrior(AI, level = 1)
play_warrior <- function(ai, level = 1,
                          tower = c("beginner"),
                          warrior_name = "Fisher",
                          sleep = getOption("rwarrior.sleep", ifelse(interactive(), 0.6, 0)),
                          practice = FALSE) {
  tower <- match.arg(tower)
  checkmate::assert_function(ai)
  checkmate::assert_int(level)
  checkmate::assert_string(warrior_name)
  if(!checkmate::test_number(sleep) && !identical(sleep, "prompt")) {
    stop("Sleep is not correctly specified.")
  }
  checkmate::assert_flag(practice)
  play_warrior_inbuilt_levels(ai = ai, level = level, warrior_name = warrior_name,
                              tower = tower,
                              sleep = sleep, practice = practice,
                              debug = FALSE, output = TRUE)
}

# For inbuilt levels
play_warrior_inbuilt_levels <- function(ai, level = 1, warrior_name = "Fisher",
                                        tower = "beginner",
                                        sleep = 0, practice = FALSE,
                                        debug = FALSE, output = FALSE,
                                        max_turns = 100L) {
  if(tower == "beginner") {
    levels <- levels_beginner
  } else {
    # TODO: work for custom towers
    stop("Unknown tower ", tower)
  }
  if(level > length(levels)) {
    stop("Level ", level, " does not exist in the ", tower, " tower.")
  }
  game_state <- GAME_STATE$new(levels[[level]])
  if(practice) {
    # Assume that the final level warrior has all the abilities to be used
    cw <- game_state$warrior
    game_state$warrior <- GAME_STATE$new(last(levels))$warrior$set_loc(cw$I, cw$J, cw$compass)
  }
  invisible(play_warrior_work(ai, game_state, level = level, levels = levels,
                              warrior_name = warrior_name,
                    sleep = sleep, debug = debug, output = output, max_turns = max_turns))
}

# The work of the warrior, allowing for custom levels to be used.
play_warrior_work <- function(ai, game_state, level = NULL, levels = NULL,
                              warrior_name = "Fisher",
                              sleep = 0, debug = TRUE, output = FALSE, max_turns = 100L,
                              epic = FALSE) {
  game_state$warrior$name <- warrior_name
  complete <- FALSE
  turn <- 1L
  level_score <- 0L
  memory <- NULL
  while(!complete) {
    if(output) cli_h2("Turn {turn}")
    if(output) cat(game_state$ascii)
    # clone here to prevent tampering the game_state. Doesn't prevent all cheating such as inspecting the entire game_state.
    w <- WARRIOR_ACTION$new(game_state$deep_clone())
    # w is also modified here
    ai_error <- FALSE
    memory <- tryCatch(ai(w, memory), error = function(e) { ai_error <<- TRUE; e })
    if(ai_error) {
      error_message <- paste("Error in AI function:", str_remove(as.character(memory), "^.+: "))
      cli_alert_danger(error_message)
      return(NA)
    }
    result <- warrior_turn(w, game_state, warrior_name, sleep, debug = debug, output = output)
    if(is.character(result)) {
      # Error with AI
      cli_alert_danger(result)
      return(NA)
    }
    points <- result$points

    level_score <- level_score + points

    if(game_state$warrior$hp <= 0) {
      if(output) cli_text(col_red("{warrior_name} died."))
      complete <- TRUE
      next
    }

    if(game_state$at_stairs) {
      complete <- TRUE
      time_bonus <- max(0, game_state$level_time_bonus - turn)
      if(length(game_state$npcs) == 0) {
        clear_bonus <- round((level_score + time_bonus) / 5)
      } else {
        clear_bonus <- 0
      }
      total_score <- time_bonus + level_score + clear_bonus
      level_rank <- level_ranker(total_score, game_state$level_ace_score)
      if(output) {
        cli_h2("Found stairs")
        cat(game_state$ascii)
        cli_text("Success, you have found the stairs." %>% col_green() %>% style_bold)
        cli_text("Points: {level_score}")
        cat_line(glue("Time Bonus:  {time_bonus}")) # TODO: preserve this whitespace
        cli_text("Clear Bonus: {clear_bonus}")
        cli_text("Total level score: {total_score}")
        # 0 8 2 10
        if(is.null(level)) {
          cli_text(col_blue("Congratulations, you have completed this custom level.") %>% style_bold)
        } else {
          if(level + 1 > length(levels)) {
            cli_text(col_blue("Congratulations, You have climbed to the top of the tower and reached the precious Hex.") %>% style_bold)
            if(!epic) cli_text("Try writing a single AI for all the levels of this tower with play_epic().")
          } else {
            if(!epic) {
              cli_text(col_blue("See the readme for the next level of the tower with level_readme({level + 1})") %>% style_bold)
            }
          }
        }
      }
      return(tibble::tibble(
        Level = level,
        Points = level_score,
        Time_bonus = time_bonus,
        Clear_bonus = clear_bonus,
        Level_score = total_score,
        Target_score = game_state$level_ace_score,
        Percentage = 100 * total_score / game_state$level_ace_score,
        Rank = level_rank,
      ))
    }

    turn <- turn + 1L
    if(turn > max_turns) {
      if(output) cli_text(col_red("Sorry, you have run out of time."))
      complete <- TRUE
      next
    }

    if(game_state$fail) {
      if(output) cli_text(col_red("You have failed."))
      complete <- TRUE
    }
  }

  if(!epic) {
    give_clue <- askYesNo("Would you like a clue for this level?", !interactive()) # default TRUE when testing
    give_clue <- ifelse(is.na(give_clue), FALSE, give_clue) # Account for cancel response
    if(give_clue){
      cli_text(game_state$level_clue)
    }
  }
  return(invisible(FALSE))
}

