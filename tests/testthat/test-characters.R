test_that("GAME_OBJECT R6 class", {
  expect_true(
    inherits(GAME_OBJECT$new("Wall", "-"),
             "GAME_OBJECT")
  )
})


test_that("NPC R6 class", {
  expect_true(
    inherits(NPC$new("Sludge", "s", 12L, attack_power = 3L, feel = TRUE, attack = TRUE),
             c("NPC", "GAME_OBJECT"))
  )
})

test_that("WARRIOR R6 class", {
  expect_true(
    inherits(WARRIOR$new(feel = TRUE),
             c("WARRIOR", "NPC", "GAME_OBJECT"))
    )
})
