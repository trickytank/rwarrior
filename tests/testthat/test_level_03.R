test_that("Solutions not working for level 3.", {
  expect_true(play_warrior(
    function(warrior, memory) {
      if(warrior$feel() == " ") {
        if(warrior$health < 15) {
          warrior$rest()
        } else {
          warrior$walk()
        }
      } else {
        warrior$attack()
      }
    },
    sleep = 0, level = 3)
  )
  expect_true(play_warrior_inbuilt_levels(
    function(warrior, memory) {
      if(warrior$feel() == " ") {
        if(warrior$health < 15) {
          warrior$rest()
        } else {
          warrior$walk()
        }
      } else {
        warrior$attack()
      }
    },
    sleep = 0, level = 3)
  )
})

# Check that resting in front of enemy makes you die
test_that("Resting in front of enemy is not causing death.", {
  expect_message(play_warrior(
    function(warrior, memory) {
      if(warrior$feel() == " ") {
        if(warrior$health < 15) {
          warrior$rest()
        } else {
          warrior$walk()
        }
      } else {
        warrior$rest()
      }
    },
    sleep = 0, level = 3),
    "Fisher died.\n"
  )
})

# Check that resting in front of enemy makes you die
test_that("Can rest above 20 health", {
  expect_message(play_warrior(
    function(warrior, memory) {
      warrior$rest()
    },
    sleep = 0, level = 3),
    " is already fit as a fiddle."
  )
})
