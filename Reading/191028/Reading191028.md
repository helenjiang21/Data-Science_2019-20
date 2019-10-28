---
title: "Reading191028"
output: 
 html_document:
    keep_md: TRUE
    toc: TRUE
    toc_float: TRUE
---



##String Basic


```r
x <- c("a", "I\'m clever", NA)
str_length(x)
```

```
## [1]  1 10 NA
```

```r
read_lines(x)
```

```
## [1] "a"          "I'm clever" "NA"
```

###combining strings


```r
str_c("x", "y", "z")
```

```
## [1] "xyz"
```


```r
y <- c("abc", NA)
str_c("|-", y, "-|")
```

```
## [1] "|-abc-|" NA
```

```r
str_c("|-", str_replace_na(x), "-|")
```

```
## [1] "|-a-|"          "|-I'm clever-|" "|-NA-|"
```

```r
str_c("prefix-", c("a", "b", "c"), "-suffix")
```

```
## [1] "prefix-a-suffix" "prefix-b-suffix" "prefix-c-suffix"
```


```r
str_c("prefix-", c("a", "b", "c"), "-suffix")
```

```
## [1] "prefix-a-suffix" "prefix-b-suffix" "prefix-c-suffix"
```

###subsetting


```r
z <- c("Apple", "Banana", "Pear") 
str_sub(z, 1, 3)
```

```
## [1] "App" "Ban" "Pea"
```

```r
str_sub(z, -3, -1)
```

```
## [1] "ple" "ana" "ear"
```

```r
str_sub(z, 1, 5)
```

```
## [1] "Apple" "Banan" "Pear"
```

```r
str_sub(z, 1, -5)
```

```
## [1] "A"  "Ba" ""
```

###Anchors


```r
x <- c("apple pie", "apple", "apple cake")
str_view(x, "apple")
```

<!--html_preserve--><div id="htmlwidget-62c97f9fccbc5bca90e4" style="width:960px;height:100%;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-62c97f9fccbc5bca90e4">{"x":{"html":"<ul>\n  <li><span class='match'>apple<\/span> pie<\/li>\n  <li><span class='match'>apple<\/span><\/li>\n  <li><span class='match'>apple<\/span> cake<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

```r
str_view(x, "^apple$")    
```

<!--html_preserve--><div id="htmlwidget-aefe44826d7a0b4c37c3" style="width:960px;height:100%;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-aefe44826d7a0b4c37c3">{"x":{"html":"<ul>\n  <li>apple pie<\/li>\n  <li><span class='match'>apple<\/span><\/li>\n  <li>apple cake<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

###character classes

`\d` matches any digit.
`\s` matches any whitespace (e.g., space, tab, newline).  
`[abc]` matches a, b, or c.
`[^abc]` matches anything except a, b, or c.


```r
str_view(c("grey", "gray"), "gr(e|a)y")
```

<!--html_preserve--><div id="htmlwidget-f4eea3a04d4515db9032" style="width:960px;height:100%;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-f4eea3a04d4515db9032">{"x":{"html":"<ul>\n  <li><span class='match'>grey<\/span><\/li>\n  <li><span class='match'>gray<\/span><\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

###Grouping &backreference


```r
str_view(fruit, "(..)\\1", match = TRUE)
```

<!--html_preserve--><div id="htmlwidget-7fb9b20ce4617c580c33" style="width:960px;height:100%;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-7fb9b20ce4617c580c33">{"x":{"html":"<ul>\n  <li>b<span class='match'>anan<\/span>a<\/li>\n  <li><span class='match'>coco<\/span>nut<\/li>\n  <li><span class='match'>cucu<\/span>mber<\/li>\n  <li><span class='match'>juju<\/span>be<\/li>\n  <li><span class='match'>papa<\/span>ya<\/li>\n  <li>s<span class='match'>alal<\/span> berry<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

