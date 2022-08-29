# level_readme() tests

test_that("Level readme is successful.", {
  expect_output(
    level_readme(2),
    "warrior\\$feel\\("
  )
  expect_output(
    level_readme(3),
    "warrior\\$feel\\("
  )
  expect_output(
    level_readme(levels_beginner[[4]]),
    "warrior\\$attack\\("
  )
  expect_output(
    level_readme(GAME_STATE$new(levels_beginner[[4]])),
    "warrior\\$rest"
  )
  expect_error(
    level_readme(17),
    "does not exist"
  )
  expect_error(
    level_readme(20),
    "does not exist"
  )
  expect_error(
    level_readme("goat"),
    "Incorrect level specification"
  )
})
