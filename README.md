<!-- badges: start -->

[![R-CMD-check](https://github.com/trickytank/Rwarrior/actions/workflows/check-standard.yaml/badge.svg)](https://github.com/trickytank/Rwarrior/actions/workflows/check-standard.yaml)
[![test-coverage](https://github.com/trickytank/Rwarrior/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/trickytank/Rwarrior/actions/workflows/test-coverage.yaml)
[![Codecov test coverage](https://codecov.io/gh/trickytank/Rwarrior/branch/master/graph/badge.svg)](https://app.codecov.io/gh/trickytank/Rwarrior?branch=master)

<!-- badges: end -->

# R Warrior

This is a game designed to teach the R language and artificial intelligence in a fun, interactive way.

You play as a warrior climbing a tall tower to reach the precious Hex at the top level.
On each floor you need to write a R function to instruct the warrior to battle enemies, rescue captives, and reach the stairs. 
You have some idea of what each floor contains, but you never know for certain what will happen. 
You must give the Warrior enough artificial intelligence up-front to find their own way.

This is a port of [Ruby Warrior](https://github.com/ryanb/ruby-warrior).

## Installation

```
# install.packages("devtools") # If devtools is not installed
devtools::install_github("trickytank/Rwarrior", build_vignettes = TRUE)
```

## Play

Play levels in sequential order. 
Levels implemented so far are from 1 to 9.

To play the first level, first read the level readme. 

```
level_readme(1)
```

Use the information gained to write your AI and run `play_warrior()`.

```
AI <- function(warrior, memory) {
      # Your code goes here, can ignore memory for early levels
    }
warrior_name <- "Fisher" # A name for your warrior
    
play_warrior(AI, warrior_name = warrior_name, level = 1)
```

More advanced levels require use of the memory argument to the AI (or use of a reference class). 
The returned value of the AI function is given as the second argument to the next call (on the subsequent turn) of the AI function. 

```
AI <- function(warrior, memory) {
      if(is.null(memory)) {
        # give initial values when memory is NULL
        memory <- list(variable1 = "initial value") 
      }
      # Your code goes here #
      # Access memory variable1 with memory$variable1
      # The AI result should be the memory
      return(memory)
    }
```
