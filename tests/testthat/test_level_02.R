# Warrior tests for level 2

test_that("Solutions not working for level 2.", {
  expect_s3_class(
    play_warrior_inbuilt_levels(
      function(warrior, memory) {
        if(warrior$feel()$empty) {
          warrior$walk()
        } else {
          warrior$attack()
        }
      },
      level = 2),
    "tbl_df"
  )
  expect_s3_class(
    play_warrior_inbuilt_levels(
      function(warrior, memory) {
        if(warrior$feel()$empty) {
          warrior$walk()
        } else {
          warrior$attack()
        }
      },
      level = 2),
    "tbl_df"
  )
})

# Attacking an empty space should do nothing
test_that("No message that attacking an empty space is failing.", {
  expect_match(purrr::quietly(play_warrior_inbuilt_levels)(
    function(warrior, memory) {
      warrior$attack()
    },
    sleep = 0, level = 2, max_turns = 2, output = TRUE)$messages %>%
      ansi_strip,
    "attacks forward and hits nothing.", all = FALSE
  )
})

test_that("Message should be given is warrior is blocked.", {
  expect_match(purrr::quietly(play_warrior_inbuilt_levels)(
    function(warrior, memory) {
      warrior$walk()
    },
    sleep = 0, level = 2, output = TRUE, max_turns = 4)$messages,
    "is blocked and doesn't move.", all = FALSE
  )
})

