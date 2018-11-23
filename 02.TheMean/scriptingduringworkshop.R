2+2
(2+3+4+5)/4
a <- 1
b = 2

mydata <- c(2,3,4,5)

mydata*2

mydata <- rnorm(n = 10)

mydata

mydata[5]

mydata[c(1,5)] <- 35
mydata

mydata <- c(1,"text", 2)
mydata <- c(1,2.565, 2)
mydata

as.integer(2.565656)
as.integer(as.factor("textte"))

1:10
25:-10

mydata

mean(x = mydata)
mean(mydata)

tree <- read.csv("trees.csv")
View(tree)
head(tree)
tail(tree)
str(tree)


tree[2,2]
tree[,2]
tree[,"Girth"]
tree$Girth

nrow(tree)
mean(tree[-c(20,28,5), "Girth"])
tree[-seq(from=1,to=nrow(tree), by = 2),"Girth"]

tree <- tree[,-5]
tree$girth <- 0
for(i in 1:31)
{
  tree$means[i] <- mean(as.numeric(tree[i,]))
}
tree$means


mymeans <- vector(length = nrow(tree))
for(i in 1:31)
{
  mymeans[i] <- mean(as.numeric(tree[i,]))
}
mymeans


rocks <- read.csv("rock.csv")

mean(rocks[,1])

mymeans <- vector(length = ncol(rocks))
for(i in 1:ncol(rocks))
{
  mymeans[i] <- mean(rocks[,i])
}
mymeans

mymeans <- apply(X = rocks[,1:2], MARGIN = 2, FUN = mean)

mymeans <- colMeans(rocks)

mymeans

.Last.value
rowMeans(rock[rep(1:nrow(rock),50000),])
mymeans <- .Last.value
