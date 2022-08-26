game_state_1_1 <- GAME_STATE$new(levels_beginner[[1]])
game_state_2_1 <- GAME_STATE$new(levels_beginner[[2]])
game_state_3_1 <- GAME_STATE$new(levels_beginner[[2]])
game_state_4_1 <- GAME_STATE$new(levels_beginner[[2]])
test_levels <- list()

test_levels[[2]] <- list(
  description = "Test $attack_routine() and $feel()",
  size = c(1,3),
  warrior = WARRIOR$new(feel = TRUE)$set_loc(1, 1),
  npcs = list(
    sludge_here(1, 2)
  ),
  stairs = c(1,3),
  tip = "",
  time_bonus = 0,
  ace_score = 0
)
game_state_test_2_1 <- GAME_STATE$new(test_levels[[2]])

test_that("WARRIOR_ACTION", {
  expect_s3_class(WARRIOR_ACTION$new(game_state_2_1), "WARRIOR_ACTION")
  expect_true(WARRIOR_ACTION$new(game_state_2_1)$feel()$empty)
  expect_true(WARRIOR_ACTION$new(game_state_test_2_1)$feel()$enemy)
  expect_false(WARRIOR_ACTION$new(game_state_test_2_1)$feel()$empty)
  expect_error(WARRIOR_ACTION$new(game_state_1_1)$feel(), "Warrior does not yet have the feel function")
  expect_error(WARRIOR_ACTION$new(game_state_1_1)$attack(), "Warrior does not yet have the attack function")
  expect_error(WARRIOR_ACTION$new(game_state_1_1)$rest(), "Warrior does not yet have the rest function")
  expect_error(WARRIOR_ACTION$new(game_state_3_1)$walk()$attack(), "A warrior action has already been defined.")
  expect_true(WARRIOR_ACTION$new(game_state_3_1)$feel("backward")$wall)
  expect_error(WARRIOR_ACTION$new(game_state_3_1)$feel("goose")$wall, "'arg' should be one of")
})
