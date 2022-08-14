NPC_TYPE <- R6Class(
  "NPC_TYPE",
  public = list(
    name = NULL,
    hp = NULL,
    symbol = NULL,
    attack_power = NULL,
    shoot_power = NULL,
    feel = NULL,
    look = NULL,
    attack = NULL,
    shoot = NULL,
    x = NULL,
    y = NULL,
    direction = NULL,
    initialize = function(name, symbol, hp, attack_power = NULL, shoot_power = NULL,
               feel = FALSE, look = FALSE, attack = FALSE, shoot = FALSE) {
      self$name <- name
      self$symbol <- symbol
      self$hp <- hp
      self$attack_power <- attack_power
      self$shoot_power <- shoot_power
      self$feel <- feel
      self$look <- look
      self$attack <- attack
      self$shoot <- shoot
    },
    set_loc = function(y, x, direction = "west") {
      self$y <- y
      self$x <- x
      self$direction <- direction
      self
    }
  )
)

NPC <- R6Class(
  "NPC",
  inherit = NPC_TYPE,
  public = list(
    x = NULL,
    y = NULL,
    direction = NULL,
    # type is a NPC_TYPE object
    initialize = function(type, x, y, direction = "west") {

    }
    set_loc = function(y, x, direction = "west") {
      self$y <- y
      self$x <- x
      self$direction <- direction
    }
  )
)



npc_sludge <- NPC_TYPE$new("Sludge", "s", 12L, attack_power = 3L, feel = TRUE, attack = TRUE)

npc_thick_sludge <- NPC_TYPE$new("Thick Sludge", "S", 24L)

npc_archer <- NPC_TYPE$new("Archer", "a", 7L, shoot_power = 3L, look = TRUE, shoot = TRUE)

x <- npc_sludge$clone()
x
x$hp
