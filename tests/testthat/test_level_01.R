context("Warrior AI tests for level 1")

test_that("Solution to level 1 doesn't work.", {
  expect_true(play_warrior(
    function(warrior, memory) {
      warrior$walk()
    },
    sleep = 0))
  expect_true(play_warrior(
    function(warrior, memory) {
      warrior$walk("for")
    },
    sleep = 0))
})

# expect_false(play_warrior(
#   function(warrior, memory) {
#     warrior$walk("bac")
#   },
#   sleep = 0)
# )

test_that("Invalid direction doesn't result in an error", {
  expect_error(play_warrior(
    function(warrior, memory) {
      warrior$walk("goat")
    },
    sleep = 0),
    "Invalid direction specified"
  )
})
