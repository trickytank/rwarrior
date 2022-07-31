#' @import R6
Level_state <- R6Class(
  "Level_state",
  public = list(
    map = NULL,
    hp = NULL,
    initialize = function(level_map) {
      d <- dim(level_map)
      if(is.null(level_map)) {
        stop("No map is definied (this is a bug).")
      }
      tpmatrix <- matrix(c(" ", rep("—", d[2]), " "), nrow = 1)
      sidematrix <- matrix(rep("|", d[1]))
      self$map <- rbind(tpmatrix,
                        cbind(sidematrix, level_map, sidematrix),
                        tpmatrix)
      self$hp <- matrix(rep(NA_integer_, nrow(self$map) * ncol(self$map)), nrow = nrow(self$map), ncol = ncol(self$map))
      self$hp[self$map == "s"] <- 12L
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
        for(i in seq_len(nrow(self$map))) {
          lines <- paste0(lines, paste0(self$map[i, ], collapse = ""), "\n")
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
