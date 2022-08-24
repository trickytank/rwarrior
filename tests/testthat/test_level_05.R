AI_05 <- function(warrior, memory) {
  if(is.null(memory)) {
    # give initial values when memory is NULL
    memory <- list(previous_health = 20)
  }
  if(warrior$feel()$empty) {
    if(warrior$health < 20) {
      if(warrior$health < memory$previous_health) {
        warrior$walk()
      } else {
        warrior$rest()
      }
    } else {
      warrior$walk()
    }
  } else if (warrior$feel()$captive) {
    warrior$rescue()
  } else {
    warrior$attack()
  }
  memory$previous_health <- warrior$health
  memory
}
