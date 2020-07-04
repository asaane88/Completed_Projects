# Real Estate Transaction Price Prediction Model: 

## Project Overview

• Performed thorough **exploratory analysis** of the dataset by systematically going through the 
    - Basic information, 
    - Numerical Distributions, 
    - Categorical Distributions, 
    - Segmenting Numerical information against the categorical features and 
    - Correlation Analysis

• Based on the understanding of the dataset, performed several **data cleaning** actions such as 
    - Removing Duplicates, 
    - Fixing Structural Errors, 
    - Dealing with missing categorical features as well as missing numerical features. 
    - Used Data Visualization tools and statistical analysis and 
    - Performed Outlier Analysis and 
    - Removed some Unwanted Observations.

• Performed **feature engineering** step by bringing some domain knowledge of the seniors and engineered new features that bring more useful insights from the data and constructed a decent Analytical Base Table (ABT).

• Reviewed five popular regression algorithms **(LASSO, Ridge, ElasticNet, RandomForestRegressor and GradientBoostingRegressor)**. Created pre-processing pipelines using StandardScaler for each of the model class. Reviewed most important hyperparameters and created a grid with the most useful settings. Using the pipelines object and hyperparameter dictionary object trained the models inside GridSearchCV object by splitting the ABT into Train / Test sets.

• **Tested the fitted models** with test set and checked R-Squared and Mean Absolute Error (MAE) metrics. Compared the hold-out scores and test scores and selected the winning model and saved the pipeline object with best estimator attribute.

• Saved the winning pipeline object and delivered to the client.

## STEP1: Exploratory Data Analysis
1. Dataframe Dimensions
2. Distribution of Numeric Features
3. Distribution of categorical features
4. Segmentations
5. Correlations

## STEP2: Different Types of Cleaning
1. Remove unwanted observations
2. Fix Structural Errors
3. Remove Unwanted Outliers
4. Missing Categorical Data
5. Missing Numeric Data

## STEP3: Feature Engineering
1. Apply Domain Knowledge
2. Interaction Features
3. Sparse Classes
4. Introduce Dummy Variables
5. Remove Unused features

## STEP4: Model Training 
1. Split Dataset
2. Model Pipelines
3. Declare Hyperparameters
4. Cross Validation
5. Select Winner Model - Our Winner Model was Random Forest with MAE of 68069.1971

## STEP5: Model Building
1. I transformed the categorical variables into dummy variables. 
2. I also split the data into train and tests sets with a test size of 20%.
3. I tried three different models and evaluated them using Mean Absolute Error. 
4. I choose MAE because it is relatively easy to interpret and outliers aren’t particularly bad in for this type of model.
5. I tried three different models:
    * **Multiple Linear Regression** – Baseline for the model
    * **Lasso Regression** – Because of the sparse data from the many categorical variables, I thought a normalized regression like lasso would be effective.
    * **Random Forest** – Again, with the sparsity associated with the data, I thought that this would be a good fit.

## STEP6:Model performance
The Random Forest model far outperformed the other approaches on the test and validation sets.

* **Random Forest : MAE = 68069.1971**
* **Gradient Boosting: MAE = 70647.2441
* **Lasso Regression: MAE = 85072.8543
* **Ridge Regression: MAE = 85012.1669
* **ElasticNet Regression: MAE = 86325.61
