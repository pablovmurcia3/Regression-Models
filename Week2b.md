---
title: "week2b"
output: 
  html_document: 
    keep_md: yes
---



**Inference in regression & predictions** 
==============

## **Recall our model and fitted values**

* Consider the model

$$
Y_i = \beta_0 + \beta_1 X_i + \epsilon_i
$$

* $\epsilon \sim N(0, \sigma^2)$. 
* We assume that the true model is known.
* $\hat \beta_0 = \bar Y - \hat \beta_1 \bar X$
* $\hat \beta_1 = Cor(Y, X) \frac{Sd(Y)}{Sd(X)}$.


## **Review**
* Statistics like $\frac{\hat \theta - \theta}{\hat \sigma_{\hat \theta}}$ often have the following properties:
   
    1. Is normally distributed and has a finite sample Student's T distribution if the  variance is replaced with a sample estimate (under normality assumptions).
    2. Can be used to test $H_0 : \theta = \theta_0$ versus $H_a : \theta >, <, \neq \theta_0$.
    3. Can be used to create a confidence interval for $\theta$ via $\hat \theta \pm Q_{1-\alpha/2} \hat \sigma_{\hat \theta}$
    where $Q_{1-\alpha/2}$ is the relevant quantile from either a normal or T distribution.
         
* In the case of regression with iid sampling assumptions and normal errors, our inferences will follow very similarily to what you saw in your inference class.
      
* We won't cover asymptotics for regression analysis, but **suffice it to say that under assumptions  on the ways in which the $X$ values are collected, the iid sampling model, and mean model,  the normal results hold to create intervals and confidence intervals**

## **Variance of regression slope**


* $\sigma_{\hat \beta_1}^2 = Var(\hat \beta_1) = \sigma^2 / \sum_{i=1}^n (X_i - \bar X)^2$

* **This is the standard error**

numerator: Variance of the noise in direct relationship with variance of betas
Denominator: Better to have a big variance of the variable. 

* $\sigma_{\hat \beta_0}^2 = Var(\hat \beta_0)  = \left(\frac{1}{n} + \frac{\bar X^2}{\sum_{i=1}^n (X_i - \bar X)^2 }\right)\sigma^2$

* In practice, $\sigma$ is replaced by its estimate. (the variance of the residuals)

* It's probably not surprising that under iid Gaussian errors

$$
\frac{\hat \beta_j - \beta_j}{\hat \sigma_{\hat \beta_j}}
$$

follows a $t$ distribution with $n-2$ degrees of freedom and a normal distribution for large $n$.

* This can be used to create confidence intervals and perform
hypothesis tests.


## **Code example**


```r
library(UsingR)
```

```
## Warning: package 'UsingR' was built under R version 4.0.5
```

```
## Warning: package 'HistData' was built under R version 4.0.5
```

```r
library(ggplot2)
library(reshape2)
library(manipulate)
library(dplyr)
data(diamond)
```



Let??s get the standard deviation of the coefficients 


```r
y <- diamond$price; x <- diamond$carat; n <- length(y)

beta1 <- cor(y, x) * sd(y) / sd(x)

beta0 <- mean(y) - beta1 * mean(x)

e <- y - beta0 - beta1 * x

sigma <- sqrt(sum(e^2) / (n-2))

ssx <- sum((x - mean(x))^2) #Variance of variable..

seBeta0 <- (1 / n + mean(x) ^ 2 / ssx) ^ .5 * sigma 

seBeta1 <- sigma / sqrt(ssx) #Standard error of beta

tBeta0 <- beta0 / seBeta0; tBeta1 <- beta1 / seBeta1 #Create the tw0 t statistics ... with Ho=0 

pBeta0 <- 2 * pt(abs(tBeta0), df = n - 2, lower.tail = FALSE)
pBeta1 <- 2 * pt(abs(tBeta1), df = n - 2, lower.tail = FALSE)


coefTable <- rbind(c(beta0, seBeta0, tBeta0, pBeta0), c(beta1, seBeta1, tBeta1, pBeta1))

colnames(coefTable) <- c("Estimate", "Std. Error", "t value", "P(>|t|)")
rownames(coefTable) <- c("(Intercept)", "x")

coefTable
```

```
##              Estimate Std. Error   t value      P(>|t|)
## (Intercept) -259.6259   17.31886 -14.99094 2.523271e-19
## x           3721.0249   81.78588  45.49715 6.751260e-40
```


We can do the same in a easier manner


```r
fit <- lm(y ~ x); 
summary(fit)$coefficients
```

```
##              Estimate Std. Error   t value     Pr(>|t|)
## (Intercept) -259.6259   17.31886 -14.99094 2.523271e-19
## x           3721.0249   81.78588  45.49715 6.751260e-40
```


Let??s get the confidence intervals 



```r
sumCoef <- summary(fit)$coefficients
sumCoef[1,1] + c(-1, 1) * qt(.975, df = fit$df) * sumCoef[1, 2]
```

```
## [1] -294.4870 -224.7649
```

```r
(sumCoef[2,1] + c(-1, 1) * qt(.975, df = fit$df) * sumCoef[2, 2]) / 10
```

```
## [1] 355.6398 388.5651
```

## **Predictions**


* Consider predicting $Y$ at a value of $X$
  * Predicting the price of a diamond given the carat
  * Predicting the height of a child given the height of the parents
* The obvious estimate for prediction at point $x_0$ is 

$$
\hat \beta_0 + \hat \beta_1 x_0
$$

* A **standard error** is needed to create a prediction interval.

* *There's a distinction between intervals for the regression line at point $x_0$ and the prediction of what a $y$ would be at point $x_0$.*
  
* Line at $x_0$ se, $\hat \sigma\sqrt{\frac{1}{n} +  \frac{(x_0 - \bar X)^2}{\sum_{i=1}^n (X_i - \bar X)^2}}$

*If we take the job of collecting more data, the equation will decrease. In this sense we are more secure about our estimation of the line*


* Prediction interval se at $x_0$, $\hat \sigma\sqrt{1 + \frac{1}{n} + \frac{(x_0 - \bar X)^2}{\sum_{i=1}^n (X_i - \bar X)^2}}$

*Because the Y has some variability that is not explained by the model, we can??t easily decrease the equation by collecting more data. This is expresed by the 1.*




```r
newx = data.frame(x = seq(min(x), max(x), length = 100))
p1 = data.frame(predict(fit, newdata= newx,interval = ("confidence")))
p2 = data.frame(predict(fit, newdata = newx,interval = ("prediction")))
p1$interval = "confidence"
p2$interval = "prediction"
p1$x = newx$x
p2$x = newx$x
dat = rbind(p1, p2)
names(dat)[1] = "y"
g = ggplot(dat, aes(x = x, y = y))
g = g + geom_ribbon(aes(ymin = lwr, ymax = upr, fill = interval), alpha = 0.2) 
g = g + geom_line()
g = g + geom_point(data = data.frame(x = x, y=y), aes(x = x, y = y), size = 4)
g
```

![](Week2b_files/figure-html/y5-1.png)<!-- -->
## **Discussion**

* Both intervals have varying widths.
  * Least width at the mean of the Xs.
  
* We are quite confident in the regression line, so that 
  interval is very narrow.
  
  * If we knew $\beta_0$ and $\beta_1$ this interval would have zero width.
  
* The prediction interval must incorporate the variabilibity
  in the data around the line.
  
  * Even if we knew $\beta_0$ and $\beta_1$ this interval would still have width.
