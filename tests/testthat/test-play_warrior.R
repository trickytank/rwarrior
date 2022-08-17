test_that("multiplication works", {
  expect_error(play_warrior(sum, level = 10000), "Level 10000 does not exist.")
})
