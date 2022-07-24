# Level object generator

# Level generator:
# ' ' : empty space
# '@' : warrior
# '>' : exit
# 's' : sludge
create_level <- function(level_string) {
  x <- strsplit(level_string, "")[[1]]
  structure(x, class = "level")
}
