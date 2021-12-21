
hypersnort <- function(data){
  n <- length(data)
  while(n > 1) {
    m <- 0
    for(i in 2:n) {
      if(data[i-1] > data[i]) {
        temp <- data[i]
        data[i] <- data[i-1]
        data[i-1] <- temp
        m <- i
      }
    }
    n <- m
  }
  return(data)
}

froznicator <- function(data){
  sort(data, method=c("quick"))
}

