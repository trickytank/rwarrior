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
  expect_equal(WARRIOR$new()$set_loc(1,1, "east")$pivot_self(output = TRUE)$symbol %>% ansi_strip, "\u25C0")
})

test_that("Stairs", {
  expect_s3_class(stairs_here(c(1, 8)), "GAME_OBJECT")
})

test_that("NPC generation", {
  expect_s3_class(sludge_here(1, 3), c("NPC", "GAME_OBJECT"))
  expect_s3_class(thick_sludge_here(1, 3), c("NPC", "GAME_OBJECT"))
  expect_s3_class(archer_here(1, 3), c("NPC", "GAME_OBJECT"))
  expect_s3_class(wizard_here(1, 3), c("NPC", "GAME_OBJECT"))
  expect_s3_class(captive_here(1, 3), c("NPC", "GAME_OBJECT"))
})

test_that("GAME_OBJECT$set_compass", {
  expect_equal(sludge_here(1,3)$set_compass("north")$compass, -1 + 0i)
  expect_equal(archer_here(1,3)$set_compass("south")$compass, 1 + 0i)
  expect_equal(archer_here(1,2)$set_compass("east")$compass, 0 + 1i)
  expect_equal(archer_here(2,5)$set_compass("west")$compass, 0 - 1i)
})
