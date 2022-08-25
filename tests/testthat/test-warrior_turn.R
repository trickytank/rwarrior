game_state_1_1 <- GAME_STATE$new(levels[[1]])
game_state_2_1 <- GAME_STATE$new(levels[[2]])

wa_1 <- WARRIOR_ACTION$new(game_state_1_1)
wa_1$action <- "hamster"

wa_2 <- WARRIOR_ACTION$new(game_state_2_1)
wa_2$attack("backward")

test_that("warrior_turn()", {
  expect_error(warrior_turn(WARRIOR_ACTION$new(game_state_1_1), game_state_1_1, "Fisher"), "No warrior action was provided.")
  expect_error(warrior_turn(wa_1, game_state_1_1, "Fisher"), "Invalid warrior action")
  expect_message(warrior_turn(wa_2, game_state_2_1, "Goose", output = TRUE), paste(style_bold("attacks"), "backward and hits the wall"))
})
