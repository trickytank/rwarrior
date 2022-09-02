test_that("play_warrior() errors", {
  expect_error(play_warrior(sum, level = 10000), "Level 10000 does not exist in the beginner tower")
  expect_match(purrr::quietly(play_warrior)(function(warrior, memory) { warrior$walk() }, level = 1, sleep = "prompt")$messages, "")
  expect_error(play_warrior_inbuilt_levels(function(){}, tower = "fake"), "Unknown tower")
  expect_error(play_warrior(function(){}, sleep = "fake"), "Sleep is not correctly specified")
})
