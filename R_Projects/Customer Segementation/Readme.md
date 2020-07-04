# Customer Segmentation

## Overview
Customer Segmentation is one the most important applications of unsupervised learning. Using clustering techniques, companies can identify the several segments of customers allowing them to target the potential user base. In this machine learning project, We will see the background of customer segmentation. Then we will explore the data upon which we will be building our segmentation model. Also, in this data science project, we will see the descriptive analysis of our data and then implement several versions of the K-means algorithm.

## What is Customer Segmentation?
Customer Segmentation is the process of division of customer base into several groups of individuals that share a similarity in different ways that are relevant to marketing such as gender, age, interests, and miscellaneous spending habits.

## Steps Involved in Implementation of Customer Segmentation in R
1. Data Exploration 
  * Customer Gender Visualization
  * Visualization of Age Distribution
  * Analysis of the Annual Income of the Customers
  * Analyzing Spending Score of the Customers
2. K-means Algorithm
  * Determining Optimal Clusters
    - Elbow method
    - Silhouette method
    - Gap statistic
  * Gap Statistic Method
  * Visualizing the Clustering Results
  
## Observations
In this Project we have found 6 clusters based on several parameters like income, age, spending patterns, etc. The below is the list of clusters

***Cluster 4 and 1*** – These two clusters consist of customers with medium PCA1 and medium PCA2 score.

***Cluster 6*** – This cluster represents customers having a high PCA2 and a low PCA1.

***Cluster 5*** – In this cluster, there are customers with a medium PCA1 and a low PCA2 score.

***Cluster 3*** – This cluster comprises of customers with a high PCA1 income and a high PCA2.

***Cluster 2*** – This comprises of customers with a high PCA2 and a medium annual spend of income.
  
## Summary
In this data science project, we went through the customer segmentation model. We developed this using a class of machine learning known as unsupervised learning. Specifically, we made use of a clustering algorithm called K-means clustering. We analyzed and visualized the data and then proceeded to implement our algorithm.
