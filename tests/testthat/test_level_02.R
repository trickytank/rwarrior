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
