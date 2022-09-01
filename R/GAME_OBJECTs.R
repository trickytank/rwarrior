GAME_OBJECT <- R6Class(
  "GAME_OBJECT",
  public = list(
    name = NULL,
    symbol = NULL,
    symbol_directional = NULL, # vector of length 4, starting with the south direction going anticlockwise
    J = NULL,
    I = NULL,
    # direction represented on the complex plane, for easy combining of directions. (simply use multiplication)
    # "east" = 1 + 0i
    # "north" = 0 + 1i
    # "west" = -1 + 0i
    # "south" = 0 - 1i
    compass = -1i, # "west"
    enemy = FALSE,
    empty = FALSE,
    player = FALSE,
    points = NULL,
    rescuable = FALSE,
    bound = FALSE,
    stairs = FALSE,
    initialize = function(name, symbol, empty = FALSE) {
      self$name <- name
      self$symbol <- symbol
      self$empty <- empty
      invisible(self)
    },
    set_loc = function(I, J, compass = self$compass) {
      self$I <- I
      self$J <- J
      self$set_compass(compass)
      invisible(self)
    },
    set_compass = function(compass = self$compass) {
      # Complex plane is rotated clockwise by 90 degrees
      self$compass <- case_when(
        compass == "east" ~ 0 + 1i,
        compass == "north" ~ -1 + 0i,
        compass == "west" ~ 0 - 1i,
        compass == "south" ~ 1 + 0i,
        TRUE ~ ifelse(is.character(compass), 0i, as.complex(compass))
      )
      if(!is.null(self$symbol_directional)) {
        self$symbol <- self$symbol_directional[2 * Arg(self$compass) / pi + 2]
      }
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
    symbol_directional = c("\u25C0", "\u25BC", "\u25B6", "\u25B2") %>% col_blue,
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
    compass = 0 + 1i, # "east"
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
      self$set_compass(self$compass * direc$complex)
      if(output) { cli_text("{warrior_name} ", style_bold("pivots"), " {direc$direction}.") }
      invisible(self)
    }
  )
)

stairs_here <- function(yx) {
    stairs <- GAME_OBJECT$new("Stairs", "\u259F" %>% col_blue %>% style_bold, empty = TRUE)$set_loc(yx[1], yx[2])
    stairs$stairs <- TRUE
    stairs
}

empty <- GAME_OBJECT$new("Empty", " ", empty = TRUE)

wall <- GAME_OBJECT$new("Wall", "-")

captive_here <- function(I, J, compass = "west") {
  captive <- NPC$new("Captive", col_blue("C"), 1L, points = 20L)$set_loc(I, J, compass)
  captive$rescuable <- TRUE
  captive$enemy <- FALSE
  captive$bound <- TRUE
  captive
}

sludge_here <- function(I, J, compass = "west") {
  NPC$new("Sludge", col_green("s"), 12L, attack_power = 3L, feel = TRUE, attack = TRUE)$set_loc(I, J, compass)
}

thick_sludge_here <- function(I, J, compass = "west") {
  NPC$new("Thick Sludge", "S" %>% col_green %>% style_bold, 24L, attack_power = 3L, feel = TRUE, attack = TRUE)$set_loc(I, J, compass)
}

archer_here <- function(I, J, compass = "west") {
  NPC$new("Archer", col_red("a"), 7L, shoot_power = 3L, look = TRUE, shoot = TRUE)$set_loc(I, J, compass)
}

wizard_here <- function(I, J, compass = "west") {
  NPC$new("Wizard", col_red("w"), 3L, shoot_power = 11L, look = TRUE, shoot = TRUE)$set_loc(I, J, compass)
}

x <- sludge_here(1L, 4L)
x
x$hp
