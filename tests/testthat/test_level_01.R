# Warrior AI tests for level 1

test_that("Solution to level 1 doesn't work.", {
  expect_s3_class(play_warrior_inbuilt_levels(
    function(warrior, memory) {
      warrior$walk()
    }), "tbl_df")
  expect_s3_class(play_warrior_inbuilt_levels(
    function(warrior, memory) {
      warrior$walk("for")
    }
    ), "tbl_df")
  expect_s3_class(play_warrior_inbuilt_levels(
    function(warrior, memory) {
      warrior$walk()
    }),
    "tbl_df")
  expect_s3_class(purrr::quietly(play_warrior)(
    function(warrior, memory) {
      warrior$walk()
    },
    sleep = 0)$result, "tbl_df")
  purrr::quietly(expect_false)(play_warrior_inbuilt_levels(
    function(warrior, memory) {
      warrior$walk("bac")
    },
    sleep = 0)
  )$result
  expect_match(purrr::quietly(play_warrior_work)(
    function(warrior, memory) {
      warrior$walk("for")
    },
    game_state = GAME_STATE$new(levels_beginner[[1]]), sleep = 0, output = TRUE, debug = FALSE)$messages,
    "custom level", all = FALSE
  )
  expect_s3_class(play_warrior_inbuilt_levels(
    function(warrior, memory) {
      warrior$walk("for")
    }, practice = TRUE),
    "tbl_df")
})


test_that("Invalid direction doesn't result in an error", {
  expect_error(play_warrior_inbuilt_levels(
    function(warrior, memory) {
      warrior$walk("goat")
    },
    sleep = 0),
    "should be one of"
  )
})
