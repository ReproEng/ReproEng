## SPDX-License-Identifier: MIT-0 

library(ggplot2)
library(reshape2)

noise.level <- as.double(commandArgs(trailingOnly = TRUE)[1])
noise.level

sample.points <- as.integer(commandArgs(trailingOnly = TRUE)[2])

## Generate a discrete sample of function fn on domain [.from, .to]
## with N samples. Returns a data frame with x=input values,
## y=sampled function values
sample.fn <- function(.from, .to, fun=sin, N=1024) {
  res <- data.frame(x=seq(from=.from, to=.to, length.out=N))
  res$y <- fun(res$x)
  
  return(res)
}

## Sample a simple sinus
dat <- sample.fn(0, 2*pi, N=sample.points)

## Augment a data frame with noise that affects computed y values
## (additive uniform noise; other types of noise may appear in real-world
## experiments)
gen.noisy.df <- function(dat, noise.strength=0.2) {
  dat$y.noisy <- dat$y+runif(nrow(dat), -noise.strength, noise.strength)
  return(dat)
}

fn.noisy <- gen.noisy.df(dat, noise.strength=noise.level)

# Write results to stdout
write.csv(fn.noisy[c("x","y.noisy")], stdout(), row.names = FALSE)
