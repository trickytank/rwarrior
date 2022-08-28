AI_04 <- function(warrior, memory) {
  if(is.null(memory)) {
    # give initial values when memory is NULL
    memory <- list(previous_health = 20)
  }
  if(warrior$feel()$empty) {
    if(warrior$health < 20) {
      if(warrior$health < memory$previous_health) {
        warrior$walk()
      } else {
        warrior$rest()
      }
    } else {
      warrior$walk()
    }
  } else {
    warrior$attack()
  }
  memory$previous_health <- warrior$health
  memory
}

test_that("Solutions not working for level 4.", {
  expect_s3_class(play_warrior_inbuilt_levels(
    AI_04,
    level = 4),
    "tbl_df"
  )
})
# Add to final level
  # expect_match(purrr::quietly(play_warrior_inbuilt_levels)(
  #   AI_04, sleep = 0, level = 4, output = TRUE)$messages,
  #   "precious Hex", all = FALSE
  # )

test_that("Solutions that should not work for level 4", {
  purrr::quietly(expect_false)(play_warrior_inbuilt_levels(
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
    sleep = 0, level = 4))$result
})
