AI_05 <- function(warrior, memory) {
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
  } else if (warrior$feel()$captive) {
    warrior$rescue()
  } else {
    warrior$attack()
  }
  memory$previous_health <- warrior$health
  memory
}

test_that("Solutions not working for level 5.", {
  expect_true(play_warrior_inbuilt_levels(
    AI_05,
    sleep = 0, level = 5)
  )
})

test_that("Non-solutions checking for expected results", {
  purrr::quietly(expect_message)(play_warrior_inbuilt_levels(
    function(warrior, memory) {
      if(warrior$feel()$empty) {
        warrior$walk()
      } else {
        warrior$attack()
      }
    },
    sleep = 0, level = 5, output = TRUE, max_turns = 3),
    "innocent"
  )$result
})
