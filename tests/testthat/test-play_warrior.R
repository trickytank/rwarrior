test_that("play_warrior() errors", {
  expect_error(play_beginner(sum, level = 10000), "Level 10000 does not exist.in the beginner tower")
  expect_match(purrr::quietly(play_beginner)(function(warrior, memory) { warrior$walk() }, level = 1, sleep = "prompt")$messages, "")
})
