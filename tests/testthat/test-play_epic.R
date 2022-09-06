if(Sys.getenv("RUNNER_TEMP") != "") {
  path_to_ai <- file.path(Sys.getenv("RUNNER_TEMP"), "test_play_epic_S_grade_AI.R")
} else {
  path_to_ai <- "../../../rwarrior-private/tests/testthat/test_play_epic_S_grade_AI.R"
}
skip_if_no_epic_ai <- function() {
  if (!file.exists(path_to_ai)) {
    skip("Advanced AI not available for play_epic().")
  }
}

test_that("Epic tower S rank", {
  skip_if_no_epic_ai()
  source(path_to_ai)
  expect_match(purrr::quietly(play_epic)(
    AI_epic_great,
    tower = c("beginner"),
    warrior_name = "Fisher",
    level_output = TRUE,
    sleep = 0)$messages,
    "Overall rank: A", all = FALSE # want to make this S grade
  )
})

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

test_that("Epic tower A rank", {
  expect_match(purrr::quietly(play_epic)(
    AI_09,
    tower = c("beginner"),
    warrior_name = "Fisher",
    level_output = TRUE,
    sleep = "prompt")$messages,
    "Overall rank: A", all = FALSE
  )
})

test_that("AIs for epic that fail.", {
  expect_match(purrr::quietly(play_epic)(
    function(w, m) { w$walk() },
    tower = c("beginner"),
    warrior_name = "Fisher",
    level_output = FALSE,
    sleep = "prompt")$messages,
    "practice levels with the full set of commands",
    all = FALSE
  )
})

test_that("play_epic() errors", {
  expect_error(play_epic(function(){}, sleep = "kek"), "Sleep is not correctly specified")
  expect_error(play_epic_internal(function() {}, tower = "fake"), "Unknown tower")
})
