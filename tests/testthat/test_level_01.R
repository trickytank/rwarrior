# Warrior AI tests for level 1

expect_true(play_warrior(
  function(warrior) {
    warrior$walk()
  },
  sleep = 0)
)

expect_false(play_warrior(
  function(warrior) {
    warrior$walk("lef")
  },
  sleep = 0)
)

expect_error(play_warrior(
  function(warrior) {
    warrior$walk("goat")
  },
  sleep = 0))
