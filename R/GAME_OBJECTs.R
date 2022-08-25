GAME_OBJECT <- R6Class(
  "GAME_OBJECT",
  public = list(
    name = NULL,
    symbol = NULL,
    x = NULL,
    y = NULL,
    # direction represented on the complex plane, for easy combining of directions. (simply use multiplication)
    # "east" = 1 + 0i
    # "north" = 0 + 1i
    # "west" = -1 + 0i
    # "south" = 0 - 1i
    compass = -1 + 0i, # "west"
    enemy = FALSE,
    empty = FALSE,
    player = FALSE,
    points = NULL,
    rescuable = FALSE,
    initialize = function(name, symbol, empty = FALSE) {
      self$name <- name
      self$symbol <- symbol
      self$empty <- empty
      invisible(self)
    },
    set_loc = function(y, x, compass = self$compass) {
      self$y <- y
      self$x <- x
      self$compass <- compass
      invisible(self)
    },
    set_compass = function(compass = self$compass) {
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
    initialize = function(name, symbol, max_hp, points = NULL, attack_power = NULL, shoot_power = NULL,
               feel = FALSE, look = FALSE, attack = FALSE, shoot = FALSE) {
      self$name <- name
      self$symbol <- symbol
      self$points <- points
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
    symbol = "@" %>% style_bold %>% col_blue,
    hp = 20L,
    max_hp = 20L,
    attack_power = 5L,
    shoot_power = 3L,
    walk = NULL,
    rest = NULL,
    rescue = NULL,
    pivot = NULL,
    health = NULL,
    look = NULL,
    shoot = NULL,
    compass = 1 + 0i, # "east"
    enemy = FALSE,
    player = TRUE,
    initialize = function(walk = FALSE, feel = FALSE, look = FALSE, attack = FALSE, shoot = FALSE,
                          rest = FALSE, health = FALSE, rescue = FALSE, pivot = FALSE) {
      self$walk <- walk
      self$feel <- feel
      self$look <- look
      self$attack <- attack
      self$shoot <- shoot
      self$rest <- rest
      self$health <- health
      self$rescue <- rescue
      self$pivot <- pivot
      self$look <- look
      self$shoot <- shoot
      invisible(self)
    },
    pivot_self = function(direction = "backward", warrior_name = "Fisher", output = FALSE) {
      direc <- give_direction(direction)
      self$compass <- self$compass * direc$complex
      if(output) { cli_text("{warrior_name} ", style_bold("pivots"), " {direc$direction}.") }
      invisible(self)
    }
  )
)

stairs_here <- function(yx) {
    GAME_OBJECT$new("Stairs", ">" %>% col_blue %>% style_bold, empty = TRUE)$set_loc(yx[1], yx[2])
}

empty <- GAME_OBJECT$new("Empty", " ", empty = TRUE)

wall <- GAME_OBJECT$new("Wall", "-")

captive_here <- function(y, x, compass = -1) {
  captive <- NPC$new("Captive", col_blue("C"), 1L, points = 20L)$set_loc(y, x, compass)
  captive$rescuable <- TRUE
  captive$enemy <- FALSE
  captive
}

sludge_here <- function(y, x, compass = -1) {
  NPC$new("Sludge", col_green("s"), 12L, attack_power = 3L, feel = TRUE, attack = TRUE)$set_loc(y, x, compass)
}

thick_sludge_here <- function(y, x, compass = -1) {
  thick_sludge <- NPC$new("Thick Sludge", "S" %>% col_green %>% style_bold, 24L, attack_power = 3L, feel = TRUE, attack = TRUE)$set_loc(y, x, compass)
}

archer_here <- function(y, x, compass = -1) {
  NPC$new("Archer", col_red("a"), 7L, shoot_power = 3L, look = TRUE, shoot = TRUE)$set_loc(y, x, compass)
}

wizard_here <- function(y, x, compass = -1) {
  NPC$new("Wizard", col_red("w"), 3L, shoot_power = 11L, look = TRUE, shoot = TRUE)$set_loc(y, x, compass)
}

x <- sludge_here(1L, 4L)
x
x$hp
