---
title: "Project"
output: 
  html_document:
    keep_md: TRUE
    toc: TRUE
    toc_float: TRUE
---



##Import


```r
data <- read.csv("suicide.csv")
```




```r
summary(data)
```

```
##       X...country         year          sex                 age      
##  Austria    :  382   Min.   :1985   female:13910   15-24 years:4642  
##  Iceland    :  382   1st Qu.:1995   male  :13910   25-34 years:4642  
##  Mauritius  :  382   Median :2002                  35-54 years:4642  
##  Netherlands:  382   Mean   :2001                  5-14 years :4610  
##  Argentina  :  372   3rd Qu.:2008                  55-74 years:4642  
##  Belgium    :  372   Max.   :2016                  75+ years  :4642  
##  (Other)    :25548                                                   
##   suicides_no        population       suicides.100k.pop
##  Min.   :    0.0   Min.   :     278   Min.   :  0.00   
##  1st Qu.:    3.0   1st Qu.:   97498   1st Qu.:  0.92   
##  Median :   25.0   Median :  430150   Median :  5.99   
##  Mean   :  242.6   Mean   : 1844794   Mean   : 12.82   
##  3rd Qu.:  131.0   3rd Qu.: 1486143   3rd Qu.: 16.62   
##  Max.   :22338.0   Max.   :43805214   Max.   :224.97   
##                                                        
##       country.year    HDI.for.year            gdp_for_year....
##  Albania1987:   12   Min.   :0.483   1,002,219,052,968:   12  
##  Albania1988:   12   1st Qu.:0.713   1,011,797,457,139:   12  
##  Albania1989:   12   Median :0.779   1,016,418,229    :   12  
##  Albania1992:   12   Mean   :0.777   1,018,847,043,277:   12  
##  Albania1993:   12   3rd Qu.:0.855   1,022,191,296    :   12  
##  Albania1994:   12   Max.   :0.944   1,023,196,003,075:   12  
##  (Other)    :27748   NA's   :19456   (Other)          :27748  
##  gdp_per_capita....           generation  
##  Min.   :   251     Boomers        :4990  
##  1st Qu.:  3447     G.I. Generation:2744  
##  Median :  9372     Generation X   :6408  
##  Mean   : 16866     Generation Z   :1470  
##  3rd Qu.: 24874     Millenials     :5844  
##  Max.   :126352     Silent         :6364  
## 
```

##overview

###Total


```r
year <- data %>%
  select("X...country":"suicides.100k.pop", "HDI.for.year":"generation") %>%
  group_by(year) %>%
  summarize(suicides_per_100k = (sum(suicides_no)/sum(population)) * 100000)
year
```

```
## # A tibble: 32 x 2
##     year suicides_per_100k
##    <int>             <dbl>
##  1  1985              11.5
##  2  1986              11.7
##  3  1987              11.6
##  4  1988              11.5
##  5  1989              13.1
##  6  1990              13.2
##  7  1991              13.3
##  8  1992              13.5
##  9  1993              14.5
## 10  1994              15.0
## # ... with 22 more rows
```


```r
ggplot(year) +
  geom_line(aes(year, suicides_per_100k))
```

![](Project_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

###Sex


```r
sex <- data %>%
  select("year":"suicides.100k.pop", "HDI.for.year":"generation") %>%
  group_by(year, sex) %>%
  summarize(rate = (sum(suicides_no)/sum(population)) * 100000)
sex
```

```
## # A tibble: 64 x 3
## # Groups:   year [32]
##     year sex     rate
##    <int> <fct>  <dbl>
##  1  1985 female  6.33
##  2  1985 male   16.9 
##  3  1986 female  6.45
##  4  1986 male   17.2 
##  5  1987 female  6.26
##  6  1987 male   17.1 
##  7  1988 female  6.13
##  8  1988 male   17.1 
##  9  1989 female  6.57
## 10  1989 male   20.0 
## # ... with 54 more rows
```


```r
ggplot(sex) +
  geom_line(aes(year, rate, color = sex))
```

![](Project_files/figure-html/unnamed-chunk-7-1.png)<!-- -->

###Age


```r
age <- data %>%
  select("year":"suicides.100k.pop", "HDI.for.year":"generation") %>%
  group_by(year, age) %>%
  summarize(suicides_per_100k = (sum(suicides_no)/sum(population))*100000)
age
```

```
## # A tibble: 191 x 3
## # Groups:   year [32]
##     year age         suicides_per_100k
##    <int> <fct>                   <dbl>
##  1  1985 15-24 years             9.07 
##  2  1985 25-34 years            12.0  
##  3  1985 35-54 years            14.5  
##  4  1985 5-14 years              0.494
##  5  1985 55-74 years            18.8  
##  6  1985 75+ years              29.8  
##  7  1986 15-24 years             9.07 
##  8  1986 25-34 years            12.3  
##  9  1986 35-54 years            14.8  
## 10  1986 5-14 years              0.465
## # ... with 181 more rows
```


```r
ggplot(age) +
  geom_line(aes(year, suicides_per_100k, color = age))
```

![](Project_files/figure-html/unnamed-chunk-9-1.png)<!-- -->

###Generation


```r
gen <- data %>%
  select("year":"suicides.100k.pop", "HDI.for.year":"generation") %>%
  group_by(year, generation) %>%
  summarize(suicides_per_100k = (sum(suicides_no)/sum(population))*100000)
gen
```

```
## # A tibble: 146 x 3
## # Groups:   year [32]
##     year generation      suicides_per_100k
##    <int> <fct>                       <dbl>
##  1  1985 Boomers                     12.0 
##  2  1985 G.I. Generation             21.1 
##  3  1985 Generation X                 4.76
##  4  1985 Silent                      14.5 
##  5  1986 Boomers                     12.3 
##  6  1986 G.I. Generation             21.4 
##  7  1986 Generation X                 4.73
##  8  1986 Silent                      14.8 
##  9  1987 Boomers                     11.8 
## 10  1987 G.I. Generation             21.6 
## # ... with 136 more rows
```


```r
ggplot(gen) +
  geom_line(aes(year, suicides_per_100k, color = generation))
```

![](Project_files/figure-html/unnamed-chunk-11-1.png)<!-- -->

##USA


```r
usa <- filter(data, X...country == "United States") %>%
  select("year":"generation")
```


```r
usa_year <- usa %>%
  select("year":"suicides.100k.pop", "HDI.for.year":"generation") %>%
  group_by(year) %>%
  summarize(suicides_per_100k = (sum(suicides_no)/sum(population)) * 100000)
year
```

```
## # A tibble: 32 x 2
##     year suicides_per_100k
##    <int>             <dbl>
##  1  1985              11.5
##  2  1986              11.7
##  3  1987              11.6
##  4  1988              11.5
##  5  1989              13.1
##  6  1990              13.2
##  7  1991              13.3
##  8  1992              13.5
##  9  1993              14.5
## 10  1994              15.0
## # ... with 22 more rows
```


```r
ggplot(usa_year) +
  geom_line(aes(year, suicides_per_100k)) +
  ylim(c(10, 15))
```

![](Project_files/figure-html/unnamed-chunk-14-1.png)<!-- -->

###Sex


```r
usa_sex <- usa %>%
  select("year":"suicides.100k.pop", "HDI.for.year":"generation") %>%
  group_by(year, sex) %>%
  summarize(rate = (sum(suicides_no)/sum(population)) * 100000)
usa_sex
```

```
## # A tibble: 62 x 3
## # Groups:   year [31]
##     year sex     rate
##    <int> <fct>  <dbl>
##  1  1985 female  5.54
##  2  1985 male   21.6 
##  3  1986 female  5.81
##  4  1986 male   22.4 
##  5  1987 female  5.62
##  6  1987 male   22.2 
##  7  1988 female  5.40
##  8  1988 male   21.8 
##  9  1989 female  5.19
## 10  1989 male   21.6 
## # ... with 52 more rows
```


```r
ggplot(usa_sex) +
  geom_line(aes(year, rate, color = sex))
```

![](Project_files/figure-html/unnamed-chunk-16-1.png)<!-- -->

###Age


```r
usa_age <- usa %>%
  select("year":"suicides.100k.pop", "HDI.for.year":"generation") %>%
  group_by(year, age) %>%
  summarize(suicides_per_100k = (sum(suicides_no)/sum(population))*100000)
usa_age
```

```
## # A tibble: 186 x 3
## # Groups:   year [31]
##     year age         suicides_per_100k
##    <int> <fct>                   <dbl>
##  1  1985 15-24 years            12.9  
##  2  1985 25-34 years            15.2  
##  3  1985 35-54 years            15.0  
##  4  1985 5-14 years              0.820
##  5  1985 55-74 years            17.5  
##  6  1985 75+ years              22.9  
##  7  1986 15-24 years            13.1  
##  8  1986 25-34 years            15.7  
##  9  1986 35-54 years            15.7  
## 10  1986 5-14 years              0.753
## # ... with 176 more rows
```


```r
ggplot(usa_age) +
  geom_line(aes(year, suicides_per_100k, color = age))
```

![](Project_files/figure-html/unnamed-chunk-18-1.png)<!-- -->

###Generation


```r
usa_gen <- usa %>%
  select("year":"suicides.100k.pop", "HDI.for.year":"generation") %>%
  group_by(year, generation) %>%
  summarize(suicides_per_100k = (sum(suicides_no)/sum(population))*100000)
usa_gen
```

```
## # A tibble: 142 x 3
## # Groups:   year [31]
##     year generation      suicides_per_100k
##    <int> <fct>                       <dbl>
##  1  1985 Boomers                     15.2 
##  2  1985 G.I. Generation             18.7 
##  3  1985 Generation X                 7.35
##  4  1985 Silent                      15.0 
##  5  1986 Boomers                     15.7 
##  6  1986 G.I. Generation             19.6 
##  7  1986 Generation X                 7.37
##  8  1986 Silent                      15.7 
##  9  1987 Boomers                     15.4 
## 10  1987 G.I. Generation             19.5 
## # ... with 132 more rows
```


```r
ggplot(usa_gen) +
  geom_line(aes(year, suicides_per_100k, color = generation))
```

![](Project_files/figure-html/unnamed-chunk-20-1.png)<!-- -->

##Most

###Which country


```r
country <- data %>%
  select("X...country":"suicides.100k.pop", "HDI.for.year":"generation") %>%
  group_by(X...country) %>%
  summarize(suicides_per_100k = (sum(suicides_no)/sum(population))*100000) %>%
  rename(country = X...country)
country
```

```
## # A tibble: 101 x 2
##    country             suicides_per_100k
##    <fct>                           <dbl>
##  1 Albania                         3.16 
##  2 Antigua and Barbuda             0.553
##  3 Argentina                       7.94 
##  4 Armenia                         2.46 
##  5 Aruba                           8.02 
##  6 Australia                      12.9  
##  7 Austria                        20.5  
##  8 Azerbaijan                      1.48 
##  9 Bahamas                         1.42 
## 10 Bahrain                         2.76 
## # ... with 91 more rows
```


```r
arrange(country, desc(suicides_per_100k))
```

```
## # A tibble: 101 x 2
##    country            suicides_per_100k
##    <fct>                          <dbl>
##  1 Lithuania                       41.2
##  2 Russian Federation              32.8
##  3 Sri Lanka                       30.5
##  4 Belarus                         30.3
##  5 Hungary                         29.7
##  6 Latvia                          28.5
##  7 Kazakhstan                      26.9
##  8 Slovenia                        26.4
##  9 Estonia                         26.0
## 10 Ukraine                         24.9
## # ... with 91 more rows
```


```r
arrange(country, suicides_per_100k)
```

```
## # A tibble: 101 x 2
##    country               suicides_per_100k
##    <fct>                             <dbl>
##  1 Dominica                          0    
##  2 Saint Kitts and Nevis             0    
##  3 Oman                              0.367
##  4 Jamaica                           0.466
##  5 Antigua and Barbuda               0.553
##  6 Maldives                          0.690
##  7 South Africa                      0.838
##  8 Bahamas                           1.42 
##  9 Azerbaijan                        1.48 
## 10 Grenada                           1.62 
## # ... with 91 more rows
```
