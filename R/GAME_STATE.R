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
    fail = FALSE,
    initialize = function(level_spec) {
      self$npcs <- list()
      for(i in seq_along(level_spec$npcs)) {
        self$npcs[[i]] <- level_spec$npcs[[i]]$clone()
      }
      self$size <- level_spec$size
      self$warrior <- level_spec$warrior$clone()
      self$stairs <- stairs_here(level_spec$stairs)
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
    is_stairs = function(I, J) {
      self$stairs$I == I && self$stairs$J == J
    },
    is_wall = function(I, J) {
      I == 0 || J == 0 || I == self$size[1] + 1 || J == self$size[2] + 1
    },
    return_object = function(I, J) {
      out_object <- empty
      for(npc in self$npcs) {
        if(I == npc$I && J == npc$J) {
          out_object <- npc
        }
      }
      if(out_object$empty) {
        if(I == self$warrior$I && J == self$warrior$J) {
          out_object <- self$warrior
        } else if(self$is_wall(I, J)) {
          out_object <- wall$clone() # clone for safety
        } else if (self$is_stairs(I, J)) {
          out_object <- self$stairs
        }
      }
      if(!out_object$player && self$is_stairs(I, J)) {
        # assume objects and NPC don't move (except for player)
        out_object$stairs <- TRUE
      }
      return(out_object)
    },
    feel_object = function(charac, direction = "forward") {
      coord <- give_coordinates(charac$compass, direction, charac$I, charac$J)
      object <- self$return_object(coord$I_subject, coord$J_subject)
      object
    },
    feel_symbol = function(charac, direction = "forward") {
      object <- self$feel_object(charac, direction)
      object$symbol
    },
    # Look up to three spaces
    look_array = function(charac, direction = "forward") {
      object_list <- list(NULL, NULL, NULL)
      I_subject <- charac$I
      J_subject <- charac$J
      for(i in 1:3) {
        coord <- give_coordinates(charac$compass, direction, I_subject, J_subject)
        I_subject <- coord$I_subject
        J_subject <- coord$J_subject
        object_list[[i]] <- self$return_object(I_subject, J_subject)
      }
      object_list
    },
    look_space = function(charac, direction = "forward") {
      look_ar <- self$look_array(charac, direction)
      space_array <- list(NULL, NULL, NULL)
      for(i in seq_along(space_array)) {
        space_array[[i]] <- SPACE$new(look_ar[[i]])
      }
      space_array
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
    remove_npc = function(charac) {
      charac$death_flag <- TRUE
      for(i in seq_along(self$npcs)) {
        if(self$npcs[[i]]$death_flag) {
          self$npcs[[i]] <- NULL
          break
        }
      }
    },
    attack_routine = function(attacker, defender, direction, attack_type = "attacks", sleep = 0, debug = FALSE, output = FALSE) {
      if(attack_type == "attacks") {
        hit_power <- attacker$attack_power
      } else if (attack_type == "shoots") {
        hit_power <- attacker$shoot_power
      } else {
        stop("attack_routine() unknown attack_type.")
      }
      if(direction != "forward") {
        # Reduce hit power when not going forward
        # This may not be a true replication of Ruby warrior, though it replicates:
        # 5 attack power forward and 3 attack power backward.
        hit_power <- ceiling(hit_power / 2)
      }
      defender$hp <- defender$hp - hit_power
      if(output) cli_text(attacker$name, style_bold(" {attack_type}"),  " {direction} and hits {defender$name}.")
      message_sleep(sleep, debug)
      if(output) cli_text("{defender$name} takes {hit_power} damage, {defender$hp} health power left.")
      if(defender$hp <= 0 && ! "WARRIOR" %in% class(defender)) {
        # defender is an npc and has died
        message_sleep(sleep, debug)
        if(output) cli_text("{defender$name} dies.")
        message_sleep(sleep, debug)
        if(defender$rescuable) {
          if(output) cli_text("{attacker$name} has killed the innocent.")
          self$fail <- TRUE
          return(0)
        }
        points <- defender$max_hp
        if(output) cli_text("{attacker$name} earns {points} points.")
        self$remove_npc(defender)
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
        level_map[self$stairs$I, self$stairs$J] <- self$stairs$symbol
        for(charac in c(list(self$warrior), self$npcs)) {
          # either space or
          # if charac is not warrior, then not allowed
          # if charac is warrior, then only stairs is allowed
          if(level_map[charac$I, charac$J] != " " && level_map[charac$I, charac$J] != stairs_here(c(1,1))$symbol) {
            stop("More than one object at location (", charac$I, ", ", charac$J, ")")
          }
          level_map[charac$I, charac$J] <- charac$symbol
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
          self$is_stairs(self$warrior$I, self$warrior$J)
        } else {
          stop("Cannot assign at_stairs")
        }
    }
  )
)
