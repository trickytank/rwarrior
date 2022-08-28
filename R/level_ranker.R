#' @importFrom dplyr case_when
level_ranker <- function(score, ace_score) {
  perc <- score / ace_score * 100
  case_when(
    perc >= 100 ~ "S",
    perc >= 90  ~ "A",
    perc >= 80  ~ "B",
    perc >= 70  ~ "C",
    perc >= 69  ~ "D",
    perc >= 59  ~ "E",
    TRUE        ~ "F"
  )
}
