# level_readme() tests

test_that("Level readme is successful.", {
  expect_output(
    level_readme(2),
    "warrior\\$feel\\$empty"
  )
})
