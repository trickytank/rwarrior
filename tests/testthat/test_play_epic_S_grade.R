if(Sys.getenv("RUNNER_TEMP") != "") {
  path_to_ai <- file.path(Sys.getenv("SECRET_FILE"), "test_play_epic_S_grade_AI.R")
} else {
  path_to_ai <- "../../../Rwarrior-private/tests/testthat/test_play_epic_S_grade_AI.R"
}
skip_if_no_epic_ai <- function() {
  if (!file.exists(path_to_ai)) {
    skip("Advanced AI not available for play_epic().")
  }
}

test_that("Epic tower S rank", {
  skip_if_no_epic_ai()
  source(path_to_ai)
  expect_match(purrr::quietly(play_epic)(
    AI_epic_great,
    tower = c("beginner"),
    warrior_name = "Fisher",
    level_output = FALSE,
    sleep = 0)$messages,
    "Overall grade: A", all = FALSE # want to make this S grade
  )
})
