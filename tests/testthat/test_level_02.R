expect_true(play_warrior(
  function(warrior) {
    if(warrior$feel()$empty) {
      warrior$walk()
    } else {
      warrior$attack()
    }
  },
  sleep = 0)
)
