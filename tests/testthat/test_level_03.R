expect_true(play_warrior(
  function(warrior, memory) {
    if(warrior$feel()$empty) {
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

# Check that resting in front of enemy makes you die
expect_false(play_warrior(
  function(warrior, memory) {
    if(warrior$feel()$empty) {
      if(warrior$health < 15) {
        warrior$rest()
      } else {
        warrior$walk()
      }
    } else {
      warrior$rest()
    }
  },
  sleep = 0, level = 3)
)

#TODO: check you can't rest above 20