context("Warrior tests for level 2.")

test_that("Solutions not working for level 2.", {
  expect_true(
    play_warrior(
      function(warrior, memory) {
        if(warrior$feel() == " ") {
          warrior$walk()
        } else {
          warrior$attack()
        }
      },
      sleep = 0, level = 2)
  )
})

# Attacking an empty space should do nothing
test_that("No message that attacking an empty space is failing.", {
  expect_message(play_warrior(
    function(warrior, memory) {
      warrior$attack()
    },
    sleep = 0, level = 2),
    "attacks forward and hits nothing."
  )
})
