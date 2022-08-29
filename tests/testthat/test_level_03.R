test_that("Solutions not working for level 3.", {
  expect_s3_class(play_warrior_inbuilt_levels(
    function(warrior, memory) {
      if(warrior$feel()$empty) {
        if(warrior$health < 20) {
          warrior$rest()
        } else {
          warrior$walk()
        }
      } else {
        warrior$attack()
      }
    },
    level = 3),
    "tbl_df"
  )
  expect_s3_class(play_warrior_inbuilt_levels(
    function(warrior, memory) {
      if(warrior$feel()$empty) {
        if(warrior$health < 20) {
          warrior$rest()
        } else {
          warrior$walk()
        }
      } else {
        warrior$attack()
      }
    },
    level = 3),
    "tbl_df"
  )
})

# Check that resting in front of enemy makes you die
test_that("Resting in front of enemy is not causing death.", {
  expect_match(purrr::quietly(play_warrior_inbuilt_levels)(
    function(warrior, memory) {
      if(warrior$feel()$empty) {
        if(warrior$health < 15) {
          warrior$rest()
        } else {
          warrior$walk()
        }
      } else {
        warrior$rest()
      }
    },
    sleep = 0, level = 3, output = TRUE, max_turns = 20)$messages,
    "Fisher died.", all = FALSE
  )
})

test_that("Can rest above 20 health", {
  expect_match(purrr::quietly(play_warrior_inbuilt_levels)(
    function(warrior, memory) {
      warrior$rest()
    },
    sleep = 0, level = 3, output = TRUE, max_turns = 1)$messages,
    " is already fit as a fiddle.", all = FALSE
  )
})
