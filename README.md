<!-- badges: start -->

[![R-CMD-check](https://github.com/trickytank/Rwarrior/actions/workflows/check-standard.yaml/badge.svg)](https://github.com/trickytank/Rwarrior/actions/workflows/check-standard.yaml)
[![test-coverage](https://github.com/trickytank/Rwarrior/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/trickytank/Rwarrior/actions/workflows/test-coverage.yaml)
[![Codecov test coverage](https://codecov.io/gh/trickytank/Rwarrior/branch/master/graph/badge.svg)](https://app.codecov.io/gh/trickytank/Rwarrior?branch=master)

<!-- badges: end -->

# R Warrior

Port of [Ruby Warrior](https://github.com/ryanb/ruby-warrior).


## Installation

```
# install.packages("devtools") # If devtools is not installed
devtools::install_github("trickytank/Rwarrior")
```

## Play

Play levels in sequential order. 
Levels implemented so far are from 1 to 3.

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

More advanced levels require either using a non-copy on write object or use of the memory argument to the AI. 

```
AI <- function(warrior, memory) {
      if(is.null(memory)) {
        memory <- list(variable1 = "initial value") # give initial values when memory is NULL
      }
      # Your code goes here #
      # Access memory variable1 with memory$variable1
      # The AI result should be the memory
      return(memory)
    }
```
