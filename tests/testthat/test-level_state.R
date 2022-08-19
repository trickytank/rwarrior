test_levels <- list()

test_levels[[1]] <- list(
  description = "Test $at_exit",
  size = c(1,2),
  warrior = WARRIOR$new()$set_loc(1, 2),
  npcs = list(),
  exit = c(1,2),
  tip = "",
  time_bonus = 0,
  ace_score = 0
)

test_levels[[2]] <- list(
  description = "Test $attack_routine() and $feel()",
  size = c(1,3),
  warrior = WARRIOR$new()$set_loc(1, 1),
  npcs = list(
    sludge$clone()$set_loc(1, 2)
  ),
  exit = c(1,3),
  tip = "",
  time_bonus = 0,
  ace_score = 0
)
level_state_test_2_1 <- LEVEL_STATE$new(test_levels[[2]])

test_levels[[3]] <- list(
  description = "Test $attack_routine() on death",
  size = c(1,3),
  warrior = WARRIOR$new()$set_loc(1, 1),
  npcs = list(
    sludge$clone()$set_loc(1, 2)
  ),
  exit = c(1,3),
  tip = "",
  time_bonus = 0,
  ace_score = 0
)
level_state_test_3_1 <- LEVEL_STATE$new(test_levels[[3]])
level_state_test_3_1$npcs[[1]]$hp <- 2

level_state_2_1 <- LEVEL_STATE$new(levels[[2]])

test_that("LEVEL_STATE class", {
  # deep_clone()
  expect_error(LEVEL_STATE$new(levels[[1]])$deep_clone(), NA)
  # is_exit()
  expect_true(LEVEL_STATE$new(levels[[1]])$is_exit(1, 8))
  expect_false(LEVEL_STATE$new(levels[[1]])$is_exit(1, 6))
  # is_wall()
  expect_true(LEVEL_STATE$new(levels[[1]])$is_wall(2, 8))
  expect_true(LEVEL_STATE$new(levels[[1]])$is_wall(0, 4))
  expect_false(LEVEL_STATE$new(levels[[1]])$is_wall(1, 5))
  # return_object()
  expect_null(LEVEL_STATE$new(levels[[1]])$return_object(1, 5))
  expect_true(LEVEL_STATE$new(levels[[1]])$return_object(1, 1)$symbol == "@")
  expect_true(LEVEL_STATE$new(levels[[2]])$return_object(1, 5)$symbol == "s")
  # feel()
  expect_equal(level_state_2_1$feel(level_state_2_1$warrior), " ")
  expect_equal(level_state_2_1$feel(level_state_2_1$warrior, "back"), "-")
  expect_equal(level_state_test_2_1$feel(level_state_test_2_1$warrior, "f"), "s")
  expect_equal(level_state_test_2_1$feel(level_state_test_2_1$npcs[[1]], "f"), "@")
  # attack_routine()
  expect_message(level_state_2_1$attack_routine(level_state_2_1$warrior, level_state_2_1$npcs[[1]], "forward"), "Warrior attacks forward and hits Sludge")
  expect_message(level_state_2_1$attack_routine(level_state_2_1$warrior, level_state_2_1$npcs[[1]], "PLACEHOLDER"), "Warrior attacks PLACEHOLDER and hits Sludge")
  expect_message(level_state_2_1$attack_routine(level_state_2_1$npcs[[1]], level_state_2_1$warrior, "forward"), "Sludge attacks forward and hits Warrior")
  expect_message(level_state_test_3_1$attack_routine(level_state_test_3_1$warrior, level_state_test_3_1$npcs[[1]], "forward"), "Sludge dies.")
  # ascii
  expect_equal(LEVEL_STATE$new(levels[[1]])$ascii, "——————————\n|@      >|\n——————————\n")
  expect_error(LEVEL_STATE$new(levels[[1]])$ascii <- "duck")
  # at_exit
  expect_true(LEVEL_STATE$new(test_levels[[1]])$at_exit)
  expect_false(LEVEL_STATE$new(levels[[1]])$at_exit)
  expect_error(LEVEL_STATE$new(levels[[1]])$at_exit <- TRUE)
})
