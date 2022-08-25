test_that("play_warrior() errors", {
  expect_error(play_warrior(sum, level = 10000), "Level 10000 does not exist.")
  expect_error(play_warrior(sum, level = 18), "Level 18 does not exist, though it is planned for the future.")
  expect_match(purrr::quietly(play_warrior)(function(warrior, memory) { warrior$walk() }, level = 1, sleep = "prompt")$messages, "")
})
