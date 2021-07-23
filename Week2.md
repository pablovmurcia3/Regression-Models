---
title: "Week 2"
output: 
  html_document: 
    keep_md: yes
---

**Week 2** 
==============

## **Satistical linear regression models**


### **Basic regression model with additive Gaussian errors**

* Regression is just math (estimation tool).. We want to do inference 

* So let´s introduce the probabilistic model for linear regression

* **This is the population escenario**


$$
Y_i = \beta_0 + \beta_1 X_i + \epsilon_{i}
$$
* Add noise to make it statistical 

* Here the $\epsilon_{i}$ are assumed iid $N(0, \sigma^2)$. 
*Is the accumulation of a lot of variables that you didn´t model that maybe ypu should have, that act together on the response in a way that can be modeled as if independent and identically distributed Gaussian errors*



* Note, $E[Y_i ~|~ X_i = x_i] = \mu_i = \beta_0 + \beta_1 x_i$
*Is the population expected value*

* Note, $Var(Y_i ~|~ X_i = x_i) = \sigma^2$.
*This is the variance around the regression line. Is NOT the variance of the responce. Is lower because (contrlling x) ypu control some of the variation*


This model implies that the Yi are independent and normally distributed with means $\beta_0 + \beta_1 x_i$ and variance $\sigma^2$.

Specifying the model as linear with additive error terms is generally more useful. With that specification, we can hypothesize and discuss the nature of the errors. In fact, we’ll even cover ways to estimate them to investigate our model assumption.

### **Interpreting our regression coefficients**

**Intercept**

Our model allows us to attach statistical interpretations to our parameters. Let’s start with the intercept; β0 represents the expected value of the response when the predictor is 0. We can show this as:

$$
E[Y | X = 0] =  \beta_0 + \beta_1 \times 0 = \beta_0
$$
Note, the intercept isn’t always of interest. For example, when X = 0 is impossible or far outside of the range of data. Take as a specific instance, when X is blood pressure, no one is interested in studying blood pressure’s impact on anything for values near 0. There is a way to make your intercept more interpretable. Consider that:

$$
Y_i = \beta_0 + \beta_1 X_i + \epsilon_i
= \beta_0 + a \beta_1 + \beta_1 (X_i - a) + \epsilon_i
= \tilde \beta_0 + \beta_1 (X_i - a) + \epsilon_i
$$

So, shifting your $X$ values by value $a$ changes the intercept, but not the slope. 

* Often $a$ is set to $\bar X$ so that the intercept is interpretted as the expected response at the average $X$ value.


**Slope**

Our slope, β1, is *the expected change in response for a 1 unit change in the predictor*. We can show that as follows

$$
E[Y ~|~ X = x+1] - E[Y ~|~ X = x] =
\beta_0 + \beta_1 (x + 1) - (\beta_0 + \beta_1 x ) = \beta_1
$$

* Consider the impact of changing the units of $X$. 

$$
Y_i = \beta_0 + \beta_1 X_i + \epsilon_i
= \beta_0 + \frac{\beta_1}{a} (X_i a) + \epsilon_i
= \beta_0 + \tilde \beta_1 (X_i a) + \epsilon_i
$$
Therefore, multiplication of $X$ by a factor $a$ results in dividing the coefficient by a factor of $a$. 

* Example: $X$ is height in $m$ and $Y$ is weight in $kg$. Then $\beta_1$ is $kg/m$. Converting $X$ to $cm$ implies multiplying $X$ by $100 cm/m$. To get $\beta_1$ in the right units, we have to divide by $100 cm /m$ to get it to have the right units. 

$$
X m \times \frac{100cm}{m} = (100 X) cm
~~\mbox{and}~~
\beta_1 \frac{kg}{m} \times\frac{1 m}{100cm} = 
\left(\frac{\beta_1}{100}\right)\frac{kg}{cm}
$$

**Prediction for Y (with observed data)**


* If we would like to guess the outcome at a particular
  value of the predictor, say $X$, the regression model guesses
  
$$
\hat \beta_0 + \hat \beta_1 X
$$
* Regression,especially linear regression, often doesn’t produce the best prediction algorithms. However, it produces parsimonious and interpretable models along with the predictions. Also, as we’ll see later we’ll be able to get easily described estimates of uncertainty associated with our predictions.

* We can predict at any value of X. But we are going to have more reasonable predictions if the value of X that we plugin is in the cloud of data


**Data example**


```r
library(UsingR)
library(ggplot2)
library(reshape2)
library(manipulate)
library(dplyr)
```


```r
data(diamond)

str(diamond)
```

```
## 'data.frame':	48 obs. of  2 variables:
##  $ carat: num  0.17 0.16 0.17 0.18 0.25 0.16 0.15 0.19 0.21 0.15 ...
##  $ price: int  355 328 350 325 642 342 322 485 483 323 ...
```

```r
g = ggplot(diamond, aes(x = carat, y = price))
g = g + xlab("Mass (carats)")
g = g + ylab("Price (SIN $)")
g = g + geom_point(size = 7, colour = "black", alpha=0.5)
g = g + geom_point(size = 5, colour = "blue", alpha=0.2)
g = g + geom_smooth(method = "lm", colour = "black")
g
```

![](Week2_files/figure-html/y1-1.png)<!-- -->

Let´s fitt the linear regression model 


```r
fit <- lm(price ~ carat, data = diamond)
coef(fit)
```

```
## (Intercept)       carat 
##   -259.6259   3721.0249
```

```r
summary(fit)
```

```
## 
## Call:
## lm(formula = price ~ carat, data = diamond)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -85.159 -21.448  -0.869  18.972  79.370 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  -259.63      17.32  -14.99   <2e-16 ***
## carat        3721.02      81.79   45.50   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 31.84 on 46 degrees of freedom
## Multiple R-squared:  0.9783,	Adjusted R-squared:  0.9778 
## F-statistic:  2070 on 1 and 46 DF,  p-value: < 2.2e-16
```

* Therefore,we estimate an expected 3721.02 (SIN) dollar increase in price for every carat increase in mass of diamond. The intercept -259.63 is the expected price of a 0 carat diamond. The intercept is not of interest.

So let´s get a more interpretable intercept by mean centering



```r
fit2 <- lm(price ~ I(carat-mean(carat)), data = diamond)
# if ypu want to do operations inside lm, you need I()
coef(fit2)
```

```
##            (Intercept) I(carat - mean(carat)) 
##               500.0833              3721.0249
```

```r
# thes same as...

diamond$caratc <- diamond$carat - mean(diamond$carat)

fitc <- lm(price ~ caratc, data = diamond)
coef(fitc)
```

```
## (Intercept)      caratc 
##    500.0833   3721.0249
```

* Thus the new intercept, 500.1, is the expected price for the average sized diamond of the data (0.2042
carats). Notice the estimated slope didn’t change at all.

What about changing units to 1/10th of a carat? We can just do this by just dividing the coefficient by 10, no need to refit the model.

Thus, we expect a 372.102 (SIN) dollar change in price for every 1/10th of a carat increase in mass of diamond.

But let´s do it on R.


```r
fit3 <- lm(price ~ I(carat * 10), data = diamond)
coef(fit3)
```

```
##   (Intercept) I(carat * 10) 
##     -259.6259      372.1025
```


Now we want to predict the price of data.

Let´s introduce the function *predict*



```r
newx <- c(0.16, 0.27, 0.34)
coef(fit)[1] + coef(fit)[2] * newx
```

```
## [1]  335.7381  745.0508 1005.5225
```

```r
# better/efficient method
# use predict 

predict(fit, newdata = data.frame(carat = newx))
```

```
##         1         2         3 
##  335.7381  745.0508 1005.5225
```

```r
# here we plug the data in the form as a data frame

predict(fit) # it predicts at the x data points --> gives you yhe fitted y´s
```

```
##         1         2         3         4         5         6         7         8 
##  372.9483  335.7381  372.9483  410.1586  670.6303  335.7381  298.5278  447.3688 
##         9        10        11        12        13        14        15        16 
##  521.7893  298.5278  410.1586  782.2611  335.7381  484.5791  596.2098  819.4713 
##        17        18        19        20        21        22        23        24 
##  186.8971  707.8406  670.6303  745.0508  410.1586  335.7381  372.9483  335.7381 
##        25        26        27        28        29        30        31        32 
##  372.9483  410.1586  372.9483  410.1586  372.9483  298.5278  372.9483  931.1020 
##        33        34        35        36        37        38        39        40 
##  931.1020  298.5278  335.7381  335.7381  596.2098  596.2098  372.9483  968.3123 
##        41        42        43        44        45        46        47        48 
##  670.6303 1042.7328  410.1586  670.6303  670.6303  298.5278  707.8406  298.5278
```





