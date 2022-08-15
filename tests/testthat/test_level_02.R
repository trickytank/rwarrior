expect_true(play_warrior(
  function(warrior, memory) {
    if(warrior$feel()$empty) {
      warrior$walk()
    } else {
      warrior$attack()
    }
  },
  sleep = 0, level = 2)
)

# Attacking an empty space should do nothing
expect_false(play_warrior(
  function(warrior, memory) {
    warrior$attack()
  },
  sleep = 0, level = 2)
)
