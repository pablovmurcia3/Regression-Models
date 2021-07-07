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








