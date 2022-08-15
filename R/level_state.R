#' @import R6
Level_state <- R6Class(
  "Level_state",
  public = list(
    size = NULL,
    npcs = NULL,
    exit = NULL,
    warrior = NULL,
    initialize = function(level_spec) {
      self$npcs <- level_spec$npcs
      self$size <- level_spec$size
      self$warrior <- level_spec$warrior
      self$exit <- level_spec$exit
      invisible(self)
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
      return(NA)
    },
    feel = function(direction = "forward") {
      coord <- give_coordinates(self$warrior$compass, direction, self$warrior$y, self$warrior$x)
      object <- private$level_state$return_object(coord$y_subject, coord$x_subject)
      if(is.na(object)) {
        return(" ")
      } else {
        return(object$symbol)
      }
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
        tpmatrix <- matrix(rep("—", self$size[2] + 2L), nrow = 1)
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
