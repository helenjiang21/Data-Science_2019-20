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

<!--html_preserve--><div id="htmlwidget-3506183e314482fa0b39" style="width:960px;height:100%;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-3506183e314482fa0b39">{"x":{"html":"<ul>\n  <li><span class='match'>apple<\/span> pie<\/li>\n  <li><span class='match'>apple<\/span><\/li>\n  <li><span class='match'>apple<\/span> cake<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

```r
str_view(x, "^apple$")    
```

<!--html_preserve--><div id="htmlwidget-24896816bade927cda60" style="width:960px;height:100%;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-24896816bade927cda60">{"x":{"html":"<ul>\n  <li>apple pie<\/li>\n  <li><span class='match'>apple<\/span><\/li>\n  <li>apple cake<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

###character classes

`\d` matches any digit.
`\s` matches any whitespace (e.g., space, tab, newline).  
`[abc]` matches a, b, or c.
`[^abc]` matches anything except a, b, or c.


```r
str_view(c("grey", "gray"), "gr(e|a)y")
```

<!--html_preserve--><div id="htmlwidget-dde2483f0ecde59fc79e" style="width:960px;height:100%;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-dde2483f0ecde59fc79e">{"x":{"html":"<ul>\n  <li><span class='match'>grey<\/span><\/li>\n  <li><span class='match'>gray<\/span><\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

###Grouping &backreference


```r
str_view(fruit, "(..)\\1", match = TRUE)
```

<!--html_preserve--><div id="htmlwidget-f93ad6d5eef75312ec34" style="width:960px;height:100%;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-f93ad6d5eef75312ec34">{"x":{"html":"<ul>\n  <li>b<span class='match'>anan<\/span>a<\/li>\n  <li><span class='match'>coco<\/span>nut<\/li>\n  <li><span class='match'>cucu<\/span>mber<\/li>\n  <li><span class='match'>juju<\/span>be<\/li>\n  <li><span class='match'>papa<\/span>ya<\/li>\n  <li>s<span class='match'>alal<\/span> berry<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

###Extract


```r
colors <- c("red", "orange", "yellow", "green", "blue", "purple")
color_match <- str_c(colors, collapse = "|") 
color_match
```

```
## [1] "red|orange|yellow|green|blue|purple"
```

```r
has_color <- str_subset(sentences, color_match) 
matches <- str_extract(has_color, color_match) 
head(matches)
```

```
## [1] "blue" "blue" "red"  "red"  "red"  "blue"
```


```r
more <- sentences[str_count(sentences, color_match) > 1]
str_view_all(more, color_match)
```

<!--html_preserve--><div id="htmlwidget-d456e330a24e33796058" style="width:960px;height:100%;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-d456e330a24e33796058">{"x":{"html":"<ul>\n  <li>It is hard to erase <span class='match'>blue<\/span> or <span class='match'>red<\/span> ink.<\/li>\n  <li>The <span class='match'>green<\/span> light in the brown box flicke<span class='match'>red<\/span>.<\/li>\n  <li>The sky in the west is tinged with <span class='match'>orange<\/span> <span class='match'>red<\/span>.<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

```r
str_extract(more, color_match)
```

```
## [1] "blue"   "green"  "orange"
```


```r
str_extract_all(more, color_match, simplify = TRUE)
```

```
##      [,1]     [,2] 
## [1,] "blue"   "red"
## [2,] "green"  "red"
## [3,] "orange" "red"
```


```r
x <- c("a", "a b", "a b c") 
str_extract_all(x, "[a-z]", simplify = TRUE)
```

```
##      [,1] [,2] [,3]
## [1,] "a"  ""   ""  
## [2,] "a"  "b"  ""  
## [3,] "a"  "b"  "c"
```

###Locate


```r
str_locate("The quick (???brown???) fox can???t jump 32.3 feet, right?", "ju")
```

```
##      start end
## [1,]    37  38
```

###Others


```r
bananas <- c("banana", "Banana", "BANANA")
    str_view(bananas, regex("banana", ignore_case = T))
```

<!--html_preserve--><div id="htmlwidget-e10edd93682df20b3ae6" style="width:960px;height:100%;" class="str_view html-widget"></div>
<script type="application/json" data-for="htmlwidget-e10edd93682df20b3ae6">{"x":{"html":"<ul>\n  <li><span class='match'>banana<\/span><\/li>\n  <li><span class='match'>Banana<\/span><\/li>\n  <li><span class='match'>BANANA<\/span><\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->


```r
x <- "Line 1\nLine 2\nLine 3"
str_extract_all(x, "^Line")
```

```
## [[1]]
## [1] "Line"
```


```r
str_extract_all(x, regex("^Line", multiline = TRUE))
```

```
## [[1]]
## [1] "Line" "Line" "Line"
```


```r
phone <- regex("
\\(? # optional opening parens
(\\d{3}) # area code
[)- ]? # optional closing parens, dash, or space (\\d{3}) # another three numbers
[ -]? # optional space or dash
(\\d{3}) # three more numbers
", comments = TRUE)
str_match("514-791-8141", phone)
```

```
##      [,1]      [,2]  [,3] 
## [1,] "514-791" "514" "791"
```


```r
microbenchmark::microbenchmark(
    fixed = str_detect(sentences, fixed("the")),
    regex = str_detect(sentences, "the"),
    times = 20
)
```

```
## Unit: microseconds
##   expr     min       lq     mean   median       uq     max neval
##  fixed  91.859  93.4675 122.7660 100.5655 129.4165 318.113    20
##  regex 327.153 331.3340 342.4194 333.9600 339.9765 391.882    20
```

coll()

```r
a1 <- "\u00e1" 
a2 <- "a\u0301" 
c(a1, a2)
```

```
## [1] "<U+00E1>" "a<U+0301>"
```

```r
str_detect(a1, fixed(a2)) 
```

```
## [1] FALSE
```

```r
str_detect(a1, coll(a2))
```

```
## [1] TRUE
```



```r
i <- c("I", "??", "i", "??")
str_subset(i, coll("i", ignore_case = TRUE))
```

```
## [1] "I" "i"
```

###Other regex


```r
apropos("replace")
```

```
## [1] "%+replace%"       "replace"          "replace_na"      
## [4] "setReplaceMethod" "str_replace"      "str_replace_all" 
## [7] "str_replace_na"   "theme_replace"
```


```r
head(dir(pattern = "\\.Rmd$"))
```

```
## [1] "Reading191028.Rmd"
```

