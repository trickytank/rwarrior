test_levels <- list()

test_levels[[1]] <- list(
  description = "Test $at_stairs",
  size = c(1,2),
  warrior = WARRIOR$new()$set_loc(1, 2),
  npcs = list(),
  stairs = c(1,2),
  tip = "",
  time_bonus = 0,
  ace_score = 0
)

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

test_levels[[3]] <- list(
  description = "Test $attack_routine() on death",
  size = c(1,3),
  warrior = WARRIOR$new()$set_loc(1, 1),
  npcs = list(
    sludge_here(1, 2)
  ),
  stairs = c(1,3),
  tip = "",
  time_bonus = 0,
  ace_score = 0
)
game_state_test_3_1 <- GAME_STATE$new(test_levels[[3]])
game_state_test_3_1$npcs[[1]]$hp <- 2

test_levels[[4]] <- list(
  description = "Test multiple objects at a location causes error on $ascii",
  size = c(1,3),
  warrior = WARRIOR$new()$set_loc(1, 1),
  npcs = list(
    sludge_here(1, 2),
    archer_here(1, 2)
  ),
  stairs = c(1,3),
  tip = "",
  time_bonus = 0,
  ace_score = 0
)
game_state_test_4_1 <- GAME_STATE$new(test_levels[[4]])

test_levels[[4]] <- list(
  description = "Test multiple objects at a location causes error on $ascii",
  size = c(1,3),
  warrior = WARRIOR$new()$set_loc(1, 1),
  npcs = list(
    sludge_here(1, 2),
    archer_here(1, 2)
  ),
  stairs = c(1,3),
  tip = "",
  time_bonus = 0,
  ace_score = 0
)
game_state_test_4_1 <- GAME_STATE$new(test_levels[[4]])

test_levels[[5]] <- list(
  description = "Test that look finds objects 3 spaces away",
  size = c(1,5),
  warrior = WARRIOR$new()$set_loc(1, 1),
  npcs = list(
    sludge_here(1, 4)
  ),
  stairs = c(1,5),
  tip = "",
  time_bonus = 0,
  ace_score = 0
)
game_state_test_5_1 <- GAME_STATE$new(test_levels[[5]])

test_levels[[6]] <- list(
  description = "Test that look does not find objects 4 spaces away",
  size = c(1,6),
  warrior = WARRIOR$new()$set_loc(1, 1),
  npcs = list(
    sludge_here(1, 5)
  ),
  stairs = c(1,6),
  tip = "",
  time_bonus = 0,
  ace_score = 0
)
game_state_test_6_1 <- GAME_STATE$new(test_levels[[6]])

game_state_1_1 <- GAME_STATE$new(levels_beginner[[1]])
game_state_2_1 <- GAME_STATE$new(levels_beginner[[2]])
game_state_3_1 <- GAME_STATE$new(levels_beginner[[3]])
game_state_4_1 <- GAME_STATE$new(levels_beginner[[4]])

test_that("GAME_STATE class", {
  # deep_clone()
  expect_error(GAME_STATE$new(levels_beginner[[1]])$deep_clone(), NA)
  # is_stairs()
  expect_true(GAME_STATE$new(levels_beginner[[1]])$is_stairs(1, 8))
  expect_false(GAME_STATE$new(levels_beginner[[1]])$is_stairs(1, 6))
  # is_wall()
  expect_true(GAME_STATE$new(levels_beginner[[1]])$is_wall(2, 8))
  expect_true(GAME_STATE$new(levels_beginner[[1]])$is_wall(0, 4))
  expect_false(GAME_STATE$new(levels_beginner[[1]])$is_wall(1, 5))
  # return_object()
  expect_true(GAME_STATE$new(levels_beginner[[1]])$return_object(1, 5)$empty)
  expect_equal(ansi_strip(GAME_STATE$new(levels_beginner[[1]])$return_object(1, 1)$symbol), ansi_strip(WARRIOR$new()$set_compass(1i)$symbol))
  expect_equal(ansi_strip(GAME_STATE$new(levels_beginner[[2]])$return_object(1, 5)$symbol), ansi_strip(sludge_here(1,1)$symbol))
  # feel()
  expect_equal(game_state_2_1$feel_symbol(game_state_2_1$warrior), empty$symbol)
  expect_equal(game_state_2_1$feel_symbol(game_state_2_1$warrior, "back"), wall$symbol)
  expect_false(game_state_2_1$feel_symbol(game_state_2_1$warrior, "back") != wall$symbol)
  expect_equal(ansi_strip(game_state_test_2_1$feel_symbol(game_state_test_2_1$warrior, "f")), ansi_strip(sludge_here(1,1)$symbol))
  expect_equal(game_state_test_2_1$feel_symbol(game_state_test_2_1$npcs[[1]], "f"), WARRIOR$new()$set_compass(1i)$symbol)
  # look
  expect_equal(game_state_1_1$look_first_symbol(game_state_1_1$warrior), empty$symbol)
  # look: check that look finds objects 2 and 3 spaces away, but not 4
  expect_equal(ansi_strip(game_state_test_5_1$look_first_symbol(game_state_1_1$warrior)), ansi_strip(sludge_here(1,1)$symbol))
  expect_equal(game_state_test_6_1$look_first_symbol(game_state_1_1$warrior), empty$symbol)
  # attack_routine()
  expect_match(purrr::quietly(game_state_2_1$attack_routine)(game_state_2_1$warrior, game_state_2_1$npcs[[1]], "forward", output = TRUE)$messages,
               "Warrior attacks forward and hits Sludge", all = FALSE)
  expect_match(purrr::quietly(game_state_3_1$attack_routine)(game_state_3_1$warrior, game_state_3_1$npcs[[1]], "PLACEHOLDER", output = TRUE)$messages,
               "Warrior attacks PLACEHOLDER and hits Sludge", all = FALSE)
  expect_match(purrr::quietly(game_state_3_1$attack_routine)(game_state_3_1$npcs[[1]], game_state_3_1$warrior, "forward", output = TRUE)$messages,
               "Sludge attacks forward and hits Warrior", all = FALSE)
  expect_match(purrr::quietly(game_state_3_1$attack_routine)(game_state_test_3_1$warrior, game_state_test_3_1$npcs[[1]], "forward", output = TRUE)$messages,
               "Sludge dies.", all = FALSE)
  expect_error(game_state_2_1$attack_routine(game_state_2_1$warrior, game_state_2_1$npcs[[1]], "forward", attack_type = "gorilla"), "attack_routine() unknown attack_type", fixed = TRUE)
  # ascii
  expect_equal(GAME_STATE$new(levels_beginner[[1]])$ascii, paste0("——————————\n|", WARRIOR$new()$set_compass(1i)$symbol, "      ", stairs_here(c(1,1))$symbol, "|\n——————————\n"))
  expect_error(GAME_STATE$new(levels_beginner[[1]])$ascii <- "duck")
  expect_error(game_state_test_4_1$ascii, "More than one object at location")
  # at_stairs
  expect_true(GAME_STATE$new(test_levels[[1]])$at_stairs)
  expect_false(GAME_STATE$new(levels_beginner[[1]])$at_stairs)
  expect_error(GAME_STATE$new(levels_beginner[[1]])$at_stairs <- TRUE)
})
