---
title: "Chapter 6 HW"
output: 
  html_document:
    keep_md: TRUE
    toc: TRUE
    toc_float: TRUE
---



##Q8

###a


```r
set.seed(123)
X <- rnorm(100)
eps <- rnorm(100)
```

###b


```r
b0 <- 1
b1 <- 20
b2 <- -3
b3 <- 4
Y<- b0 + b1 * X + b2 * X^2 + b3 * X^3 + eps
```

###c subset


```r
df <- data.frame(x=X, y=Y)
reg_fit <- regsubsets(y ~ x + I(x^2) + I(x^3) + I(x^4) + I(x^5) + I(x^6) + I(x^7) + I(x^8) + I(x^9) + I(x^10), data = df, nvmax = 10)
reg_sum <- summary(reg_fit)
reg_sum
```

```
## Subset selection object
## Call: regsubsets.formula(y ~ x + I(x^2) + I(x^3) + I(x^4) + I(x^5) + 
##     I(x^6) + I(x^7) + I(x^8) + I(x^9) + I(x^10), data = df, nvmax = 10)
## 10 Variables  (and intercept)
##         Forced in Forced out
## x           FALSE      FALSE
## I(x^2)      FALSE      FALSE
## I(x^3)      FALSE      FALSE
## I(x^4)      FALSE      FALSE
## I(x^5)      FALSE      FALSE
## I(x^6)      FALSE      FALSE
## I(x^7)      FALSE      FALSE
## I(x^8)      FALSE      FALSE
## I(x^9)      FALSE      FALSE
## I(x^10)     FALSE      FALSE
## 1 subsets of each size up to 10
## Selection Algorithm: exhaustive
##           x   I(x^2) I(x^3) I(x^4) I(x^5) I(x^6) I(x^7) I(x^8) I(x^9)
## 1  ( 1 )  "*" " "    " "    " "    " "    " "    " "    " "    " "   
## 2  ( 1 )  "*" " "    "*"    " "    " "    " "    " "    " "    " "   
## 3  ( 1 )  "*" "*"    "*"    " "    " "    " "    " "    " "    " "   
## 4  ( 1 )  "*" "*"    "*"    " "    " "    "*"    " "    " "    " "   
## 5  ( 1 )  "*" "*"    "*"    " "    " "    " "    "*"    " "    "*"   
## 6  ( 1 )  "*" " "    "*"    "*"    " "    "*"    " "    "*"    " "   
## 7  ( 1 )  "*" "*"    "*"    "*"    " "    "*"    " "    "*"    " "   
## 8  ( 1 )  "*" " "    "*"    "*"    "*"    "*"    "*"    "*"    " "   
## 9  ( 1 )  "*" "*"    "*"    "*"    "*"    "*"    "*"    "*"    " "   
## 10  ( 1 ) "*" "*"    "*"    "*"    "*"    "*"    "*"    "*"    "*"   
##           I(x^10)
## 1  ( 1 )  " "    
## 2  ( 1 )  " "    
## 3  ( 1 )  " "    
## 4  ( 1 )  " "    
## 5  ( 1 )  " "    
## 6  ( 1 )  "*"    
## 7  ( 1 )  "*"    
## 8  ( 1 )  "*"    
## 9  ( 1 )  "*"    
## 10  ( 1 ) "*"
```


```r
plot(reg_sum$cp, xlab = "variables", ylab = "Cp", type = "l")
points(which.min(reg_sum$cp), reg_sum$cp[which.min(reg_sum$cp)], col = "red", cex = 2, pch = 20)
```

![](HW_Chapter8_files/figure-html/unnamed-chunk-4-1.png)<!-- -->


```r
plot(reg_sum$bic, xlab = "variables", ylab = "BIC", type = "l")
points(which.min(reg_sum$bic), reg_sum$bic[which.min(reg_sum$bic)], col = "red", cex = 2, pch = 20)
```

![](HW_Chapter8_files/figure-html/unnamed-chunk-5-1.png)<!-- -->


```r
plot(reg_sum$adjr2, xlab = "variables", ylab = "adjr2", type = "l")
points(which.max(reg_sum$adjr2), reg_sum$adjr2[which.max(reg_sum$adjr2)], col = "red", cex = 2, pch = 20)
```

![](HW_Chapter8_files/figure-html/unnamed-chunk-6-1.png)<!-- -->
Why not at 3 but 6?

```r
reg_sum$adjr2
```

```
##  [1] 0.9391829 0.9820736 0.9987042 0.9987080 0.9986976 0.9987235 0.9987132
##  [8] 0.9987033 0.9986935 0.9986792
```
Adjusted r squared for 3-10 are fairly close.

Picking the model with 3 variables.

```r
coef(reg_fit, which.min(reg_sum$cp))
```

```
## (Intercept)           x      I(x^2)      I(x^3) 
##   0.9703939  19.9204462  -3.0915431   4.0204363
```

###d stepwise

forward first:

```r
reg_fwd <- regsubsets(y ~ x + I(x^2) + I(x^3) + I(x^4) + I(x^5) + I(x^6) + I(x^7) + I(x^8) + I(x^9) + I(x^10), data = df, nvmax = 10, method = "forward")
regfwd_sum <- summary(reg_fwd)
```


```r
plot(regfwd_sum$cp, xlab = "variables", ylab = "Cp", type = "l")
points(which.min(regfwd_sum$cp), regfwd_sum$cp[which.min(regfwd_sum$cp)], col = "red", cex = 2, pch = 20)
```

![](HW_Chapter8_files/figure-html/unnamed-chunk-10-1.png)<!-- -->

```r
plot(regfwd_sum$bic, xlab = "variables", ylab = "BIC", type = "l")
points(which.min(regfwd_sum$bic), regfwd_sum$bic[which.min(regfwd_sum$bic)], col = "red", cex = 2, pch = 20)
```

![](HW_Chapter8_files/figure-html/unnamed-chunk-10-2.png)<!-- -->

```r
plot(regfwd_sum$adjr2, xlab = "variables", ylab = "adjr2", type = "l")
points(which.max(regfwd_sum$adjr2), regfwd_sum$adjr2[which.max(regfwd_sum$adjr2)], col = "red", cex = 2, pch = 20)
```

![](HW_Chapter8_files/figure-html/unnamed-chunk-10-3.png)<!-- -->

Choosing the model with 3 variables:

```r
coef(reg_fwd, which.min(regfwd_sum$cp))
```

```
## (Intercept)           x      I(x^2)      I(x^3) 
##   0.9703939  19.9204462  -3.0915431   4.0204363
```

then backward:

```r
reg_bwd <- regsubsets(y ~ x + I(x^2) + I(x^3) + I(x^4) + I(x^5) + I(x^6) + I(x^7) + I(x^8) + I(x^9) + I(x^10), data = df, nvmax = 10, method = "backward")
regbwd_sum <- summary(reg_bwd)
```


```r
plot(regbwd_sum$cp, xlab = "variables", ylab = "Cp", type = "l")
points(which.min(regbwd_sum$cp), regbwd_sum$cp[which.min(regbwd_sum$cp)], col = "red", cex = 2, pch = 20)
```

![](HW_Chapter8_files/figure-html/unnamed-chunk-13-1.png)<!-- -->

```r
plot(regbwd_sum$bic, xlab = "variables", ylab = "BIC", type = "l")
points(which.min(regbwd_sum$bic), regbwd_sum$bic[which.min(regbwd_sum$bic)], col = "red", cex = 2, pch = 20)
```

![](HW_Chapter8_files/figure-html/unnamed-chunk-13-2.png)<!-- -->

```r
plot(regbwd_sum$adjr2, xlab = "variables", ylab = "adjr2", type = "l")
points(which.max(regbwd_sum$adjr2), regbwd_sum$adjr2[which.max(regbwd_sum$adjr2)], col = "red", cex = 2, pch = 20)
```

![](HW_Chapter8_files/figure-html/unnamed-chunk-13-3.png)<!-- -->

Choosing the one with 6 variables.

```r
coef(reg_bwd, which.min(regbwd_sum$cp))
```

```
## (Intercept)           x      I(x^3)      I(x^4)      I(x^6)      I(x^8) 
##  0.71346671 19.87575532  4.06381032 -5.11742226  2.80269053 -0.61718295 
##     I(x^10) 
##  0.04740728
```

###e. lasso


```r
xmat <- model.matrix(y ~ x + I(x^2) + I(x^3) + I(x^4) + I(x^5) + I(x^6) + I(x^7) + I(x^8) + I(x^9) + I(x^10), data = df)[, -1]
cv_lasso <- cv.glmnet(xmat, Y, alpha = 1)
plot(cv_lasso)
```

![](HW_Chapter8_files/figure-html/unnamed-chunk-15-1.png)<!-- -->


```r
bestlam <- cv_lasso$lambda.min
bestlam
```

```
## [1] 0.1079523
```


```r
lasso_fit <- glmnet(xmat, Y, alpha = 1)
predict(lasso_fit, s = bestlam, type = "coefficients")[1:11, ]
```

```
## (Intercept)           x      I(x^2)      I(x^3)      I(x^4)      I(x^5) 
##   0.8847912  19.8523292  -2.9708817   3.9879709   0.0000000   0.0000000 
##      I(x^6)      I(x^7)      I(x^8)      I(x^9)     I(x^10) 
##   0.0000000   0.0000000   0.0000000   0.0000000   0.0000000
```
A model with three variables.

###f. 


```r
b7 <- 7
y <- b0 + b7 * X^7 + eps
df1 <- data.frame(y = y, x = X)
reg_fit1 <- regsubsets(y ~ x + I(x^2) + I(x^3) + I(x^4) + I(x^5) + I(x^6) + I(x^7) + I(x^8) + I(x^9) + I(x^10), data = df1, nvmax = 10)
reg_sum1 <- summary(reg_fit1)
par(mfrow = c(2, 2))
plot(reg_sum1$cp, xlab = "variables", ylab = "C_p", type = "l")
points(which.min(reg_sum1$cp), reg_sum1$cp[which.min(reg_sum1$cp)], col = "red", cex = 2, pch = 20)
plot(reg_sum1$bic, xlab = "variables", ylab = "BIC", type = "l")
points(which.min(reg_sum1$bic), reg_sum1$bic[which.min(reg_sum1$bic)], col = "red", cex = 2, pch = 20)
plot(reg_sum1$adjr2, xlab = "variables", ylab = "Adjusted R^2", type = "l")
points(which.max(reg_sum1$adjr2), reg_sum1$adjr2[which.max(reg_sum1$adjr2)], col = "red", cex = 2, pch = 20)
```

![](HW_Chapter8_files/figure-html/unnamed-chunk-18-1.png)<!-- -->


```r
coef(reg_fit1, 1)
```

```
## (Intercept)      I(x^7) 
##   0.8932512   6.9997045
```

```r
coef(reg_fit1, 6)
```

```
## (Intercept)      I(x^2)      I(x^4)      I(x^6)      I(x^7)      I(x^8) 
##  0.79358642  2.30456710 -4.10732161  2.27693175  7.00151236 -0.50477246 
##     I(x^10) 
##  0.03899314
```

Cp and BIC picks the most accurate one.


```r
xmat1 <- model.matrix(y ~ x + I(x^2) + I(x^3) + I(x^4) + I(x^5) + I(x^6) + I(x^7) + I(x^8) + I(x^9) + I(x^10), data = df1)[, -1]
cv_lasso1 <- cv.glmnet(xmat1, y, alpha = 1)
bestlam1 <- cv_lasso1$lambda.min
bestlam1
```

```
## [1] 10.70277
```


```r
lasso_fit1 <- glmnet(xmat1, y, alpha = 1)
predict(lasso_fit1, s = bestlam1, type = "coefficients")[1:11, ]
```

```
## (Intercept)           x      I(x^2)      I(x^3)      I(x^4)      I(x^5) 
##    1.444221    0.000000    0.000000    0.000000    0.000000    0.000000 
##      I(x^6)      I(x^7)      I(x^8)      I(x^9)     I(x^10) 
##    0.000000    6.795659    0.000000    0.000000    0.000000
```
Lasso also picks the most accurate one.

##Q9 

###a.. splitting


```r
attach(College)
set.seed(134)
train = sample(1:dim(College)[1], dim(College)[1] / 2)
test <- -train
college_train <- College[train, ]
college_test <- College[test, ]
```

###b. lm


```r
lm_fit <- lm(Apps ~ ., data = college_train)
lm_pred <- predict(lm_fit, college_test)
mean((lm_pred - college_test$Apps)^2)
```

```
## [1] 1142926
```

###c. ridge w/ cv


```r
train.mat <- model.matrix(Apps ~ ., data = college_train)
test.mat <- model.matrix(Apps ~ ., data = college_test)
grid <- 10 ^ seq(4, -2, length = 100)
ridge_fit <- glmnet(train.mat, college_train$Apps, alpha = 0, lambda = grid, thresh = 1e-12)
cv_ridge <- cv.glmnet(train.mat, college_train$Apps, alpha = 0, lambda = grid, thresh = 1e-12)
bestlam_ridge <- cv_ridge$lambda.min
bestlam_ridge
```

```
## [1] 0.01
```


```r
ridge_pred <- predict(ridge_fit, s = bestlam_ridge, newx = test.mat)
mean((ridge_pred - college_test$Apps)^2)
```

```
## [1] 1142924
```
a bit lower that least square

###d. lasso w/ cv


```r
lasso_fit <- glmnet(train.mat, college_train$Apps, alpha = 1, lambda = grid, thresh = 1e-12)
cv_lasso <- cv.glmnet(train.mat, college_train$Apps, alpha = 1, lambda = grid, thresh = 1e-12)
bestlam_lasso <- cv_lasso$lambda.min
bestlam_lasso
```

```
## [1] 16.29751
```


```r
lasso_pred <- predict(lasso_fit, s = bestlam_lasso, newx = test.mat)
mean((lasso_pred - college_test$Apps)^2)
```

```
## [1] 1122228
```
A bit lower.

###e. PCR


```r
pcr_fit <- pcr(Apps ~ ., data = college_train, scale = TRUE, validation = "CV")
pcr_pred <- predict(pcr_fit, college_test, ncomp = 10)
mean((pcr_pred - college_test$Apps)^2)
```

```
## [1] 1807706
```
This one is higher

###f. pls


```r
pls_fit <- plsr(Apps ~ ., data = college_train, scale = TRUE, validation = "CV")
pls_pred <- predict(pls_fit, college_test, ncomp = 10)
mean((pls_pred - college_test$Apps)^2)
```

```
## [1] 1193197
```
Higher.

####g. comparison

Linear models --> compare R^2


```r
test_mean <- mean(college_test$Apps)
1 - mean((lm_pred - college_test$Apps)^2) / mean((test_mean - college_test$Apps)^2)
```

```
## [1] 0.9129553
```

```r
1 - mean((ridge_pred - college_test$Apps)^2) / mean((test_mean - college_test$Apps)^2)
```

```
## [1] 0.9129555
```

```r
1 - mean((lasso_pred - college_test$Apps)^2) / mean((test_mean - college_test$Apps)^2)
```

```
## [1] 0.9145317
```

```r
1 - mean((pcr_pred - college_test$Apps)^2) / mean((test_mean - college_test$Apps)^2)
```

```
## [1] 0.862326
```

```r
1 - mean((pls_pred - college_test$Apps)^2) / mean((test_mean - college_test$Apps)^2)
```

```
## [1] 0.9091267
```

PCR is a bit not as accurate as the others.

##Q10

###a. generate data set


```r
set.seed(167)
x <- matrix(rnorm(1000 * 20), 1000, 20)
b <- rnorm(20)
b[1] <- 0
b[5] <- 0
b[16] <- 0
b[17] <- 0
eps <- rnorm(1000)
y <- x %*% b + eps
```

###b. splitting


```r
train <- sample(seq(1000), 100, replace = FALSE)
test <- -train
x.train <- x[train, ]
x.test <- x[test, ]
y.train <- y[train]
y.test <- y[test]
```

###c. training


```r
df_train <- data.frame(y = y.train, x = x.train)
reg_fit <- regsubsets(y ~ ., data = df_train, nvmax = 20)
train.mat <- model.matrix(y ~ ., data = df_train, nvmax = 20)
train.error <- rep(NA, 20)
for (i in 1:20) {
    coef <- coef(reg_fit, id = i)
    pred <- train.mat[, names(coef)] %*% coef
    train.error[i] <- mean((pred - y.train)^2)
}
plot(train.error, xlab = "Number of predictors", ylab = "Training MSE", pch = 19, type = "b")
```

![](HW_Chapter8_files/figure-html/unnamed-chunk-33-1.png)<!-- -->

###d. testing


```r
df_test <- data.frame(y = y.test, x = x.test)
test.mat <- model.matrix(y ~ ., data = df_test, nvmax = 20)
test.error <- rep(NA, 20)
for (i in 1:20) {
    coef <- coef(reg_fit, id = i)
    pred <- test.mat[, names(coef)] %*% coef
    test.error[i] <- mean((pred - y.test)^2)
}
plot(test.error, xlab = "Number of predictors", ylab = "Testing MSE", pch = 19, type = "b")
```

![](HW_Chapter8_files/figure-html/unnamed-chunk-34-1.png)<!-- -->

###e.


```r
which.min(test.error)
```

```
## [1] 15
```

###f. 


```r
coef(reg_fit, which.min(test.error))
```

```
## (Intercept)         x.2         x.3         x.4         x.6         x.7 
## -0.06783361  0.91664096  2.09417537 -0.90282016  1.29009799 -0.06914173 
##         x.8         x.9        x.11        x.12        x.13        x.14 
##  1.93371838  0.45331030 -0.35846843 -0.85628496  0.42022411 -0.37979518 
##        x.15        x.18        x.19        x.20 
## -0.84118336 -1.10020387  0.53647512 -0.71715677
```
there is no zero.

###g. **


```r
val.errors <- rep(NA, 20)
x_cols = colnames(x, do.NULL = FALSE, prefix = "x.")
for (i in 1:20) {
    coefi <- coef(reg_fit, id = i)
    val.errors[i] <- sqrt(sum((b[x_cols %in% names(coefi)] - coefi[names(coefi) %in% x_cols])^2) + sum(b[!(x_cols %in% names(coefi))])^2)
}
plot(val.errors, xlab = "Number of coefficients", ylab = "Error between estimated and true coefficients", pch = 19, type = "b")
```

![](HW_Chapter8_files/figure-html/unnamed-chunk-37-1.png)<!-- -->


```r
coef(reg_fit, which.min(val.errors))
```

```
## (Intercept)         x.8 
##   0.5345527   2.1671687
```

```r
coef(reg_fit, 8)
```

```
## (Intercept)         x.3         x.4         x.6         x.8         x.9 
##   0.1331383   1.9148780  -0.7844513   1.0525120   1.8558153   0.9265621 
##        x.12        x.15        x.18 
##  -0.9143746  -0.8276575  -1.0759919
```
b1, 5, 16, 17 are zeros.
So whether the coefficients fit the actual ones doesn't imply a lower test mse.

##Q11

###a. 

need more time to understand this one..


```r
data(Boston)
set.seed(1)

predict.regsubsets <- function(object, newdata, id, ...) {
    form <- as.formula(object$call[[2]])
    mat <- model.matrix(form, newdata)
    coefi <- coef(object, id = id)
    xvars <- names(coefi)
    mat[, xvars] %*% coefi
}

k = 10
folds <- sample(1:k, nrow(Boston), replace = TRUE)
cv.errors <- matrix(NA, k, 13, dimnames = list(NULL, paste(1:13)))
for (j in 1:k) {
    best.fit <- regsubsets(crim ~ ., data = Boston[folds != j, ], nvmax = 13)
    for (i in 1:13) {
        pred <- predict(best.fit, Boston[folds == j, ], id = i)
        cv.errors[j, i] <- mean((Boston$crim[folds == j] - pred)^2)
    }
}
mean.cv.errors <- apply(cv.errors, 2, mean)
plot(mean.cv.errors, type = "b", xlab = "Number of variables", ylab = "CV error")
```

![](HW_Chapter8_files/figure-html/unnamed-chunk-39-1.png)<!-- -->

lasso

```r
x <- model.matrix(crim ~ ., Boston)[, -1]
y <- Boston$crim
cv.out <- cv.glmnet(x, y, alpha = 1, type.measure = "mse")
plot(cv.out)
```

![](HW_Chapter8_files/figure-html/unnamed-chunk-40-1.png)<!-- -->

ridge

```r
grid <- 10 ^ seq(4, -2, length = 100)
ridge_fit <- glmnet(x, y, alpha = 0, lambda = grid, thresh = 1e-12)
cv.out <- cv.glmnet(x, y, alpha = 0, type.measure = "mse")
plot(cv.out)
```

![](HW_Chapter8_files/figure-html/unnamed-chunk-41-1.png)<!-- -->

pcr

```r
pcr.fit <- pcr(crim ~ ., data = Boston, scale = TRUE, validation = "CV")
summary(pcr.fit)
```

```
## Data: 	X dimension: 506 13 
## 	Y dimension: 506 1
## Fit method: svdpc
## Number of components considered: 13
## 
## VALIDATION: RMSEP
## Cross-validated using 10 random segments.
##        (Intercept)  1 comps  2 comps  3 comps  4 comps  5 comps  6 comps
## CV            8.61    7.198    7.198    6.786    6.762    6.790    6.821
## adjCV         8.61    7.195    7.195    6.780    6.753    6.784    6.813
##        7 comps  8 comps  9 comps  10 comps  11 comps  12 comps  13 comps
## CV       6.822    6.689    6.712     6.720     6.712     6.664     6.593
## adjCV    6.812    6.679    6.701     6.708     6.700     6.651     6.580
## 
## TRAINING: % variance explained
##       1 comps  2 comps  3 comps  4 comps  5 comps  6 comps  7 comps
## X       47.70    60.36    69.67    76.45    82.99    88.00    91.14
## crim    30.69    30.87    39.27    39.61    39.61    39.86    40.14
##       8 comps  9 comps  10 comps  11 comps  12 comps  13 comps
## X       93.45    95.40     97.04     98.46     99.52     100.0
## crim    42.47    42.55     42.78     43.04     44.13      45.4
```

```r
validationplot(pcr.fit, val.type = "MSEP")
```

![](HW_Chapter8_files/figure-html/unnamed-chunk-42-1.png)<!-- -->

###b.


```r
mean(mean.cv.errors)
```

```
## [1] 43.35447
```

```r
pcr_pred <- predict(pcr.fit, Boston)
mean((pcr_pred - Boston$crim)^2)
```

```
## [1] 44.28028
```

###c.

it has 13 variables.
