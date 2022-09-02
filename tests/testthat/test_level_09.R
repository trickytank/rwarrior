AI_09 <- function(warrior, memory) {
  if(is.null(memory)) {
    # give initial values when memory is NULL
    memory <- list(previous_health = 20, forward = TRUE)
  }
  if(warrior$feel()$wall) {
    warrior$pivot()
  } else {
    if(memory$forward) {
      if(warrior$feel()$empty) {
        ahead <- warrior$look()
        if(ahead[[2]]$enemy || (ahead[[2]]$empty && ahead[[3]]$enemy)) {
          if(warrior$health < memory$previous_health) {
            warrior$walk()
          } else {
            warrior$shoot()
          }
        } else {
          if(warrior$health < memory$previous_health) {
            if(warrior$health < 7) {
              warrior$walk("backward")
              memory$forward <- FALSE
            } else {
              warrior$walk()
            }
          } else if (warrior$health < 20) {
            warrior$rest()
          } else {
            warrior$walk()
          }
        }
      } else if (warrior$feel()$captive) {
        warrior$rescue()
      } else {
        warrior$attack()
      }
    } else {
      if(warrior$feel("backward")$captive) {
        warrior$rescue("backward")
      } else if (warrior$feel("backward")$wall) {
        memory$forward = TRUE
        warrior$rest()
      } else {
        warrior$walk("backward")
      }
    }
  }
  memory$previous_health <- warrior$health
  memory
}

test_that("Solutions not working for level 9.", {
  expect_match(purrr::quietly(play_warrior_inbuilt_levels)(
    AI_09, level = 9, output = TRUE)$messages,
    "Try writing a single AI for all the levels of this tower with play_epic",
    all = FALSE
  )
})

test_that("Level 9 readme", {
  expect_match(purrr::quietly(level_readme)(
    9)$output,
    "Shoot an arrow in the given direction", all = FALSE
  )
})
