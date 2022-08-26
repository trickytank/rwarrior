# Play the warrior game

#' Play R Warrior
#'
#' @param ai AI function to control your warrior
#' @param level Level number.
#' @param warrior_name Name of your warrior, for flavour.
#' @param sleep Time between text updates. Set to "prompt" to only progress when pressing the return key.
#' @return A logical that is TRUE on successfully getting to the stairs
#' @import cli
#' @importFrom utils askYesNo
#' @export
#' @examples
#' AI <- AI <- function(warrior, memory) {
#'   warrior$walk()
#' }
#' play_beginner(AI, level = 1)
play_beginner <- function(ai, level = 1, warrior_name = "Fisher", sleep = getOption("Rwarrior.sleep", 0.6)) {
  play_warrior_inbuilt_levels(ai = ai, level = level, warrior_name = warrior_name, sleep = sleep, debug = FALSE, output = TRUE)
}

# For inbuilt levels
play_warrior_inbuilt_levels <- function(ai, level = 1, warrior_name = "Fisher",
                                        tower = "beginner",
                                        sleep = 0, debug = FALSE, output = FALSE,
                                        max_turns = 100L) {
  if(tower == "beginner") {
    levels <- levels_beginner
  } else {
    stop("Unknown tower ", tower)
  }
  if(level > length(levels)) {
    stop("Level ", level, " does not exist in the ", tower, " tower.")
  }
  game_state <- GAME_STATE$new(levels[[level]])
  play_warrior_work(ai, game_state, level = level, warrior_name = warrior_name,
                    sleep = sleep, debug = debug, output = output, max_turns = max_turns)
}

# The work of the warrior, allowing for custom levels to be used.
play_warrior_work <- function(ai, game_state, level = NULL, warrior_name = "Fisher",
                              sleep = 0, debug = TRUE, output = FALSE, max_turns = 100L) {
  game_state$warrior$name <- warrior_name
  complete <- FALSE
  turn <- 1L
  level_score <- 0L
  memory <- NULL
  while(!complete) {
    if(output) cli_h1("Turn {turn}")
    if(output) cat(game_state$ascii)
    # clone here to prevent tampering the game_state. Doesn't prevent all cheating such as inspecting the entire game_state.
    w <- WARRIOR_ACTION$new(game_state$deep_clone())
    # w is also modified here
    memory <- ai(w, memory)
    result <- warrior_turn(w, game_state, warrior_name, sleep, debug = debug, output = output)
    points <- result$points

    level_score <- level_score + points

    if(game_state$warrior$hp <= 0) {
      if(output) cli_text(col_red("{warrior_name} died."))
      complete <- TRUE
      next
    }

    if(game_state$at_stairs) {
      complete <- TRUE
      if(output) {
        cli_h1("Found stairs")
        cat(game_state$ascii)
        cli_text("Success, you have found the stairs." %>% col_green() %>% style_bold)
        time_bonus <- max(0, game_state$level_time_bonus - turn)
        clear_bonus <- game_state$level_clear_bonus
        total_score <- time_bonus + level_score + clear_bonus
        cli_text("Level Score: {level_score}")
        cat_line(glue("Time Bonus:  {time_bonus}")) # TODO: preserve this whitespace
        cli_text("Clear Bonus: {clear_bonus}")
        cli_text("Total level score: {total_score}")
        # 0 8 2 10
        if(is.null(level)) {
          cli_text(col_blue("Congratulations, you have completed this custom level.") %>% style_bold)
        } else {
          if(level + 1 > length(levels)) {
            cli_text(col_blue("Congratulations, You have climbed to the top of the tower and reached the precious Hex.") %>% style_bold)
            if(level <= 18) {
              cli_text(col_blue("{18 - level} more levels are planned to be ported from Ruby Warrior.") %>% style_bold)
            }
          } else {
            cli_text(col_blue("See the readme for the next level of the tower with level_readme({level + 1})") %>% style_bold)
          }
        }
      }
      return(invisible(TRUE))
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

  give_clue <- askYesNo("Would you like a clue for this level?", !interactive()) # default TRUE when testing
  give_clue <- ifelse(is.na(give_clue), FALSE, give_clue) # Account for cancel response
  if(give_clue){
    cli_text(game_state$level_clue)
  }
  return(invisible(FALSE))
}

