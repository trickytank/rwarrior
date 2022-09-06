#' Play through an epic quest of a tower
#'
#' Write a single AI function to play through each level of the specified tower.
#' Refine your AI in order to achieve an overall S rank.
#'
#' @param ai AI function to control your warrior.
#' @param tower Tower to attempt.
#' @param warrior_name Name of your warrior, for flavor.
#' @param level_output A logical denoting whether to give individual level progress.
#' @param sleep Time between text updates. Set to "prompt" to only progress when pressing the return key.
#' @return A tibble if successful, or otherwise FALSE.
#' @return A tibble giving the scores for each level passed.
#' @examples
#' AI <- function(warrior, memory) {
#'   if(is.null(memory)) {
#'     # set memory initial values here
#'   }
#'   # Modify the following section to be able to complete the tower
#'   warrior$walk()
#'   memory
#' }
#' play_epic(AI, tower = "beginner", warrior_name = "Euler")
#' @importFrom dplyr mutate across
#' @importFrom tibble is_tibble
#' @export
play_epic <- function(ai, tower = c("beginner"), warrior_name = "Fisher",
                      level_output = TRUE,
                      sleep = getOption("rwarrior.sleep", ifelse(interactive(), 0.6, 0))) {
  tower <- match.arg(tower)
  checkmate::assert_function(ai)
  checkmate::assert_string(warrior_name)
  checkmate::assert_flag(level_output)
  if(!checkmate::test_number(sleep) && !identical(sleep, "prompt")) {
    stop("Sleep is not correctly specified")
  }
  if(!level_output) {
    sleep <- 0
  }
  play_epic_internal(ai, tower = tower, warrior_name = warrior_name, sleep = sleep,
                     level_output = level_output, output = TRUE)
}

#' @importFrom methods show
#' @importFrom tibble tibble
#' @importFrom dplyr bind_rows
play_epic_internal <-  function(ai, warrior_name = "Fisher",
                                tower = "beginner",
                                sleep = 0,
                                level_output = FALSE,
                                debug = FALSE, output = FALSE,
                                max_turns = 100L) {
  if(tower == "beginner") {
    levels <- levels_beginner
  } else {
    # TODO: work for custom towers
    stop("Unknown tower ", tower)
  }
  summaries <- tibble()
  if(sleep == "prompt") {
    sleep_cycles <- 1
  } else {
    sleep_cycles <- 1:4
  }
  for(level in seq_along(levels)) {
    if(level_output) { cli_h1("Tower {tower}, level {level}.") }
    game_state <- GAME_STATE$new(levels[[level]])
    # Assume that the final level warrior has all the abilities to be used
    cw <- game_state$warrior
    game_state$warrior <- GAME_STATE$new(last(levels))$warrior$set_loc(cw$I, cw$J, cw$compass)
    level_summary <- play_warrior_work(ai, game_state, level = level, levels = levels,
                                warrior_name = warrior_name,
                                sleep = sleep, debug = debug, output = level_output,
                                max_turns = max_turns, epic = TRUE)
    if(!is_tibble(level_summary)) {
      cli_alert_warning("Sorry you did not complete the tower.")
      cli_alert("Try using play_warrior(..., practice = TRUE) to practice levels with the full set of commands.")
      return(invisible(summaries))
    }
    summaries <- bind_rows(summaries, level_summary)
    if(level_output) { cli_text("Level rank: {level_summary$Rank}"); cli_text() }
    for(i in sleep_cycles) {
      message_sleep(sleep, debug)
    }
  }
  # Max out over-performing to 110%
  average_grade_percentage <- mean(pmin(summaries$Percentage, 100))
  average_rank <- level_ranker(average_grade_percentage, 100)
  if(output) {
    cli_h1("Summary")
    show(as.data.frame(summaries) %>% mutate(across(Percentage, ~paste0(floor(.x), "%"))))
    cli_text("Total score {sum(summaries$Level_score)}")
    cli_text("Rank perecentage: {round(average_grade_percentage, 1)}%")
    cli_text("Overall rank: {average_rank}")
    if(average_rank == "S") {
      cli_text("Congratulations! You achieved the top rank!")
    } else {
      cli_text("Try to improve your AI to get an S rank! (all levels with an S rank)")
    }
    cli_text("Submit your AI to the leader board at https://tankard.id/post/r-warrior-leaderboard/")
  }
  invisible(summaries)
}
