# 1
x <- c(0.61, 0.93, 0.83, 0.35, 0.54, 0.16, 0.91, 0.62, 0.62)
y <- c(0.67, 0.84, 0.6, 0.18, 0.85, 0.47, 1.1, 0.65, 0.36)

fit <- lm(y ~ x)

beta <- summary(fit)$coefficients[2,1]
sebeta <- summary(fit)$coefficients[2,2]
pbeta <- summary(fit)$coefficients[2,4]

#Manual ######################################################################
e <- resid(fit)
n<- length(y)
sigma <- sqrt(sum(e^2) / (n-2))
ssx <- sum((x - mean(x))^2) #Variance of variable..
seBeta1 <- sigma / sqrt(ssx)
#Manual ######################################################################

tstat <- beta/sebeta
pstat <- 2 * pt(abs(tstat), n-2, lower.tail = FALSE)


#2

sigma <- sqrt(sum(e^2) / (n-2))



#3

data(mtcars)

fit <- lm(mpg ~ I(wt - mean(wt)), data = mtcars)


summary(fit)

sumCoef <- summary(fit)$coefficients
sumCoef[1,1] - qt(0.025, fit$df, lower.tail = FALSE) * sumCoef[1,2] 


#4 

?mtcars

#5 

fit <- lm(mpg ~ wt, data = mtcars)

e <- resid(fit)
n <- length(y)
sigma <- sqrt(sum(e^2) / (n-2))
VarX <- sum((mtcars$wt - mean(mtcars$wt))^2)
se <- sigma*(sqrt(1 + 1/n + ((3000-mean(mtcars$wt))^2 /VarX)))

sumCoef <- summary(fit)$coefficients
3 - qt(0.025, fit$df, lower.tail = FALSE) * se


newx <- data.frame(wt = c(3))
predict(fit, newdata = newx, interval = ("prediction"))


#6
fit <- lm(mpg ~ I(wt/2), data = mtcars)
sumCoef <- summary(fit)$coefficients


sumCoef[2,1] - qt(0.025, fit$df, lower.tail = FALSE) * sumCoef[2,2]

# 7
x <- c(0.61, 0.93, 0.83, 0.35, 0.54, 0.16, 0.91, 0.62, 0.62)
y <- c(0.67, 0.84, 0.6, 0.18, 0.85, 0.47, 1.1, 0.65, 0.36)
z <- rep(2,length(x))

fit <- lm(y ~ x + z)
sumCoef <- summary(fit)$coefficients
fit <- lm(y ~ x)
sumCoef <- summary(fit)$coefficients



# 9

fit <- lm(mpg ~ 1, data = mtcars)
e <- resid(fit)


deviance(fit)


fit1 <- lm(mpg ~ wt, data = mtcars)
deviance(fit1)


deviance(fit1)/deviance(fit)
