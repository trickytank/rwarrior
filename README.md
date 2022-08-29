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

Use the information gained to write your AI and run `play_beginner()`.

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

## Scoring

Your objective is to not only reach the stairs, but to get the highest score you can. 
There are many ways you can earn points on a level.

* defeat an enemy to add his max health to your score
* rescue a captive to earn 20 points
* pass the level within the bonus time to earn the amount of bonus time remaining
* defeat all enemies and rescue all captives to receive a 20% overall bonus

Don't be too concerned about scoring perfectly in the beginning. 
After you reach the top of the tower you will be able to re-run the tower and fine-tune your warrior to get the highest score. 
See the Epic Mode below for details.

## Epic Mode 

Once you have completed the beginner levels, it is time to take on all the levels with 
one AI in epic mode! 
Optimise your AI to get S rank in all the levels of the tower.

```
play_epic(AI)
```
