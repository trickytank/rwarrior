game_state_1_1 <- GAME_STATE$new(levels[[1]])
game_state_2_1 <- GAME_STATE$new(levels[[2]])
game_state_3_1 <- GAME_STATE$new(levels[[3]])
game_state_4_1 <- GAME_STATE$new(levels[[4]])
game_state_5_1 <- GAME_STATE$new(levels[[5]])

game_state_5_2 <- game_state_5_1$deep_clone()
game_state_5_2$warrior$set_loc(1, 2)

wa_1 <- WARRIOR_ACTION$new(game_state_1_1)
wa_1$action <- "hamster"

wa_2 <- WARRIOR_ACTION$new(game_state_2_1)
wa_2$attack("backward")

wa_5_rescue_wall <- WARRIOR_ACTION$new(game_state_5_1)
wa_5_rescue_wall$rescue("backward")

wa_5_rescue_empty <- WARRIOR_ACTION$new(game_state_5_1)
wa_5_rescue_empty$rescue()

wa_5_rescue_captive <- WARRIOR_ACTION$new(game_state_5_2)
wa_5_rescue_captive$rescue()


test_that("warrior_turn()", {
  expect_error(warrior_turn(WARRIOR_ACTION$new(game_state_1_1), game_state_1_1, "Fisher"), "No warrior action was provided.")
  expect_error(warrior_turn(wa_1, game_state_1_1, "Fisher"), "Invalid warrior action")
  expect_message(warrior_turn(wa_2, game_state_2_1, "Goose", output = TRUE), paste(style_bold("attacks"), "backward and hits the wall"))
  expect_message(warrior_turn(wa_5_rescue_wall, game_state_5_1, "Fish", output = TRUE), paste(style_bold("rescue"), "backward on Wall"))
  expect_message(warrior_turn(wa_5_rescue_empty, game_state_5_1, "Fish", output = TRUE), paste(style_bold("rescues"), "forward into empty space"))
  expect_message(warrior_turn(wa_5_rescue_captive, game_state_5_2, "Fish", output = TRUE), paste("unbinds forward and", style_bold("rescues"), "Captive"))
})
