# Project2: Employee Retention Model

• Received a HR dataset **(15000 observations)** of employees who are still working and those who have have left with 8 input features.

• Conducted a thorough **exploratory data analysis** and performed **bivariate segmentation analysis** and visualization to understand the conditions under which people are staying or leaving.

• Performed **data cleaning** actions to deal with missing numerical features, missing categorical features and fixed some structural errors in the dataframe.

• Engineered **new features** based on the understanding gained by analyzing bivariate segmentation of different numerical features alongside the target variable and constructed a good Analytical Base Table (ABT).

• Reviewed **L1-LogisticRegressor, L2-LogisticRegressor, RandomForestClassifier and GradientBoostingClassifier**.

• Created **pre-processing pipelines** with StandardScaler and Model classes.

• Set appropriate **hyperparameters** and create a dictionary for all model classes.

• Using the pipelines object and hyperparameter dictionary object trained the models inside **GridSearchCV** object by splitting the ABT into Train / Test sets.

• Checked **AUC_ROC_SCORE** for the fitted models by predicting with the test set and selected the winning pipeline object and saved the model.

• Built a custom Python class by pulling out data cleaning steps and feature engineering steps and creating two functions.

• Using the custom Python class demonstrated the HR team on how to make predictions for raw unseen new data.
