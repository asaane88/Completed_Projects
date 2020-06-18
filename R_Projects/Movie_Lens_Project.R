###Step 1) Download MovieLens Data
###The dataset 'movielens' gets split into a training-testset called 'edx' and a set for validation purposes called 'validation'.

#############################################################
# Create edx set, validation set, and submission file
#############################################################

# Note: this process could take a couple of minutes

if(!require(tidyverse)) install.packages("tidyverse", repos = "http://cran.us.r-project.org")
if(!require(caret)) install.packages("caret", repos = "http://cran.us.r-project.org")

# MovieLens 10M dataset:
# https://grouplens.org/datasets/movielens/10m/
# http://files.grouplens.org/datasets/movielens/ml-10m.zip

#To speed up data loading, the final result was already saved as 'movielens.csc'
step <- 'load_data'#new_analysis

if (step == 'new_analysis') {
  
  dl <- tempfile()
  download.file("http://files.grouplens.org/datasets/movielens/ml-10m.zip", dl)
  
  ratings <- read.table(text = gsub("::", "\t", readLines(unzip(dl, "ml-10M100K/ratings.dat"))),
                        col.names = c("userId", "movieId", "rating", "timestamp"))
  
  movies <- str_split_fixed(readLines(unzip(dl, "ml-10M100K/movies.dat")), "\\::", 3)
  colnames(movies) <- c("movieId", "title", "genres")
  movies <- as.data.frame(movies) %>% mutate(movieId = as.numeric(levels(movieId))[movieId],
                                             title = as.character(title),
                                             genres = as.character(genres))
  
  movielens <- left_join(ratings, movies, by = "movieId")
  
  #Shortcut for testing purposes:
} else {  
  movielens <- read.csv("ml-10M100K/movielens.csv", row.names = 1)
}

# Validation set will be 10% of MovieLens data

set.seed(1)
test_index <- createDataPartition(y = movielens$rating, times = 1, p = 0.1, list = FALSE)
edx <- movielens[-test_index,]
temp <- movielens[test_index,]

# Make sure userId and movieId in validation set are also in edx set

validation <- temp %>% 
  semi_join(edx, by = "movieId") %>%
  semi_join(edx, by = "userId")

# Add rows removed from validation set back into edx set

removed <- anti_join(temp, validation)
edx <- rbind(edx, removed)

# Learners will develop their algorithms on the edx set
# For grading, learners will run algorithm on validation set to generate ratings

validation <- validation %>% select(-rating)

###Step 2) Exploratory Data Analysis

#Q1) How many rows and columns are there in the edx dataset?
load(file='Workspace_Capstone_03_final.RData')
paste('The edx dataset has',nrow(edx),'rows and',ncol(edx),'columns.')

#Q2) How many zeros and threes were given in the edx dataset?
paste(sum(edx$rating == 0), 'ratings with 0 were given and', sum(edx$rating == 3),'ratings with 3')

#Q3) How many different movies are in the edx dataset?
edx %>% summarize(n_movies = n_distinct(movieId))

#Q4) How many different users are in the edx dataset?
edx %>% summarize(n_users = n_distinct(userId))

#Q5) How many movie ratings are in cear of the following genres in the edx dataset?
drama <- edx %>% filter(str_detect(genres,"Drama"))
comedy <- edx %>% filter(str_detect(genres,"Comedy"))
thriller <- edx %>% filter(str_detect(genres,"Thriller"))
romance <- edx %>% filter(str_detect(genres,"Romance"))

paste('Drama has',nrow(drama),'movies')
paste('Comedy has',nrow(comedy),'movies')
paste('Thriller has',nrow(thriller),'movies')
paste('Romance has',nrow(romance),'movies')

#Q6) Which movie has the greatest number of ratings?
edx %>% group_by(title) %>% summarise(number = n()) %>%
  arrange(desc(number))  

#Q7) What are the five most given ratings in order from most to least?
head(sort(-table(edx$rating)),5)

#Q8) True or False: In general, half star ratings are less common than whole star ratings (e.g., there are fewer ratings of 3.5 than there are ratings of 3 or 4, etc.).
table(edx$rating)

#####Data Analysis#############

str(movielens)

hist(movielens$rating,
     col = "#2E9FDF")

summary(movielens$rating)

#Ratings range from 0.5 to 5.0. The difference in median an mean shows that the distribution is skewed towards higher ratings. 
#The chart shows that whole-number ratings are more common that 0.5 ratings.

movielens$year <- as.numeric(substr(as.character(movielens$title),nchar(as.character(movielens$title))-4,nchar(as.character(movielens$title))-1))

plot(table(movielens$year),
     col = "#2E9FDF")

avg_ratings <- movielens %>% group_by(year) %>% summarise(avg_rating = mean(rating))
plot(avg_ratings,
     col = "#2E9FDF")

######Export Predictions#####

# Ratings will go into the CSV submission file below:

write.csv(validation %>% select(userId, movieId) %>% mutate(rating = pred_y_lse),
          "submission.csv", na = "", row.names=FALSE)


####Conclusion
#The aim of the project was to predict movieratings from a long list of rated movies. 


################# RESULTS ##############

#Root Mean Square Error Loss Function
RMSE <- function(true_ratings, predicted_ratings){
  sqrt(mean((true_ratings - predicted_ratings)^2))
}

lambdas <- seq(0, 5, 0.25)

rmses <- sapply(lambdas,function(l){
  
  #Calculate the mean of ratings from the edx training set
  mu <- mean(edx$rating)
  
  #Adjust mean by movie effect and penalize low number on ratings
  b_i <- edx %>% 
    group_by(movieId) %>%
    summarize(b_i = sum(rating - mu)/(n()+l))
  
  #ajdust mean by user and movie effect and penalize low number of ratings
  b_u <- edx %>% 
    left_join(b_i, by="movieId") %>%
    group_by(userId) %>%
    summarize(b_u = sum(rating - b_i - mu)/(n()+l))
  
  #predict ratings in the training set to derive optimal penalty value 'lambda'
  predicted_ratings <- 
    edx %>% 
    left_join(b_i, by = "movieId") %>%
    left_join(b_u, by = "userId") %>%
    mutate(pred = mu + b_i + b_u) %>%
    .$pred
  
  return(RMSE(predicted_ratings, edx$rating))
})

plot(lambdas, rmses,
     col = "#2E9FDF")

lambda <- lambdas[which.min(rmses)]
paste('Optimal RMSE of',min(rmses),'is achieved with Lambda',lambda)
