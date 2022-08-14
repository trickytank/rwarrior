#' @import R6
Level_state <- R6Class(
  "Level_state",
  public = list(
    map = NULL,
    size = NULL,
    npcs = NULL,
    exit = NULL,
    warrior = NULL,
    initialize = function(level_spec) {
      self$npcs <- level_spec$npcs
      self$size <- level_spec$size
      self$warrior <- level_spec$warrior
      invisible(self)
    }
  ),
  active = list(
    x = function(value) {
      if (missing(value)) {
        which(self$map == "@", arr.ind = TRUE)[1, 2]
      } else {
        stop("Cannot assign X")
      }
    },
    y = function(value) {
      if (missing(value)) {
        which(self$map == "@", arr.ind = TRUE)[1, 1]
      } else {
        stop("Cannot assign Y")
      }
    },
    ascii = function(value) {
      if (missing(value)) {
        lines <- ""
        level_map <- matrix(" ", nrow = self$size[1], ncol = self$size[2])
        for(charac in c(list(self$warrior), self$npcs)) {
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
    closeby_enemies = function(value) {
      if (missing(value)) {
        enemies <- c()
        if(self$map[self$y, self$x + 1] %in% names(enemy_types)) {
          enemies <- c(enemies, self$map[self$y, self$x + 1])
        }
        if(self$map[self$y, self$x - 1] %in% names(enemy_types)) {
          enemies <- c(enemies, self$map[self$y, self$x - 1])
        }
        if(self$map[self$y + 1, self$x] %in% names(enemy_types)) {
          enemies <- c(enemies, self$map[self$y + 1, self$x])
        }
        if(self$map[self$y - 1, self$x] %in% names(enemy_types)) {
          enemies <- c(enemies, self$map[self$y - 1, self$x])
        }
        enemies
      } else {
        stop("Cannot assign closeby_enemies")
      }
    }
  )
)
