Demand Forecasting in Machine Learning

## Design Algorithm for ML-Based Demand Forecasting Solutions
When initiating the demand forecasting feature development, it’s recommended to understand the workflow of ML modeling. This offers a data-driven roadmap on how to optimize the development process.

Let’s review the process of how we approach ML demand forecasting tasks.

### STEP 1. BRIEF DATA REVIEW
The first task when initiating the demand forecasting project is to provide the client with meaningful insights. The process includes the following steps:

1. Gather available data
2. Briefly review the data structure, accuracy, and consistency
3. Run a few data tests and pilots

In my experience, a few days is enough to understand the current situation and outline possible solutions.

### STEP 2. SETTING BUSINESS GOALS AND SUCCESS METRICS
This stage establishes the client’s highlights of business aims and additional conditions to be taken into account. 

**Product Type/Categories**

What types of products/product categories will you forecast? Different products/services have different demand forecasting outputs. 
For example, the demand forecast for perishable products and subscription services coming at the same time each month will likely be different.

**Time Frame**

What is the length of time for the demand forecast?
Short-term forecasts are commonly done for less than 12 months – 1 week/1 month/6 month. 

These forecasts may have the following purposes:
- Uninterrupted supply of products/services
- Sales target setting and evaluating sales performance
- Optimization of prices according to the market fluctuations and inflation
- Finance maintenance
- Hiring of required specialists
- Long-term forecasts are completed for periods longer than a year. 

The purpose of long-term forecasts may include the following:
* Long-term financial planning and funds acquisition
* Decision making regarding the expansion of business
* Annual strategic planning
* Accuracy

What is the minimum required percentage of demand forecast accuracy for making informed decisions?
Implementing retail software development projects, we were able to reach an average accuracy level of 95.96% for positions with enough data. 
The minimum required forecast accuracy level is set depending on your business goals.

The example of metrics to measure the forecast accuracy are MAPE (Mean Absolute Percentage Error), MAE (Mean Absolute Error) or custom metrics.

### STEP 3. DATA PREPARATION & UNDERSTANDING
Regardless of what we’d like to predict, data quality is a critical component of an accurate demand forecast.

### STEP 4. MACHINE LEARNING MODELS DEVELOPMENT
There are no “one-size-fits-all” forecasting algorithms. Often, demand forecasting features consist of several machine learning approaches. 
The choice of machine learning models depends on several factors, such as business goal, data type, data amount and quality, forecasting period, etc.

Here I describe those machine learning approaches when applied to our retail clients. But if you have already read some articles about demand forecasting, you might discover that these approaches work for most demand forecasting cases.
* Time Series
* Linear Regression
* Feature Engineering
* Random Forest

### STEP 5. TRAINING & DEPLOYMENT

#### Training
Once the forecasting models are developed, it’s time to start the training process. 
When training forecasting models, data scientists usually use historical data. By processing this data, algorithms provide ready-to-use trained model(s).

#### Validation
This step requires the optimization of the forecasting model parameters to achieve high performance. 
By using a cross-validation tuning method where the training dataset is split into ten equal parts, data scientists train forecasting models with different sets of hyper-parameters. 
The goal of this method is to figure out which model has the most accurate forecast.

#### Improvement
When researching the best business solutions, data scientists usually develop several machine learning models. 
Since models show different levels of accuracy, the scientists choose the ones that cover their business needs the best.

#### Deployment
This stage assumes the forecasting model(s) integration into production use. 
We also recommend setting a pipeline to aggregate new data to use for your next AI features. This can save you a lot of data preparation work in future projects. Doing this also increases the accuracy and variety of what you could be able to forecast.
