AI_07 <- function(warrior, memory) {
  if(is.null(memory)) {
    # give initial values when memory is NULL
    memory <- list(previous_health = 20, forward = TRUE)
  }
  if(warrior$feel()$wall) {
    warrior$pivot()
  } else {
    if(memory$forward) {
      if(warrior$feel()$empty) {
        if(warrior$health < memory$previous_health) {
          if(warrior$health < 10) {
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

test_that("Solutions not working for level 7.", {
  expect_s3_class(play_warrior_inbuilt_levels(
    AI_07, level = 7),
    "tbl_df"
  )
})
