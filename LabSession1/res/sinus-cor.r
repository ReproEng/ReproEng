## R 101:
## * Variables are vectors by default
## * Standard data structure is a data frame ("table" with names columns and rows)
## * <- is used for assignment
## * assignments in function definitions set standard values

library(ggplot2)
library(reshape2)

## Generate a discrete sample of function fn on domain [.from, .to]
## with N samples. Returns a data frame with x=input values,
## y=sampled function values
sample.fn <- function(.from, .to, fun=sin, N=1024) {
    res <- data.frame(x=seq(from=.from, to=.to, length.out=N))
    res$y <- fun(res$x)

    return(res)
}

## Sample a simple sinus
dat <- sample.fn(0, 2*pi)

## and visualise the result.
## ggplot 101:
## * First argument gives the data frame to plot
## * aes sets which variables in the data frame are mapped to which aesthetic
##   property (here: x and y coordinate, but could also be colour, see below)
## * geom_point instructs to plot individual points 
ggplot(dat, aes(x=x,y=y)) + geom_point(size=0.1)


## Augment a data frame with noise that affects computed y values
## (additive uniform noise; other types of noise may appear in real-world
## experiments)
gen.noisy.df <- function(dat, noise.strength=0.2) {
    dat$y.noisy <- dat$y+runif(nrow(dat), -noise.strength, noise.strength)
    return(dat)
}

## Let's inspect the influence of the noise on the numerical values
head(gen.noisy.df(dat))

## ... and visualise the differences between noisy and perfect measurement
## (the melt step is here to transform data from a wide to a long representation;
## this eases plotting, but is not essential for our purposes)
dat.molten <- melt(gen.noisy.df(dat), id.vars=c("x"))
ggplot(dat.molten, aes(x=x, y=value, colour=variable)) + geom_point(size=0.1)

## The "similarity" between two measurements may be quantified with the Pearson
## correlation, of course with the perils discussed in the lecture.
## NOTE: When you run this calculation multiple times, derived correlation
## values will differ in subsequent runs because the stochastis noise is
## re-generated on each call
cor(dat$y, gen.noisy.df(dat)$y.noisy)

## Systematically study the correlation value with increasing amounts of noise
gen.cor.seq <- function(dat, noise.values) {
    return(do.call(rbind, lapply(noise.values, function(noise) {
        return(data.frame(noise=noise, correlation=cor(dat$y, gen.noisy.df(dat, noise)$y.noisy)))
    })))
}

res.noise <- gen.cor.seq(dat, seq(from=0.1, to=1.5, length.out=25))
ggplot(res.noise, aes(x=noise, y=correlation)) + geom_point()


## Visually inspect the action of different noise levels
ggplot(melt(gen.noisy.df(dat, 0.1), id.vars=c("x")),
       aes(x=x, y=value, colour=variable)) + geom_point(size=0.2)



## Another type of "noise" (in a general sense) may cause the characteristics of
## the measured function to change from the original observation.
## This functions augments a given sampling dataframe with "functional" noise.
gen.noisy.df.fun <- function(dat, fn=cos) {
    dat$y.noisy <- fn(dat$x)
    return(dat)
}

## Visualise orginal function and shifted "reproduction"
ggplot(melt(gen.noisy.df.fun(dat, function(x) {sin(x-0.1*pi)}),
            id.vars=c("x")), aes(x=x, y=value, colour=variable)) + geom_point(size=0.1)

## Compute the quantitative correlation for this type of "noise"
## (it is instructive to visualise for which shifts the correlation value turns negative)
cor(dat$y, gen.noisy.df.fun(dat, function(x) {sin(x-0.1*pi)})$y.noisy)
