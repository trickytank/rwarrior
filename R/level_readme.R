#' export
level_readme <- function(level = 1) {
  cat("Level", level, "\n")
  cat(Level_state$new(levels[[level]])$ascii, "\n")
  cat(levels[[level]]$description, "\n")
  cat("Tip:", levels[[level]]$tip, "\n\n")
  method_description(levels[[level]]$warrior)
}

method_description <- function(warrior) {
  if(warrior$walk) {
    cat("- warrior$walk(direction = \"forward\")\n")
    cat("  Move the warrior in the given direction, any of:\n")
    cat('    - "forward"\n')
    cat('    - "backward"\n')
  }
  if(warrior$feel) {
    cat('- warrior$feel$empty\n')
    cat('  Returns TRUE if the space in front is empty or the stairs, and FALSE otherwise.\n')
  }
  if(warrior$attack) {
    cat('- warrior$attack(direction = "forward")\n')
    cat('  Attack the space in the given direction (foward by default).\n')
  }
  if(warrior$rest) {
    cat('- warrior$rest()\n')
    cat('  Rest and heal 10% of the your warrior\'s health.')
  }
  if(warrior$health) {
    cat('- warrior$health\n')
    cat('  Returns the health of the warrior, up to 20HP.')
  }
}
