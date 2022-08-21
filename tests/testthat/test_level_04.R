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
  expect_true(play_warrior(
    AI_04,
    sleep = 0, level = 4)
  )
  expect_true(play_warrior_inbuilt_levels(
    AI_04,
    sleep = 0, level = 4)
  )
})