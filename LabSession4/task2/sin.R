## SPDX-License-Identifier: MIT-0 

library(ggplot2)
library(reshape2)

sample.fn <- function(.from, .to, fun=sin, N=1024) {
    res <- data.frame(x=seq(from=.from, to=.to, length.out=N))
    res$y <- fun(res$x)

    return(res)
}

dat <- sample.fn(0, 2*pi)

ggplot(dat, aes(x=x,y=y)) + geom_point(size=0.1)


gen.noisy.df <- function(dat, noise.strength=0.2) {
    dat$y.noisy <- dat$y+runif(nrow(dat), -noise.strength, noise.strength)
    return(dat)
}


head(gen.noisy.df(dat))

dat.molten <- melt(gen.noisy.df(dat), id.vars=c("x"))
ggplot(dat.molten, aes(x=x, y=value, colour=variable)) + geom_point(size=0.1)

cor(dat$y, gen.noisy.df(dat)$y.noisy)

gen.cor.seq <- function(dat, noise.values) {
    return(do.call(rbind, lapply(noise.values, function(noise) {
        return(data.frame(noise=noise, correlation=cor(dat$y, gen.noisy.df(dat, noise)$y.noisy)))
    })))
}

res.noise <- gen.cor.seq(dat, seq(from=0.1, to=1.5, length.out=25))
ggplot(res.noise, aes(x=noise, y=correlation)) + geom_point()


ggplot(melt(gen.noisy.df(dat, 0.1), id.vars=c("x")),
       aes(x=x, y=value, colour=variable)) + geom_point(size=0.2)

gen.noisy.df.fun <- function(dat, fn=cos) {
    dat$y.noisy <- fn(dat$x)
    return(dat)
}

ggplot(melt(gen.noisy.df.fun(dat, function(x) {sin(x-0.1*pi)}),
            id.vars=c("x")), aes(x=x, y=value, colour=variable)) + geom_point(size=0.1)

cor(dat$y, gen.noisy.df.fun(dat, function(x) {sin(x-0.1*pi)})$y.noisy)

