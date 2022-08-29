path_to_ai <- "../Rwarrior-private/tests/testthat/test_play_epic_S_grade_AI.R"
if(file.exists(path_to_ai)) {
  source(path_to_ai)
  test_that("Epic tower S rank", {
    expect_match(purrr::quietly(play_epic)(
      AI_epic_great,
      tower = c("beginner"),
      warrior_name = "Fisher",
      level_output = FALSE,
      sleep = 0)$messages,
      "Overall grade: A", all = FALSE # want to make this S grade
    )
  })
}
