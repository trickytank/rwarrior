NPC <- R6Class(
  "NPC",
  public = list(
    name = NULL,
    hp = NULL,
    max_hp = NULL,
    symbol = NULL,
    attack_power = NULL,
    shoot_power = NULL,
    feel = NULL,
    look = NULL,
    attack = NULL,
    shoot = NULL,
    x = NULL,
    y = NULL,
    compass = NULL,
    compass_default = "west",
    death_flag = FALSE,
    initialize = function(name, symbol, max_hp, attack_power = NULL, shoot_power = NULL,
               feel = FALSE, look = FALSE, attack = FALSE, shoot = FALSE) {
      self$name <- name
      self$symbol <- symbol
      self$max_hp <- max_hp
      self$hp <- max_hp
      self$attack_power <- attack_power
      self$shoot_power <- shoot_power
      self$feel <- feel
      self$look <- look
      self$attack <- attack
      self$shoot <- shoot
      invisible(self)
    },
    set_loc = function(y, x, compass = self$compass_default) {
      self$y <- y
      self$x <- x
      self$compass <- compass
      invisible(self)
    }
  )
)

WARRIOR <- R6Class(
  "WARRIOR",
  inherit = NPC,
  public = list(
    name = "Warrior",
    symbol = "@",
    hp = 20L,
    max_hp = 20L,
    attack_power = 5L,
    walk = NULL,
    rest = NULL,
    health = NULL,
    compass_default = "east",
    initialize = function(walk = FALSE, feel = FALSE, look = FALSE, attack = FALSE, shoot = FALSE,
                          rest = FALSE, health = FALSE) {
      self$walk <- walk
      self$feel <- feel
      self$look <- look
      self$attack <- attack
      self$shoot <- shoot
      self$rest <- rest
      self$health <- health
      invisible(self)
    }

  )
)


sludge <- NPC$new("Sludge", "s", 12L, attack_power = 3L, feel = TRUE, attack = TRUE)

thick_sludge <- NPC$new("Thick Sludge", "S", 24L)

archer <- NPC$new("Archer", "a", 7L, shoot_power = 3L, look = TRUE, shoot = TRUE)

x <- sludge$clone()$set_loc(1L, 4L)
x
x$hp
