---
title: "Week 1a"
output: 
  html_document: 
    keep_md: yes
---


**Week 1** 
==============

## **Notation**

* We write $X_1, X_2, \ldots, X_n$ to describe $n$ data points.
* As an example, consider the data set $\{1, 2, 5\}$ then 
  * $X_1 = 1$, $X_2 = 2$, $X_3 = 5$ and $n = 3$.
* We often use a different letter than $X$, such as $Y_1, \ldots , Y_n$.
* We will typically use Greek letters for things we don't know. 
  Such as, $\mu$ is a mean that we'd like to estimate.
  
### **Empirical mean**
  
* Define the empirical mean as
$\bar X = \frac{1}{n}\sum_{i=1}^n X_i.$
* Notice if we subtract the mean from data points, we get data that has mean 0. That is, if we define $\tilde X_i = X_i - \bar X.$
The mean of the $\tilde X_i$ is 0.
* This process is called **"centering"** the random variables.

* Recall from the previous lecture that the mean is 
  the least squares solution for minimizing
  $$
  \sum_{i=1}^n (X_i - \mu)^2
  $$
  
### **The empirical standard deviation and variance**

* Define the empirical variance as 
$$
S^2 = \frac{1}{n-1} \sum_{i=1}^n (X_i - \bar X)^2 
= \frac{1}{n-1} \left( \sum_{i=1}^n X_i^2 - n \bar X ^ 2 \right)
$$
* The empirical standard deviation is defined as
$S = \sqrt{S^2}$. Notice that the standard deviation has the same units as the data.
* The data defined by $X_i / s$ have empirical standard deviation 1. This is called **"scaling"** the data.
  
### **Normalization**

* The data defined by
$$
Z_i = \frac{X_i - \bar X}{s}
$$
have empirical mean zero and empirical standard deviation 1. 
* The process of centering then scaling the data is called **"normalizing"** the data. 
* *It´s main use is making two data distributions comparable*
* Normalized data are centered at 0 and have units equal to standard deviations of the original data. 
* Example, a value of 2 from normalized data means that data point
was two standard deviations larger than the mean.

  
### **The empirical covariance**
* Consider now when we have pairs of data, $(X_i, Y_i)$.
* Their empirical covariance is 
$$
Cov(X, Y) = 
\frac{1}{n-1}\sum_{i=1}^n (X_i - \bar X) (Y_i - \bar Y)
= \frac{1}{n-1}\left( \sum_{i=1}^n X_i Y_i - n \bar X \bar Y\right)
$$
* The correlation is defined is
$$
Cor(X, Y) = \frac{Cov(X, Y)}{S_x S_y}
$$
where $S_x$ and $S_y$ are the estimates of standard deviations 
for the $X$ observations and $Y$ observations, respectively.

**The correlation is the standardization of the covariance into unitless quantity* 


### **Some facts about correlation**   

* $Cor(X, Y) = Cor(Y, X)$
* $-1 \leq Cor(X, Y) \leq 1$
* $Cor(X,Y) = 1$ and $Cor(X, Y) = -1$ only when the $X$ or $Y$ observations fall perfectly on a positive or negative sloped line, respectively.
* $Cor(X, Y)$ measures the strength of the linear relationship between the $X$ and $Y$ data, with stronger relationships as $Cor(X,Y)$ heads towards -1 or 1.
* $Cor(X, Y) = 0$ implies no linear relationship.

  
## **Linear least square** 

### **Fitting the best line** 

Use least squares to find the best line (Least squares is a **criteria** to determine the best fitting line)*

$$
  \sum_{i=1}^n \{Y_i - (\beta_0 + \beta_1 X_i)\}^2
$$

The estimated values of the parameters (betas) are:
$$\hat \beta_1 = Cor(Y, X) \frac{Sd(Y)}{Sd(X)} ~~~ \hat \beta_0 = \bar Y - \hat \beta_1 \bar X$$

* $\hat \beta_1$ has the units of $Y / X$ (cor is unitless.. sdy has the units of y and sdx has the units of x)

* $\hat \beta_0$ has the units of $Y$.

* The slope of the regression line with $X$ as the outcome and $Y$ as the predictor is $Cor(Y, X) Sd(X)/ Sd(Y)$. (*you get a different answer*)

* If you center your Xs and Ys first, then the line will pass
through the origin. The slope is the same one you would get if you centered the data, $(X_i - \bar X, Y_i - \bar Y)$, and did regression through the origin.

* If you normalized the data, $\{ \frac{X_i - \bar X}{Sd(X)}, \frac{Y_i - \bar Y}{Sd(Y)}\}$, the slope is $Cor(Y, X)$.


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
```


Probe that our formulas are right


```r
library(UsingR)
data(galton)

y <- galton$child
x <- galton$parent
beta1 <- cor(y, x) *  sd(y) / sd(x)
beta0 <- mean(y) - beta1 * mean(x)
rbind(c(beta0, beta1), coef(lm(y ~ x)))
```

```
##      (Intercept)         x
## [1,]    23.94153 0.6462906
## [2,]    23.94153 0.6462906
```

```r
# We can reverse the relationship
beta1 <- cor(y, x) *  sd(x) / sd(y)
beta0 <- mean(x) - beta1 * mean(y)

rbind(c(beta0, beta1), coef(lm(x ~ y)))
```

```
##      (Intercept)         y
## [1,]    46.13535 0.3256475
## [2,]    46.13535 0.3256475
```

Now let’s show that regression through the origin yields an equivalent slope if you center the data first


```r
yc <- y - mean(y)
xc <- x - mean(x)
beta1 <- sum(yc * xc) / sum(xc ^ 2) # the formula that we can use if the data is centered
c(beta1, coef(lm(y ~ x))[2])
```

```
##                   x 
## 0.6462906 0.6462906
```

```r
# Regression through the origin
lm(yc ~ xc-1) 
```

```
## 
## Call:
## lm(formula = yc ~ xc - 1)
## 
## Coefficients:
##     xc  
## 0.6463
```
If we normalize the variables the slope would be the correlation.. 


```r
yn <- (y - mean(y))/sd(y)
mean(yn)
```

```
## [1] 2.183943e-16
```

```r
sd(yn)
```

```
## [1] 1
```

```r
xn <- (x - mean(x))/sd(x) # can be interpreted as standard deviation from the mean
mean(xn)
```

```
## [1] 5.501733e-16
```

```r
sd(xn)
```

```
## [1] 1
```

```r
c(cor(y, x), cor(yn, xn), coef(lm(yn ~ xn))[2])
```

```
##                            xn 
## 0.4587624 0.4587624 0.4587624
```
  
  
Add the regression line to ggplot


```r
freqData <- as.data.frame(table(galton$child, galton$parent))
names(freqData) <- c("child", "parent", "freq")
freqData$child <- as.numeric(as.character(freqData$child))
freqData$parent <- as.numeric(as.character(freqData$parent))

g <- ggplot(filter(freqData, freq > 0), aes(x = parent, y = child))
g <- g  + scale_size(range = c(2, 20), guide = "none" )
g <- g + geom_point(colour="grey50", aes(size = freq+20))
g <- g + geom_point(aes(colour=freq, size = freq))
g <- g + scale_colour_gradient(low = "lightblue", high="white")  
g <- g + geom_smooth(method="lm", formula=y~x) # add geom_smooth, method:lm
g
```

<img src="Week-1a_files/figure-html/n4-1.png" style="display: block; margin: auto;" />

**Good point: Ggplot automatically give us a confidence interval around the line**