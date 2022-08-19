test_that("GAME_OBJECT R6 class", {
  expect_true(
    inherits(GAME_OBJECT$new("Wall", "-")$set_loc(0, 0),
             "GAME_OBJECT")
  )
})


test_that("NPC R6 class", {
  expect_true(
    inherits(NPC$new("Sludge", "s", 12L, attack_power = 3L, feel = TRUE, attack = TRUE)$set_loc(3, 1),
             c("NPC", "GAME_OBJECT"))
  )
})

test_that("WARRIOR R6 class", {
  expect_true(
    inherits(WARRIOR$new(feel = TRUE)$set_loc(1,1),
             c("WARRIOR", "NPC", "GAME_OBJECT"))
    )
})
