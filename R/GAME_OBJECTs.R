GAME_OBJECT <- R6Class(
  "GAME_OBJECT",
  public = list(
    name = NULL,
    symbol = NULL,
    x = NULL,
    y = NULL,
    compass = NULL,
    compass_default = "west",
    enemy = FALSE,
    empty = FALSE,
    initialize = function(name, symbol, empty = FALSE) {
      self$name <- name
      self$symbol <- symbol
      self$empty <- empty
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

NPC <- R6Class(
  "NPC",
  inherit = GAME_OBJECT,
  public = list(
    hp = NULL,
    max_hp = NULL,
    attack_power = NULL,
    shoot_power = NULL,
    feel = NULL,
    look = NULL,
    attack = NULL,
    shoot = NULL,
    enemy = TRUE,
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
    enemy = FALSE,
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

stairs_here <- function(yx) {
    GAME_OBJECT$new("Stairs", ">", empty = TRUE)$set_loc(yx[1], yx[2])
}

empty <- GAME_OBJECT$new("Empty", " ", empty = TRUE)

wall <- GAME_OBJECT$new("Wall", "-")

sludge_here <- function(y, x) {
  NPC$new("Sludge", "s", 12L, attack_power = 3L, feel = TRUE, attack = TRUE)$set_loc(y, x)
}

thick_sludge_here <- function(y, x) {
  thick_sludge <- NPC$new("Thick Sludge", "S", 24L, attack_power = 3L, feel = TRUE, attack = TRUE)$set_loc(y, x)
}

archer_here <- function(y, x) {
  NPC$new("Archer", "a", 7L, shoot_power = 3L, look = TRUE, shoot = TRUE)$set_loc(y, x)
}

x <- sludge_here(1L, 4L)
x
x$hp
