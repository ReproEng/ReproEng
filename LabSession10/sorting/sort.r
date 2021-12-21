library(rhdf5)
library(dplyr)
library(stringr)
library(ggplot2)

source("sortr.r")

create.file <- function(file) {
  h5createFile(file)
  h5createGroup(file, "vis")
  h5createGroup(file, "meas")
  
  h5createGroup(file, "meas/hypersnort")
  h5createGroup(file, "meas/froznicator")
}

perform.measurement <- function(file, algorithm, dataset, size) {
  data <- str_c("data/", dataset, "_", size, ".csv")
  dat <- read.csv(data)
  if (algorithm == "hypersnort") {
    rt <- system.time(hypersnort(dat$value))
  } else if (algorithm == "froznicator") {
    rt <- system.time(froznicator(dat$value))
  }
  return(c(size, rt["elapsed"]))
  #h5write(as.matrix(dat), file, str_c("/meas/", algorithm, "/", dataset))
}
write.measurement <- function(file, algorithm, dataset, size) {
  h5write(as.matrix(dat), file, str_c("/meas/", algorithm, "/", dataset))
}

read.data <- function(file, algorithm, dataset) {
  name <- str_c("meas/", algorithm, "/", dataset)
  dat <- data.frame(h5read(file, name=name))
  colnames(dat) <- as.list(h5readAttributes(file, name=name)$columns)
  
  dat$algorithm  <- algorithm
  dat$dataset  <- dataset
  
  return(dat)
}

#################################################################
create.file("repeng.h5")
h5closeAll()
file <- "repeng.h5"
#h5ls("repeng.h5")

alg <- c("froznicator", "hypersnort")
ds <- c("foo", "βαρ", "baz")

froz.rt.foo <- data.frame()
froz.rt.bar <- data.frame()
froz.rt.baz <- data.frame()
hype.rt.foo <- data.frame()
hype.rt.bar <- data.frame()
hype.rt.baz <- data.frame()

for (n in 1:20) {
  froz.rt.foo <- rbind(froz.rt.foo, perform.measurement("repeng.h5", "froznicator", "foo", n*250))
  froz.rt.bar <- rbind(froz.rt.bar, perform.measurement("repeng.h5", "froznicator", "βαρ", n*250))
  froz.rt.baz <- rbind(froz.rt.baz, perform.measurement("repeng.h5", "froznicator", "baz", n*250))
  hype.rt.foo <- rbind(hype.rt.foo, perform.measurement("repeng.h5", "hypersnort", "foo", n*250))
  hype.rt.bar <- rbind(hype.rt.bar, perform.measurement("repeng.h5", "hypersnort", "βαρ", n*250))
  hype.rt.baz <- rbind(hype.rt.baz, perform.measurement("repeng.h5", "hypersnort", "baz", n*250))
}

h5write(as.matrix(froz.rt.foo), file, str_c("/meas/", "froznicator", "/", "foo"))
h5write(as.matrix(froz.rt.bar), file, str_c("/meas/", "froznicator", "/", "βαρ"))
h5write(as.matrix(froz.rt.baz), file, str_c("/meas/", "froznicator", "/", "baz"))
h5write(as.matrix(hype.rt.foo), file, str_c("/meas/", "hypersnort", "/", "foo"))
h5write(as.matrix(hype.rt.bar), file, str_c("/meas/", "hypersnort", "/", "βαρ"))
h5write(as.matrix(hype.rt.baz), file, str_c("/meas/", "hypersnort", "/", "baz"))
h5closeAll()
fid <- H5Fopen("repeng.h5")

for (a in alg) {
  for (d in ds) {
    alg.gid <- H5Gopen(fid, "/meas/froznicator/")
    h5writeAttribute(attr="x86", h5obj=alg.gid, name="architecture")
    path <- str_c("/meas/", a, "/", d)
    print(path)
    ds.gid <- H5Dopen(alg.gid, path)
    h5writeAttribute(attr="2021-11-12 23:57:12", h5obj=ds.gid, name="time")
    h5writeAttribute(attr=as.matrix(c("size", "runtime")), h5obj=ds.gid, name="columns")
  }
}


dat <- do.call(rbind, lapply(c("foo", "βαρ", "baz"), function(dataset) {
  read.data("repeng.h5", "froznicator", dataset)
}))

dat2 <- do.call(rbind, lapply(c("foo", "βαρ", "baz"), function(dataset) {
  read.data("repeng.h5", "hypersnort", dataset)
}))
h5closeAll()

dat <- rbind(dat, dat2)

head(dat)
ggplot(dat, aes(x=size, y=runtime)) + geom_point(aes(shape=dataset, colour=algorithm))

ggplot(dat, aes(x=size, y=runtime, colour=algorithm)) + geom_point() +
  facet_wrap(~dataset, scales="free_y")