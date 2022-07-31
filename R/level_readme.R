#' export
level_readme <- function(level = 1) {
  cat("Level", level, "\n")
  cat(levels[[level]]$description, "\n")
  cat("Tip:", levels[[level]]$tip, "\n")
  for(meth in levels[[level]]$methods) {
    cat("\n")
    method_description(meth)
  }
}

method_description <- function(method) {
  if(method == "walk") {
    cat("- warrior$walk(direction = \"right\")\n")
    cat("  Move the warrior in the given direction, any of:\n")
    cat('    - "right"\n')
    cat('    - "left"\n')
    cat('    - "up"\n')
    cat('    - "down"\n')
  } else if (method == "feel$empty") {
    cat('- warrior$feel$empty\n')
    cat('  Returns TRUE if the space in front is empty or the stairs, and FALSE otherwise.\n')
  } else if (method == "attack") {
    cat('- warrior$attack(direction = "forward")\n')
    cat('  Attack the space in the given direction (foward by default).\n')
  } else if(method == "rest") {
    cat('- warrior$rest()')
    cat('  Rest and heal 10% of the your warrior\'s health.')
  } else if(method == "health") {
    cat('- warrior$health\n')
    cat('  Returns the health of the warrior, up to 20HP.')
  } else {
    stop("Internal error, level has undefined method. (Please report this bug).")
  }
}
