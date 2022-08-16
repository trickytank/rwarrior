#' @import R6
Level_state <- R6Class(
  "Level_state",
  public = list(
    size = NULL,
    npcs = NULL,
    exit = NULL,
    warrior = NULL,
    initialize = function(level_spec) {
      self$npcs <- list()
      for(i in seq_along(level_spec$npcs)) {
        self$npcs[[i]] <- level_spec$npcs[[i]]$clone()
      }
      self$size <- level_spec$size
      self$warrior <- level_spec$warrior$clone()
      self$exit <- level_spec$exit
      invisible(self)
    },
    deep_clone = function() {
      X <- self$clone(deep = TRUE)
      for(i in seq_along(self$npcs)) {
        X$npcs[[i]] <- self$npcs[[i]]$clone()
      }
      X
    },
    is_exit = function(y, x) {
      self$exit[1] == y && self$exit[2] == x
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
      return(NULL)
    },
    feel = function(charac, direction = "forward") {
      coord <- give_coordinates(charac$compass, direction, charac$y, charac$x)
      object <- self$return_object(coord$y_subject, coord$x_subject)
      if(is.null(object)) {
        return(" ")
      } else {
        return(object$symbol)
      }
    },
    attack_routine = function(attacker, defender, direction, sleep = 0) {
      defender$hp <- defender$hp - attacker$attack_power
      message(attacker$name, " attacks ", direction, " and hits ", defender$name, ".")
      Sys.sleep(sleep)
      message(defender$name, " takes ", attacker$attack_power, " damage, ", defender$hp, " health power left.")
      if(defender$hp <= 0 && ! "WARRIOR" %in% class(defender)) {
        # defender is an enemy and has died
        Sys.sleep(sleep)
        points <- defender$max_hp
        message(defender$name, " dies.")
        Sys.sleep(sleep)
        message(attacker$name, " earns ", points, " points.")
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
        level_map[self$exit[1], self$exit[2]] <- ">"
        for(charac in c(list(self$warrior), self$npcs)) {
          if(level_map[charac$y, charac$x] != " " && level_map[charac$y, charac$x] != ">") {
            stop("More than one object at location (", y, ", ", x, ")")
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
    at_exit = function(value) {
      if (missing(value)) {
          self$is_exit(self$warrior$y, self$warrior$x)
        } else {
          stop("Cannot assign at_exit")
        }
    }
  )
)
