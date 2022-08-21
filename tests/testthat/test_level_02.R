# Warrior tests for level 2

test_that("Solutions not working for level 2.", {
  expect_true(
    play_warrior_inbuilt_levels(
      function(warrior, memory) {
        if(warrior$feel()$empty) {
          warrior$walk()
        } else {
          warrior$attack()
        }
      },
      sleep = 0, level = 2)
  )
  expect_true(
    play_warrior_inbuilt_levels(
      function(warrior, memory) {
        if(warrior$feel()$empty) {
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

test_that("Message should be given is warrior is blocked.", {
  expect_message(play_warrior(
    function(warrior, memory) {
      warrior$walk()
    },
    sleep = 0, level = 2),
    "is blocked and doesn't move."
  )
})

