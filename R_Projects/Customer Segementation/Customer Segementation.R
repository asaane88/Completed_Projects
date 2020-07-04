##################Customer Segmentation using Machine Learning in R###########
  
## 1. Import Data
customer_data=read.csv("/home/dataflair/Mall_Customers.csv")
str(customer_data)
names(customer_data)

## 2. Data Exploration
head(customer_data)
summary(customer_data$Age)

## 3. Summary Statistics
sd(customer_data$Age)
summary(customer_data$Annual.Income..k..)
sd(customer_data$Annual.Income..k..)
summary(customer_data$Age)

sd(customer_data$Spending.Score..1.100.)

## 4. Customer Gender Visualization
a=table(customer_data$Gender)
barplot(a,main="Using BarPlot to display Gender Comparision",
        ylab="Count",
        xlab="Gender",
        col=rainbow(2),
        legend=rownames(a))

## Inference: 
##From the above barplot, we observe that the number of females is higher than the males. 
## Now, let us visualize a pie chart to observe the ratio of male and female distribution.

pct=round(a/sum(a)*100)
lbs=paste(c("Female","Male")," ",pct,"%",sep=" ")
library(plotrix)
pie3D(a,labels=lbs,
      main="Pie Chart Depicting Ratio of Female and Male")


##Inference: 
## From the above graph, we conclude that the percentage of females is 56%, 
## whereas the percentage of male in the customer dataset is 44%.

## Visualization of Age Distribution
summary(customer_data$Age)

hist(customer_data$Age,
     col="blue",
     main="Histogram to Show Count of Age Class",
     xlab="Age Class",
     ylab="Frequency",
     labels=TRUE)

boxplot(customer_data$Age,
        col="ff0066",
        main="Boxplot for Descriptive Analysis of Age")

## Inference
##From the above two visualizations, we conclude that the maximum customer ages are between 30 and 35.
## The minimum age of customers is 18, whereas, the maximum age is 70.

## Analysis of the Annual Income of the Customers
summary(customer_data$Annual.Income..k..)
hist(customer_data$Annual.Income..k..,
     col="#660033",
     main="Histogram for Annual Income",
     xlab="Annual Income Class",
     ylab="Frequency",
     labels=TRUE)

plot(density(customer_data$Annual.Income..k..),
     col="yellow",
     main="Density Plot for Annual Income",
     xlab="Annual Income Class",
     ylab="Density")
polygon(density(customer_data$Annual.Income..k..),
        col="#ccff66")

## Inference
##From the above descriptive analysis, we conclude that the minimum annual income of the customers is 15 and the maximum income is 137. 
##People earning an average income of 70 have the highest frequency count in our histogram distribution. 
##The average salary of all the customers is 60.56. 
##In the Kernel Density Plot that we displayed above, we observe that the annual income has a normal distribution.


## Analyzing Spending Score of the Customers
summary(customer_data$Spending.Score..1.100.)

boxplot(customer_data$Spending.Score..1.100.,
        horizontal=TRUE,
        col="#990000",
        main="BoxPlot for Descriptive Analysis of Spending Score")

hist(customer_data$Spending.Score..1.100.,
     main="HistoGram for Spending Score",
     xlab="Spending Score Class",
     ylab="Frequency",
     col="#6600cc",
     labels=TRUE)

## Inference
##The minimum spending score is 1, maximum is 99 and the average is 50.20. 
## We can see Descriptive Analysis of Spending Score is that Min is 1, Max is 99 and avg. is 50.20.
##From the histogram, we conclude that customers between class 40 and 50 have the highest spending score among all the classes.

##############--------K-means Algorithm--------------######################

## 1. ELBOW PLOT METHOD
library(purrr)
set.seed(123)

# function to calculate total intra-cluster sum of square 
iss <- function(k) {
  kmeans(customer_data[,3:5],k,iter.max=100,nstart=100,algorithm="Lloyd" )$tot.withinss
}

k.values <- 1:10

iss_values <- map_dbl(k.values, iss)

plot(k.values, iss_values,
     type="b", pch = 19, frame = FALSE, 
     xlab="Number of clusters K",
     ylab="Total intra-clusters sum of squares")


## Inference:
##From the above graph, we conclude that 4 is the appropriate number of clusters 
##since it seems to be appearing at the bend in the elbow plot.

##2. Average Silhouette Method

library(cluster) 
library(gridExtra)
library(grid)
k2<-kmeans(customer_data[,3:5],2,iter.max=100,nstart=50,algorithm="Lloyd")
s2<-plot(silhouette(k2$cluster,dist(customer_data[,3:5],"euclidean")))

k3<-kmeans(customer_data[,3:5],3,iter.max=100,nstart=50,algorithm="Lloyd")
s3<-plot(silhouette(k3$cluster,dist(customer_data[,3:5],"euclidean")))

k4<-kmeans(customer_data[,3:5],4,iter.max=100,nstart=50,algorithm="Lloyd")
s4<-plot(silhouette(k4$cluster,dist(customer_data[,3:5],"euclidean")))

k5<-kmeans(customer_data[,3:5],5,iter.max=100,nstart=50,algorithm="Lloyd")
s5<-plot(silhouette(k5$cluster,dist(customer_data[,3:5],"euclidean")))


k6<-kmeans(customer_data[,3:5],6,iter.max=100,nstart=50,algorithm="Lloyd")
s6<-plot(silhouette(k6$cluster,dist(customer_data[,3:5],"euclidean")))

k7<-kmeans(customer_data[,3:5],7,iter.max=100,nstart=50,algorithm="Lloyd")
s7<-plot(silhouette(k7$cluster,dist(customer_data[,3:5],"euclidean")))

k8<-kmeans(customer_data[,3:5],8,iter.max=100,nstart=50,algorithm="Lloyd")
s8<-plot(silhouette(k8$cluster,dist(customer_data[,3:5],"euclidean")))

k9<-kmeans(customer_data[,3:5],9,iter.max=100,nstart=50,algorithm="Lloyd")
s9<-plot(silhouette(k9$cluster,dist(customer_data[,3:5],"euclidean")))

k10<-kmeans(customer_data[,3:5],10,iter.max=100,nstart=50,algorithm="Lloyd")
s10<-plot(silhouette(k10$cluster,dist(customer_data[,3:5],"euclidean")))

##Optimal No of Clusters
library(NbClust)
library(factoextra)
fviz_nbclust(customer_data[,3:5], kmeans, method = "silhouette")

###3. Gap Statistic Method
set.seed(125)
stat_gap <- clusGap(customer_data[,3:5], FUN = kmeans, nstart = 25,
                    K.max = 10, B = 50)
fviz_gap_stat(stat_gap)

##Optimal Cluster
k6<-kmeans(customer_data[,3:5],6,iter.max=100,nstart=50,algorithm="Lloyd")
k6

##Visualizing the Clustering Results using the First Two Principle Components

pcclust=prcomp(customer_data[,3:5],scale=FALSE) #principal component analysis
summary(pcclust)
pcclust$rotation[,1:2]

set.seed(1)
ggplot(customer_data, aes(x =Annual.Income..k.., y = Spending.Score..1.100.)) + 
  geom_point(stat = "identity", aes(color = as.factor(k6$cluster))) +
  scale_color_discrete(name=" ",
                       breaks=c("1", "2", "3", "4", "5","6"),
                       labels=c("Cluster 1", "Cluster 2", "Cluster 3", "Cluster 4", "Cluster 5","Cluster 6")) +
  ggtitle("Segments of Mall Customers", subtitle = "Using K-means Clustering")

##From the above visualization, we observe that there is a distribution of 6 clusters as follows -

##Cluster 6 and 4 - These clusters represent the customer_data with the medium income salary as well as the medium annual spend of salary.
##Cluster 1 - This cluster represents the customer_data having a high annual income as well as a high annual spend.
##Cluster 3 - This cluster denotes the customer_data with low annual income as well as low yearly spend of income.
##Cluster 2 - This cluster denotes a high annual income and low yearly spend.
##Cluster 5 - This cluster represents a low annual income but its high yearly expenditure.

ggplot(customer_data, aes(x =Spending.Score..1.100., y =Age)) + 
  geom_point(stat = "identity", aes(color = as.factor(k6$cluster))) +
  scale_color_discrete(name=" ",
                       breaks=c("1", "2", "3", "4", "5","6"),
                       labels=c("Cluster 1", "Cluster 2", "Cluster 3", "Cluster 4", "Cluster 5","Cluster 6")) +
  ggtitle("Segments of Mall Customers", subtitle = "Using K-means Clustering")

kCols=function(vec){cols=rainbow (length (unique (vec)))
return (cols[as.numeric(as.factor(vec))])}
digCluster<-k6$cluster; dignm<-as.character(digCluster); # K-means clusters
plot(pcclust$x[,1:2], col =kCols(digCluster),pch =19,xlab ="K-means",ylab="classes")
legend("bottomleft",unique(dignm),fill=unique(kCols(digCluster)))

##Cluster 4 and 1 - These two clusters consist of customers with medium PCA1 and medium PCA2 score.
## Cluster 6 - This cluster represents customers having a high PCA2 and a low PCA1.
## Cluster 5 - In this cluster, there are customers with a medium PCA1 and a low PCA2 score.
##Cluster 3 - This cluster comprises of customers with a high PCA1 income and a high PCA2.
## Cluster 2 - This comprises of customers with a high PCA2 and a medium annual spend of income.

## With the help of clustering, we can understand the variables much better, prompting us to take careful decisions. 
##With the identification of customers, companies can release products and services that target customers based on several parameters like income, age, spending patterns, etc. 
##Furthermore, more complex patterns like product reviews are taken into consideration for better segmentation.
