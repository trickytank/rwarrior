#' @import R6
GAME_STATE <- R6Class(
  "GAME_STATE",
  public = list(
    size = NULL,
    npcs = NULL,
    stairs = NULL,
    warrior = NULL,
    level_description = NULL,
    level_tip = NULL,
    level_time_bonus = NULL,
    level_clear_bonus = NULL,
    level_ace_score = NULL,
    level_clue = NULL,
    initialize = function(level_spec) {
      self$npcs <- list()
      for(i in seq_along(level_spec$npcs)) {
        self$npcs[[i]] <- level_spec$npcs[[i]]$clone()
      }
      self$size <- level_spec$size
      self$warrior <- level_spec$warrior$clone()
      self$stairs <- level_spec$stairs
      self$level_description <- level_spec$description
      self$level_tip <- level_spec$tip
      self$level_time_bonus <- level_spec$time_bonus
      self$level_clear_bonus <- level_spec$clear_bonus
      self$level_ace_score <- level_spec$ace_score
      self$level_clue <- level_spec$clue
      invisible(self)
    },
    deep_clone = function() {
      X <- self$clone(deep = TRUE)
      for(i in seq_along(self$npcs)) {
        X$npcs[[i]] <- self$npcs[[i]]$clone()
      }
      X
    },
    is_stairs = function(y, x) {
      self$stairs[1] == y && self$stairs[2] == x
    },
    is_wall = function(y, x) {
      y == 0 || x == 0 || y == self$size[1] + 1 || x == self$size[2] + 1
    },
    return_object = function(y, x) {
      for(npc in self$npcs) {
        if(y == npc$y && x == npc$x) {
          return(npc)
        }
      }
      if(y == self$warrior$y && x == self$warrior$x) {
        return(self$warrior)
      }
      if(self$is_wall(y, x)) {
        return(wall$clone()) # clone for safety
      }
      return(empty)
    },
    feel_object = function(charac, direction = "forward") {
      coord <- give_coordinates(charac$compass, direction, charac$y, charac$x)
      object <- self$return_object(coord$y_subject, coord$x_subject)
      object
    },
    feel_warrior = function(direction = "forward") {
      self$feel_object(self$warrior, direction)
    },
    feel_symbol = function(charac, direction = "forward") {
      object <- self$feel_object(charac, direction)
      object$symbol
    },
    # Look up to three spaces
    look_array = function(charac, direction = "forward") {
      object_list <- list(NULL, NULL, NULL)
      y_subject <- charac$y
      x_subject <- charac$x
      for(i in 1:3) {
        coord <- give_coordinates(charac$compass, direction, y_subject, x_subject)
        y_subject <- coord$y_subject
        x_subject <- coord$x_subject
        object_list[[i]] <- self$return_object(y_subject, x_subject)
      }
      object_list
    },
    look_first_object = function(charac, direction = "forward") {
      la <- self$look_array(charac, direction)
      for(i in seq_along(la)) {
        if(!la[[i]]$empty) {
          return(la[[i]])
        }
      }
      return(empty)
    },
    look_first_symbol = function(charac, direction = "forward") {
      object <- self$look_first_object(charac, direction)$symbol
    },
    attack_routine = function(attacker, defender, direction, attack_type = "attacks", sleep = 0, debug = FALSE, output = FALSE) {
      if(attack_type == "attacks") {
        hit_power <- attacker$attack_power
      } else if (attack_type == "shoots") {
        hit_power <- attacker$shoot_power
      } else {
        stop("attack_routine() unknown attack_type.")
      }
      defender$hp <- defender$hp - hit_power
      if(output) cli_text("{attacker$name} {attack_type} {direction} and hits {defender$name}.")
      message_sleep(sleep, debug)
      if(output) cli_text("{defender$name} takes {hit_power} damage, {defender$hp} health power left.")
      if(defender$hp <= 0 && ! "WARRIOR" %in% class(defender)) {
        # defender is an enemy and has died
        message_sleep(sleep, debug)
        points <- defender$max_hp
        if(output) cli_text("{defender$name} dies.")
        message_sleep(sleep, debug)
        if(output) cli_text("{attacker$name} earns {points} points.")
        defender$death_flag <- TRUE
        for(i in seq_along(self$npcs)) {
          if(self$npcs[[i]]$death_flag) {
            self$npcs[[i]] <- NULL
            break
          }
        }
        return(points)
      }
      return(0)
    }
  ),
  active = list(
    ascii = function(value) {
      if (missing(value)) {
        lines <- ""
        level_map <- matrix(" ", nrow = self$size[1], ncol = self$size[2])
        level_map[self$stairs[1], self$stairs[2]] <- ">"
        for(charac in c(list(self$warrior), self$npcs)) {
          # either space or
          # if charac is not warrior, then not allowed
          # if charac is warrior, then only stairs is allowed
          if(level_map[charac$y, charac$x] != " " &&
             (charac$symbol != "@" ||
             (charac$symbol == "@" && level_map[charac$y, charac$x] != ">"))) {
            stop("More than one object at location (", charac$y, ", ", charac$x, ")")
          }
          level_map[charac$y, charac$x] <- charac$symbol
        }
        tpmatrix <- matrix(rep("\u2014", self$size[2] + 2L), nrow = 1)
        sidematrix <- matrix(rep("|", self$size[1]))
        draw <- rbind(tpmatrix,
                          cbind(sidematrix, level_map, sidematrix),
                          tpmatrix)
        for(i in seq_len(nrow(draw))) {
          lines <- paste0(lines, paste0(draw[i, ], collapse = ""), "\n")

        }
        return(lines)
      } else {
        stop("Cannot assign ascii")
      }
    },
    at_stairs = function(value) {
      if (missing(value)) {
          self$is_stairs(self$warrior$y, self$warrior$x)
        } else {
          stop("Cannot assign at_stairs")
        }
    }
  )
)
