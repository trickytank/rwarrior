% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/play_warrior.R
\name{play_warrior}
\alias{play_warrior}
\title{Play R Warrior}
\usage{
play_warrior(
  ai,
  level = 1,
  tower = c("beginner"),
  warrior_name = "Fisher",
  sleep = getOption("rwarrior.sleep", ifelse(interactive(), 0.6, 0)),
  practice = FALSE
)
}
\arguments{
\item{ai}{AI function to control your warrior.}

\item{level}{Level number.}

\item{tower}{Tower the level comes from.}

\item{warrior_name}{Name of your warrior, for flavor.}

\item{sleep}{Time between text updates in seconds. Set to "prompt" to only progress when pressing the return key.}

\item{practice}{If TRUE, any functions available for that tower may be used.}
}
\value{
A tibble if successful, FALSE if unsuccessful,
        and NA if the AI function caused an error or no action was called.
}
\description{
Attempt inbuilt levels of R Warrior.
}
\examples{
AI <- function(warrior, memory) {
  if(is.null(memory)) {
    # set memory initial values here
  }
  # insert AI code here
  memory
}
play_warrior(AI, level = 1)
}
