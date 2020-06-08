library(shiny)
library(proxy)
library(recommenderlab)
library(reshape2)

anime <- read.csv("clean/anime_cleaned.csv")
lists <- read.csv("clean/animelists_cleaned.csv")

Lists <- lists %>%
  select("username", "anime_id", "my_score") %>%
  filter("my_score" != 0)

Anime <- anime %>%
  select("anime_id":"title", "type":"episodes", "rating", "studio", "genre") %>%
  filter("scored_by" != 0)

Anime2 <- anime %>%
  select("anime_id":"title", "genre")

Anime2 <- Anime2[-which((Anime2$anime_id %in% Lists$anime_id) == FALSE),]

genre_list <- c("Action", "Adventure", "Cars", "Comedy", "Dementia","Demons", "Drama", "Ecchi", 
                "Fantasy","Game", "Harem", "Hentai", "Historical","Horror", "Josei", "Kids", "Magic", 
                "Martial_Arts", "Mecha", "Military", "Music", "Mystery", "Parody", "Police", "Psychological", 
                "Romance", "Samurai", "School", "Sci-Fi", "Seinen", "Shoujo", "Shoujo Ai", "Slice_of_Life", 
                "Space", "Sports", "Super_Power", "Supernatural", "Thriller", "Vampire", "Yaoi", "Yuri")

genre_matrix <- matrix(0,6621,41) # Split the genres
genre_matrix[1,] <- genre_list 
colnames(genre_matrix) <- genre_list 
for (i in 1:nrow(genres2)) {
  for (c in 1:ncol(genres2)) {
    genmat_col = which(genre_matrix[1,] == genres2[i,c])
    genre_matrix[i+1, genmat_col] <- 1
  }
}
genre_matrix2 <- as.data.frame(genre_matrix[-1,], stringsAsFactors=FALSE)
for (c in 1:ncol(genre_matrix2)) {
  genre_matrix2[,c] <- as.integer(genre_matrix2[,c])
} 

Anime3 <- cbind(Anime2, genre_matrix2)

Anime_recommendation <- function(input,input2,input3) {
  row_num <- which(Anime3[,2] == input)
  row_num2 <- which(Anime3[,2] == input2)
  row_num3 <- which(Anime3[,2] == input3)
  userSelect <- matrix(NA,10325)
  userSelect[row_num] <- 10 # Assign each user selection with a score.
  userSelect[row_num2] <- 9 
  userSelect[row_num3] <- 8 
  userSelect <- t(userSelect)
  
  ratingmat <- dcast(Lists, username~anime_id, value.var = "rating", na.rm=FALSE)
  ratingmat <- ratingmat[,-1]
  colnames(userSelect) <- colnames(ratingmat)
  ratingmat2 <- ratingmat[rowCounts(ratingmat) > 15, colCounts(ratingmat) > 100]
  ratingmat2 <- rbind(userSelect,ratingmat2) 
  ratingmat2 <- as.matrix(ratingmat2)
  ratingmat2 <- as(ratingmat2, "realRatingMatrix") # Convert rating matrix into a sparse matrix

  recommender_model <- Recommender(ratingmat2, method = "UBCF",param=list(method="Pearson", n=10)) # Model selected according to Rmd file's ROC Curve
  rec_pred <- predict(recommender_model, ratingmat2[1], n=10)
  rec_list <- as(rec_pred, "list")
  no_result <- data.frame(matrix(NA,1))
  rec_result <- data.frame(matrix(NA,10))
  if (as.character(rec_list[1])=='character(0)'){
    no_result[1,1] <- "Sorry, there is not enough information in our database about the anime you chose. Try to select a different one."
    colnames(no_result) <- "No results"
    return(no_result) 
  } else {
    for (i in c(1:10)){
      rec_result[i,1] <- as.character(subset(Anime, Anime$anime_id == as.integer(rec_list[[1]][i])))
    }
    return(rec_result)
  }
}

# UI
ui <- fluidPage(
  titlePanel("Anime Recommendation System"),
  fluidRow(
    
    column(4, h3("Select Genres You Like (order matters):"),
           wellPanel(
             selectInput("input_genre", "Genre #1",
                         genre_list),
             selectInput("input_genre2", "Genre #2",
                         genre_list),
             selectInput("input_genre3", "Genre #1",
                         genre_list)
           )),
    
    column(4, h3("Select Animes You Like of these Genres:"),
           wellPanel(
             uiOutput("ui"),
             uiOutput("ui2"),
             uiOutput("ui3")
           )),
    
    column(4,
           h3("Top 10 Recommendations"),
           tableOutput("table")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$ui <- renderUI({
    if (is.null(input$input_genre))
      return()
    
    switch(input$input_genre,
           "Action" = selectInput("select", "Anime of Genre #1",
                                  choices = sort(subset(Anime3, Action == 1)$title),
                                  selected = sort(subset(Anime3, Action == 1)$title)[1]),
           "Adventure" = selectInput("select", "Anime of Genre #1",
                                     choices = sort(subset(Anime3, Adventure == 1)$title),
                                     selected = sort(subset(Anime3, Adventure == 1)$title)[1]),
           "Cars" =  selectInput("select", "Anime of Genre #1",
                                      choices = sort(subset(Anime3, Cars == 1)$title),
                                      selected = sort(subset(Anime3, Cars == 1)$title)[1]),
           "Comedy" =  selectInput("select", "Anime of Genre #1",
                                     choices = sort(subset(Anime3, Comedy == 1)$title),
                                     selected = sort(subset(Anime3, Comedy == 1)$title)[1]),
           "Dementia" =  selectInput("select", "Anime of Genre #1",
                                   choices = sort(subset(Anime3, Dementia == 1)$title),
                                   selected = sort(subset(Anime3, Dementia == 1)$title)[1]),
           "Demons" =  selectInput("select", "Anime of Genre #1",
                                  choices = sort(subset(Anime3, Demons == 1)$title),
                                  selected = sort(subset(Anime3, Demons == 1)$title)[1]),
           "Drama" =  selectInput("select", "Anime of Genre #1",
                                        choices = sort(subset(Anime3, Drama == 1)$title),
                                        selected = sort(subset(Anime3, Drama == 1)$title)[1]),
           "Ecchi" =  selectInput("select", "Anime of Genre #1",
                                  choices = sort(subset(Anime3, Ecchi == 1)$title),
                                  selected = sort(subset(Anime3, Ecchi == 1)$title)[1]),
           "Fantasy" =  selectInput("select", "Anime of Genre #1",
                                    choices = sort(subset(Anime3, Fantasy == 1)$title),
                                    selected = sort(subset(Anime3, Fantasy == 1)$title)[1]),
           "Game" =  selectInput("select", "Anime of Genre #1",
                                      choices = sort(subset(Anime3, Game == 1)$title),
                                      selected = sort(subset(Anime3, Game == 1)$title)[1]),
           "Harem" =  selectInput("select", "Anime of Genre #1",
                                   choices = sort(subset(Anime3, Harem == 1)$title),
                                   selected = sort(subset(Anime3, Harem == 1)$title)[1]),
           "Hentai" =  selectInput("select", "Anime of Genre #1",
                                    choices = sort(subset(Anime3, Hentai == 1)$title),
                                    selected = sort(subset(Anime3, Hentai == 1)$title)[1]),
           "Historical" =  selectInput("select", "Anime of Genre #1",
                                    choices = sort(subset(Anime3, Historical == 1)$title),
                                    selected = sort(subset(Anime3, Historical == 1)$title)[1]),
           "Horror" =  selectInput("select", "Anime of Genre #1",
                                    choices = sort(subset(Anime3, Horror == 1)$title),
                                    selected = sort(subset(Anime3, Horror == 1)$title)[1]),
           "Josei" =  selectInput("select", "Anime of Genre #1",
                                   choices = sort(subset(Anime3, Josei == 1)$title),
                                   selected = sort(subset(Anime3, Josei == 1)$title)[1]),
           "Kids" =  selectInput("select", "Anime of Genre #1",
                                     choices = sort(subset(Anime3, Kids == 1)$title),
                                     selected = sort(subset(Anime3, Kids == 1)$title)[1]),
           "Magic" =  selectInput("select", "Anime of Genre #1",
                                choices = sort(subset(Anime3, Magic == 1)$title),
                                selected = sort(subset(Anime3, Magic == 1)$title)[1]),
           "Martial_Arts" = selectInput("select", "Anime of Genre #1",
                                   choices = sort(subset(Anime3,  Martial_Arts == 1)$title),
                                   selected = sort(subset(Anime3, Martial_Arts == 1)$title)[1]),
           "Maecha" =  selectInput("select", "Anime of Genre #1",
                                  choices = sort(subset(Anime3, Mecha == 1)$title),
                                  selected = sort(subset(Anime3, Mecha == 1)$title)[1]),
           "Military" =  selectInput("select", "Anime of Genre #1",
                                  choices = sort(subset(Anime3, Military == 1)$title),
                                  selected = sort(subset(Anime3, Military == 1)$title)[1]),
           "Music" =  selectInput("select", "Anime of Genre #1",
                                  choices = sort(subset(Anime3, Music == 1)$title),
                                  selected = sort(subset(Anime3, Music == 1)$title)[1]),
           "Mystery" =  selectInput("select", "Anime of Genre #1",
                                  choices = sort(subset(Anime3, Mystery == 1)$title),
                                  selected = sort(subset(Anime3, Mystery == 1)$title)[1]),
           "Parody" =  selectInput("select", "Anime of Genre #1",
                                  choices = sort(subset(Anime3, Parody == 1)$title),
                                  selected = sort(subset(Anime3, Parody == 1)$title)[1]),
           "Police" =  selectInput("select", "Anime of Genre #1",
                                  choices = sort(subset(Anime3, Police == 1)$title),
                                  selected = sort(subset(Anime3, Police == 1)$title)[1]),
           "Psychological" =  selectInput("select", "Anime of Genre #1",
                                  choices = sort(subset(Anime3, Psychological == 1)$title),
                                  selected = sort(subset(Anime3, Psychological == 1)$title)[1]),
           "Romance" =  selectInput("select", "Anime of Genre #1",
                                  choices = sort(subset(Anime3, Romance == 1)$title),
                                  selected = sort(subset(Anime3, Romance == 1)$title)[1]),
           "Samurai" =  selectInput("select", "Anime of Genre #1",
                                  choices = sort(subset(Anime3, Samurai == 1)$title),
                                  selected = sort(subset(Anime3, Samurai == 1)$title)[1]),
           "School" =  selectInput("select", "Anime of Genre #1",
                                  choices = sort(subset(Anime3, School == 1)$title),
                                  selected = sort(subset(Anime3, School == 1)$title)[1]),
           "Sci-Fi" =  selectInput("select", "Anime of Genre #1",
                                  choices = sort(subset(Anime3, Sci-Fi == 1)$title),
                                  selected = sort(subset(Anime3, Sci-Fi == 1)$title)[1]),
           "Seinen" =  selectInput("select", "Anime of Genre #1",
                                  choices = sort(subset(Anime3, Seinen == 1)$title),
                                  selected = sort(subset(Anime3, Seinen == 1)$title)[1]),
           "Shoujo" =  selectInput("select", "Anime of Genre #1",
                                  choices = sort(subset(Anime3, Shoujo == 1)$title),
                                  selected = sort(subset(Anime3, Shoujo == 1)$title)[1]),
           "Shoujo_Ai" =  selectInput("select", "Anime of Genre #1",
                                  choices = sort(subset(Anime3, Shoujo_Ai == 1)$title),
                                  selected = sort(subset(Anime3, Shoujo_Ai == 1)$title)[1]),
           "Slice_of_Life" =  selectInput("select", "Anime of Genre #1",
                                  choices = sort(subset(Anime3, Slice_of_Life == 1)$title),
                                  selected = sort(subset(Anime3, Slice_of_Life == 1)$title)[1]),
           "Space" =  selectInput("select", "Anime of Genre #1",
                                  choices = sort(subset(Anime3, Space == 1)$title),
                                  selected = sort(subset(Anime3, Space == 1)$title)[1]),
           "Sports" =  selectInput("select", "Anime of Genre #1",
                                  choices = sort(subset(Anime3, Sports == 1)$title),
                                  selected = sort(subset(Anime3, Sports == 1)$title)[1]),
           "Super_Power" =  selectInput("select", "Anime of Genre #1",
                                  choices = sort(subset(Anime3, Super_Power == 1)$title),
                                  selected = sort(subset(Anime3, Super_Power == 1)$title)[1]),
           "Supernatural" =  selectInput("select", "Anime of Genre #1",
                                  choices = sort(subset(Anime3, Supernatural == 1)$title),
                                  selected = sort(subset(Anime3, Supernatural == 1)$title)[1]),
           "Thriller" =  selectInput("select", "Anime of Genre #1",
                                  choices = sort(subset(Anime3, Thriller == 1)$title),
                                  selected = sort(subset(Anime3, Thriller == 1)$title)[1]),
           "Vampire" =  selectInput("select", "Anime of Genre #1",
                                  choices = sort(subset(Anime3, Vampire == 1)$title),
                                  selected = sort(subset(Anime3, Vampire == 1)$title)[1]),
           "Yaoi" =  selectInput("select", "Anime of Genre #1",
                                  choices = sort(subset(Anime3, Yaoi == 1)$title),
                                  selected = sort(subset(Anime3, Yaoi == 1)$title)[1]),
           "Yuri" =  selectInput("select", "Anime of Genre #1",
                                  choices = sort(subset(Anime3, Yuri == 1)$title),
                                  selected = sort(subset(Anime3, Yuri == 1)$title)[1])
    )
  })
  
  output$ui2 <- renderUI({
    if (is.null(input$input_genre2))
      return()
    
    switch(input$input_genre2,
           "Action" = selectInput("select", "Anime of Genre #2",
                                  choices = sort(subset(Anime3, Action == 1)$title),
                                  selected = sort(subset(Anime3, Action == 1)$title)[1]),
           "Adventure" = selectInput("select", "Anime of Genre #2",
                                     choices = sort(subset(Anime3, Adventure == 1)$title),
                                     selected = sort(subset(Anime3, Adventure == 1)$title)[1]),
           "Cars" =  selectInput("select", "Anime of Genre #2",
                                 choices = sort(subset(Anime3, Cars == 1)$title),
                                 selected = sort(subset(Anime3, Cars == 1)$title)[1]),
           "Comedy" =  selectInput("select", "Anime of Genre #2",
                                   choices = sort(subset(Anime3, Comedy == 1)$title),
                                   selected = sort(subset(Anime3, Comedy == 1)$title)[1]),
           "Dementia" =  selectInput("select", "Anime of Genre #2",
                                     choices = sort(subset(Anime3, Dementia == 1)$title),
                                     selected = sort(subset(Anime3, Dementia == 1)$title)[1]),
           "Demons" =  selectInput("select", "Anime of Genre #2",
                                   choices = sort(subset(Anime3, Demons == 1)$title),
                                   selected = sort(subset(Anime3, Demons == 1)$title)[1]),
           "Drama" =  selectInput("select", "Anime of Genre #2",
                                  choices = sort(subset(Anime3, Drama == 1)$title),
                                  selected = sort(subset(Anime3, Drama == 1)$title)[1]),
           "Ecchi" =  selectInput("select", "Anime of Genre #2",
                                  choices = sort(subset(Anime3, Ecchi == 1)$title),
                                  selected = sort(subset(Anime3, Ecchi == 1)$title)[1]),
           "Fantasy" =  selectInput("select", "Anime of Genre #2",
                                    choices = sort(subset(Anime3, Fantasy == 1)$title),
                                    selected = sort(subset(Anime3, Fantasy == 1)$title)[1]),
           "Game" =  selectInput("select", "Anime of Genre #2",
                                 choices = sort(subset(Anime3, Game == 1)$title),
                                 selected = sort(subset(Anime3, Game == 1)$title)[1]),
           "Harem" =  selectInput("select", "Anime of Genre #2",
                                  choices = sort(subset(Anime3, Harem == 1)$title),
                                  selected = sort(subset(Anime3, Harem == 1)$title)[1]),
           "Hentai" =  selectInput("select", "Anime of Genre #2",
                                   choices = sort(subset(Anime3, Hentai == 1)$title),
                                   selected = sort(subset(Anime3, Hentai == 1)$title)[1]),
           "Historical" =  selectInput("select", "Anime of Genre #2",
                                       choices = sort(subset(Anime3, Historical == 1)$title),
                                       selected = sort(subset(Anime3, Historical == 1)$title)[1]),
           "Horror" =  selectInput("select", "Anime of Genre #2",
                                   choices = sort(subset(Anime3, Horror == 1)$title),
                                   selected = sort(subset(Anime3, Horror == 1)$title)[1]),
           "Josei" =  selectInput("select", "Anime of Genre #2",
                                  choices = sort(subset(Anime3, Josei == 1)$title),
                                  selected = sort(subset(Anime3, Josei == 1)$title)[1]),
           "Kids" =  selectInput("select", "Anime of Genre #2",
                                 choices = sort(subset(Anime3, Kids == 1)$title),
                                 selected = sort(subset(Anime3, Kids == 1)$title)[1]),
           "Magic" =  selectInput("select", "Anime of Genre #2",
                                  choices = sort(subset(Anime3, Magic == 1)$title),
                                  selected = sort(subset(Anime3, Magic == 1)$title)[1]),
           "Martial_Arts" = selectInput("select", "Anime of Genre #2",
                                        choices = sort(subset(Anime3,  Martial_Arts == 1)$title),
                                        selected = sort(subset(Anime3, Martial_Arts == 1)$title)[1]),
           "Maecha" =  selectInput("select", "Anime of Genre #2",
                                   choices = sort(subset(Anime3, Mecha == 1)$title),
                                   selected = sort(subset(Anime3, Mecha == 1)$title)[1]),
           "Military" =  selectInput("select", "Anime of Genre #2",
                                     choices = sort(subset(Anime3, Military == 1)$title),
                                     selected = sort(subset(Anime3, Military == 1)$title)[1]),
           "Music" =  selectInput("select", "Anime of Genre #2",
                                  choices = sort(subset(Anime3, Music == 1)$title),
                                  selected = sort(subset(Anime3, Music == 1)$title)[1]),
           "Mystery" =  selectInput("select", "Anime of Genre #2",
                                    choices = sort(subset(Anime3, Mystery == 1)$title),
                                    selected = sort(subset(Anime3, Mystery == 1)$title)[1]),
           "Parody" =  selectInput("select", "Anime of Genre #2",
                                   choices = sort(subset(Anime3, Parody == 1)$title),
                                   selected = sort(subset(Anime3, Parody == 1)$title)[1]),
           "Police" =  selectInput("select", "Anime of Genre #2",
                                   choices = sort(subset(Anime3, Police == 1)$title),
                                   selected = sort(subset(Anime3, Police == 1)$title)[1]),
           "Psychological" =  selectInput("select", "Anime of Genre #2",
                                          choices = sort(subset(Anime3, Psychological == 1)$title),
                                          selected = sort(subset(Anime3, Psychological == 1)$title)[1]),
           "Romance" =  selectInput("select", "Anime of Genre #2",
                                    choices = sort(subset(Anime3, Romance == 1)$title),
                                    selected = sort(subset(Anime3, Romance == 1)$title)[1]),
           "Samurai" =  selectInput("select", "Anime of Genre #2",
                                    choices = sort(subset(Anime3, Samurai == 1)$title),
                                    selected = sort(subset(Anime3, Samurai == 1)$title)[1]),
           "School" =  selectInput("select", "Anime of Genre #2",
                                   choices = sort(subset(Anime3, School == 1)$title),
                                   selected = sort(subset(Anime3, School == 1)$title)[1]),
           "Sci-Fi" =  selectInput("select", "Anime of Genre #2",
                                   choices = sort(subset(Anime3, Sci-Fi == 1)$title),
                                   selected = sort(subset(Anime3, Sci-Fi == 1)$title)[1]),
           "Seinen" =  selectInput("select", "Anime of Genre #2",
                                   choices = sort(subset(Anime3, Seinen == 1)$title),
                                   selected = sort(subset(Anime3, Seinen == 1)$title)[1]),
           "Shoujo" =  selectInput("select", "Anime of Genre #2",
                                   choices = sort(subset(Anime3, Shoujo == 1)$title),
                                   selected = sort(subset(Anime3, Shoujo == 1)$title)[1]),
           "Shoujo_Ai" =  selectInput("select", "Anime of Genre #2",
                                      choices = sort(subset(Anime3, Shoujo_Ai == 1)$title),
                                      selected = sort(subset(Anime3, Shoujo_Ai == 1)$title)[1]),
           "Slice_of_Life" =  selectInput("select", "Anime of Genre #2",
                                          choices = sort(subset(Anime3, Slice_of_Life == 1)$title),
                                          selected = sort(subset(Anime3, Slice_of_Life == 1)$title)[1]),
           "Space" =  selectInput("select", "Anime of Genre #2",
                                  choices = sort(subset(Anime3, Space == 1)$title),
                                  selected = sort(subset(Anime3, Space == 1)$title)[1]),
           "Sports" =  selectInput("select", "Anime of Genre #2",
                                   choices = sort(subset(Anime3, Sports == 1)$title),
                                   selected = sort(subset(Anime3, Sports == 1)$title)[1]),
           "Super_Power" =  selectInput("select", "Anime of Genre #2",
                                        choices = sort(subset(Anime3, Super_Power == 1)$title),
                                        selected = sort(subset(Anime3, Super_Power == 1)$title)[1]),
           "Supernatural" =  selectInput("select", "Anime of Genre #2",
                                         choices = sort(subset(Anime3, Supernatural == 1)$title),
                                         selected = sort(subset(Anime3, Supernatural == 1)$title)[1]),
           "Thriller" =  selectInput("select", "Anime of Genre #2",
                                     choices = sort(subset(Anime3, Thriller == 1)$title),
                                     selected = sort(subset(Anime3, Thriller == 1)$title)[1]),
           "Vampire" =  selectInput("select", "Anime of Genre #2",
                                    choices = sort(subset(Anime3, Vampire == 1)$title),
                                    selected = sort(subset(Anime3, Vampire == 1)$title)[1]),
           "Yaoi" =  selectInput("select", "Anime of Genre #2",
                                 choices = sort(subset(Anime3, Yaoi == 1)$title),
                                 selected = sort(subset(Anime3, Yaoi == 1)$title)[1]),
           "Yuri" =  selectInput("select", "Anime of Genre #2",
                                 choices = sort(subset(Anime3, Yuri == 1)$title),
                                 selected = sort(subset(Anime3, Yuri == 1)$title)[1])
    )
  })
  
  output$ui3 <- renderUI({
    if (is.null(input$input_genre3))
      return()
    
    switch(input$input_genre3,
           "Action" = selectInput("select", "Anime of Genre #3",
                                  choices = sort(subset(Anime3, Action == 1)$title),
                                  selected = sort(subset(Anime3, Action == 1)$title)[1]),
           "Adventure" = selectInput("select", "Anime of Genre #3",
                                     choices = sort(subset(Anime3, Adventure == 1)$title),
                                     selected = sort(subset(Anime3, Adventure == 1)$title)[1]),
           "Cars" =  selectInput("select", "Anime of Genre #3",
                                 choices = sort(subset(Anime3, Cars == 1)$title),
                                 selected = sort(subset(Anime3, Cars == 1)$title)[1]),
           "Comedy" =  selectInput("select", "Anime of Genre #3",
                                   choices = sort(subset(Anime3, Comedy == 1)$title),
                                   selected = sort(subset(Anime3, Comedy == 1)$title)[1]),
           "Dementia" =  selectInput("select", "Anime of Genre #3",
                                     choices = sort(subset(Anime3, Dementia == 1)$title),
                                     selected = sort(subset(Anime3, Dementia == 1)$title)[1]),
           "Demons" =  selectInput("select", "Anime of Genre #3",
                                   choices = sort(subset(Anime3, Demons == 1)$title),
                                   selected = sort(subset(Anime3, Demons == 1)$title)[1]),
           "Drama" =  selectInput("select", "Anime of Genre #3",
                                  choices = sort(subset(Anime3, Drama == 1)$title),
                                  selected = sort(subset(Anime3, Drama == 1)$title)[1]),
           "Ecchi" =  selectInput("select", "Anime of Genre #3",
                                  choices = sort(subset(Anime3, Ecchi == 1)$title),
                                  selected = sort(subset(Anime3, Ecchi == 1)$title)[1]),
           "Fantasy" =  selectInput("select", "Anime of Genre #3",
                                    choices = sort(subset(Anime3, Fantasy == 1)$title),
                                    selected = sort(subset(Anime3, Fantasy == 1)$title)[1]),
           "Game" =  selectInput("select", "Anime of Genre #3",
                                 choices = sort(subset(Anime3, Game == 1)$title),
                                 selected = sort(subset(Anime3, Game == 1)$title)[1]),
           "Harem" =  selectInput("select", "Anime of Genre #3",
                                  choices = sort(subset(Anime3, Harem == 1)$title),
                                  selected = sort(subset(Anime3, Harem == 1)$title)[1]),
           "Hentai" =  selectInput("select", "Anime of Genre #3",
                                   choices = sort(subset(Anime3, Hentai == 1)$title),
                                   selected = sort(subset(Anime3, Hentai == 1)$title)[1]),
           "Historical" =  selectInput("select", "Anime of Genre #3",
                                       choices = sort(subset(Anime3, Historical == 1)$title),
                                       selected = sort(subset(Anime3, Historical == 1)$title)[1]),
           "Horror" =  selectInput("select", "Anime of Genre #3",
                                   choices = sort(subset(Anime3, Horror == 1)$title),
                                   selected = sort(subset(Anime3, Horror == 1)$title)[1]),
           "Josei" =  selectInput("select", "Anime of Genre #3",
                                  choices = sort(subset(Anime3, Josei == 1)$title),
                                  selected = sort(subset(Anime3, Josei == 1)$title)[1]),
           "Kids" =  selectInput("select", "Anime of Genre #3",
                                 choices = sort(subset(Anime3, Kids == 1)$title),
                                 selected = sort(subset(Anime3, Kids == 1)$title)[1]),
           "Magic" =  selectInput("select", "Anime of Genre #3",
                                  choices = sort(subset(Anime3, Magic == 1)$title),
                                  selected = sort(subset(Anime3, Magic == 1)$title)[1]),
           "Martial_Arts" = selectInput("select", "Anime of Genre #3",
                                        choices = sort(subset(Anime3,  Martial_Arts == 1)$title),
                                        selected = sort(subset(Anime3, Martial_Arts == 1)$title)[1]),
           "Maecha" =  selectInput("select", "Anime of Genre #3",
                                   choices = sort(subset(Anime3, Mecha == 1)$title),
                                   selected = sort(subset(Anime3, Mecha == 1)$title)[1]),
           "Military" =  selectInput("select", "Anime of Genre #3",
                                     choices = sort(subset(Anime3, Military == 1)$title),
                                     selected = sort(subset(Anime3, Military == 1)$title)[1]),
           "Music" =  selectInput("select", "Anime of Genre #3",
                                  choices = sort(subset(Anime3, Music == 1)$title),
                                  selected = sort(subset(Anime3, Music == 1)$title)[1]),
           "Mystery" =  selectInput("select", "Anime of Genre #3",
                                    choices = sort(subset(Anime3, Mystery == 1)$title),
                                    selected = sort(subset(Anime3, Mystery == 1)$title)[1]),
           "Parody" =  selectInput("select", "Anime of Genre #3",
                                   choices = sort(subset(Anime3, Parody == 1)$title),
                                   selected = sort(subset(Anime3, Parody == 1)$title)[1]),
           "Police" =  selectInput("select", "Anime of Genre #3",
                                   choices = sort(subset(Anime3, Police == 1)$title),
                                   selected = sort(subset(Anime3, Police == 1)$title)[1]),
           "Psychological" =  selectInput("select", "Anime of Genre #3",
                                          choices = sort(subset(Anime3, Psychological == 1)$title),
                                          selected = sort(subset(Anime3, Psychological == 1)$title)[1]),
           "Romance" =  selectInput("select", "Anime of Genre #3",
                                    choices = sort(subset(Anime3, Romance == 1)$title),
                                    selected = sort(subset(Anime3, Romance == 1)$title)[1]),
           "Samurai" =  selectInput("select", "Anime of Genre #3",
                                    choices = sort(subset(Anime3, Samurai == 1)$title),
                                    selected = sort(subset(Anime3, Samurai == 1)$title)[1]),
           "School" =  selectInput("select", "Anime of Genre #3",
                                   choices = sort(subset(Anime3, School == 1)$title),
                                   selected = sort(subset(Anime3, School == 1)$title)[1]),
           "Sci-Fi" =  selectInput("select", "Anime of Genre #3",
                                   choices = sort(subset(Anime3, Sci-Fi == 1)$title),
                                   selected = sort(subset(Anime3, Sci-Fi == 1)$title)[1]),
           "Seinen" =  selectInput("select", "Anime of Genre #3",
                                   choices = sort(subset(Anime3, Seinen == 1)$title),
                                   selected = sort(subset(Anime3, Seinen == 1)$title)[1]),
           "Shoujo" =  selectInput("select", "Anime of Genre #3",
                                   choices = sort(subset(Anime3, Shoujo == 1)$title),
                                   selected = sort(subset(Anime3, Shoujo == 1)$title)[1]),
           "Shoujo_Ai" =  selectInput("select", "Anime of Genre #3",
                                      choices = sort(subset(Anime3, Shoujo_Ai == 1)$title),
                                      selected = sort(subset(Anime3, Shoujo_Ai == 1)$title)[1]),
           "Slice_of_Life" =  selectInput("select", "Anime of Genre #3",
                                          choices = sort(subset(Anime3, Slice_of_Life == 1)$title),
                                          selected = sort(subset(Anime3, Slice_of_Life == 1)$title)[1]),
           "Space" =  selectInput("select", "Anime of Genre #3",
                                  choices = sort(subset(Anime3, Space == 1)$title),
                                  selected = sort(subset(Anime3, Space == 1)$title)[1]),
           "Sports" =  selectInput("select", "Anime of Genre #3",
                                   choices = sort(subset(Anime3, Sports == 1)$title),
                                   selected = sort(subset(Anime3, Sports == 1)$title)[1]),
           "Super_Power" =  selectInput("select", "Anime of Genre #3",
                                        choices = sort(subset(Anime3, Super_Power == 1)$title),
                                        selected = sort(subset(Anime3, Super_Power == 1)$title)[1]),
           "Supernatural" =  selectInput("select", "Anime of Genre #3",
                                         choices = sort(subset(Anime3, Supernatural == 1)$title),
                                         selected = sort(subset(Anime3, Supernatural == 1)$title)[1]),
           "Thriller" =  selectInput("select", "Anime of Genre #3",
                                     choices = sort(subset(Anime3, Thriller == 1)$title),
                                     selected = sort(subset(Anime3, Thriller == 1)$title)[1]),
           "Vampire" =  selectInput("select", "Anime of Genre #3",
                                    choices = sort(subset(Anime3, Vampire == 1)$title),
                                    selected = sort(subset(Anime3, Vampire == 1)$title)[1]),
           "Yaoi" =  selectInput("select", "Anime of Genre #3",
                                 choices = sort(subset(Anime3, Yaoi == 1)$title),
                                 selected = sort(subset(Anime3, Yaoi == 1)$title)[1]),
           "Yuri" =  selectInput("select", "Anime of Genre #3",
                                 choices = sort(subset(Anime3, Yuri == 1)$title),
                                 selected = sort(subset(Anime3, Yuri == 1)$title)[1])
    )
  })
  
  output$table <- renderTable({
    Anime_recommendation(input$select, input$select2, input$select3)
  })
  
  output$dynamic_value <- renderPrint({
    c(input$select,input$select2,input$select3)
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

