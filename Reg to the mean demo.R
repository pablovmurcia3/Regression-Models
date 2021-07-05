
x <- rnorm(500, 100, 20)
u <- rnorm(500, 50, 60)
y <- 0.5 + 2*x + u

plot(x,y)

# Center the data 

xc <- x - mean(x)
yc <- y - mean(y)

# normal regression vs regression with centered data 
#(regression through the origin) -> THE SAME BETA

coef(lm(y ~ x))[2]
coef(lm(yc ~ xc))[2] # the same than coef(lm(yc ~ xc -1)
coef(lm(yc ~ xc - 1))

# or using the formula...... 

# For centered data (both perform well)
beta1c <- sum(yc * xc) / sum(xc ^ 2)
beta1c <-  cor(yc, xc) * sd(yc) / sd(xc)

# For non centered data (both perform well)
beta1 <- cor(y, x) *  sd(y) / sd(x)


################################################################################

# Regression to the mean 

# Normal model 

coef(lm(y ~ x))[2]

cor(y, x)

library(ggplot2)
g = ggplot(data.frame(x, y), aes(x = x, y = y))
g = g + geom_point(size = 5, alpha = .2, colour = "black")
g = g + geom_point(size = 4, alpha = .2, colour = "red")
g = g + geom_abline(intercept = coef(lm(y ~ x))[1], slope = coef(lm(y ~ x))[2]
                    , size = 2)
g = g + xlab("X") + ggtitle(paste("beta = ", coef(lm(y ~ x))[2]))
g = g + ylab("Y")
g # we can see that the BETA es more than 1




# Standarized model 


ys <- (y - mean(y)) / sd(y)
xs <- (x - mean(x)) / sd(x)

coef(lm(ys ~ xs))

cor(ys, xs)


gs = ggplot(data.frame(xs, ys), aes(x = xs, y = ys))
gs = gs + geom_point(size = 5, alpha = .2, colour = "black")
gs = gs + geom_point(size = 4, alpha = .2, colour = "red")
gs = gs + geom_vline(xintercept = 0)
gs = gs + geom_hline(yintercept = 0)
gs = gs + geom_abline(position = "identity")
gs = gs + geom_abline(intercept = 0, slope = cor(ys, xs), size = 2)
gs = gs + xlab("X") + ggtitle(paste("beta = ", coef(lm(ys ~ xs))[2]))
gs = gs + ylab("Y")
gs


# In the original model the BETA was > 1 but, when we standarized the variables, 
# beta becames the correlation coeff (< 1). In this sense, the regression to the 
# mean is present.

# The trick is to think in relative terms 

####### The fact is that the variable regress to IT´S mean (in relative (sd)
# terms )    #######

xf <- 1:500
yf <- coef(lm(y ~ x))[1] + coef(lm(y ~ x))[2]*xf


xfs <- 1:500
yfs <- coef(lm(ys ~ xs))[1] + coef(lm(ys ~ xs))[2]*xfs


look <- data.frame(xf,yf,xfs,yfs)
yf[2]- yf[1]
yfs[2]- yfs[1]
