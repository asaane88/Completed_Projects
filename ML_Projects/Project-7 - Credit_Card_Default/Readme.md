# Default-of-credit-card-clients
This research aimed at the case of customers default payments in Taiwan and compares the predictive accuracy of probability of default among five data mining methods.

## Data Set Information:
This research aimed at the case of customers default payments in Taiwan and compares the predictive accuracy of probability of default among five data mining methods. From the perspective of risk management, the result of predictive accuracy of the estimated probability of default will be more valuable than the binary result of classification - credible or not credible clients. Because the real probability of default is unknown, this study presented the novel Sorting Smoothing Method to estimate the real probability of default. With the real probability of default as the **response variable (Y)**, and the predictive probability of default as the **independent variable (X)**, the simple linear regression result **(Y = A + BX)** shows that the forecasting model produced by artificial neural network has the highest coefficient of determination; its regression intercept (A) is close to zero, and regression coefficient (B) to one. Therefore, among the five data mining techniques, artificial neural network is the only one that can accurately estimate the real probability of default.

## Attribute Information:
This research employed a binary variable, default payment (Yes = 1, No = 0), as the response variable. 
This study reviewed the literature and used the following 23 variables as explanatory variables: 
1. **X1**: Amount of the given credit (NT dollar): it includes both the individual consumer credit and his/her family (supplementary) credit. 
2. **X2**: Gender (1 = male; 2 = female). 
3. **X3**: Education (1 = graduate school; 2 = university; 3 = high school; 4 = others). 
4. **X4**: Marital status (1 = married; 2 = single; 3 = others). 
5. **X5**: Age (year). 
    **X6 - X11**: History of past payment. We tracked the past monthly payment records (from April to September, 2005) as follows: 
7. **X6** = the repayment status in September, 2005; 
8. **X7** = the repayment status in August, 2005; . . .;
9. **X11** = the repayment status in April, 2005. 
    The measurement scale for the repayment status is: 
    * -1 = pay duly; 
    *  1 = payment delay for one month; 
    *  2 = payment delay for two months; . . .; 
    *  8 = payment delay for eight months; 
    *  9 = payment delay for nine months and above. 
10. **X12-X17**: Amount of bill statement (NT dollar). 
11. **X12** = amount of bill statement in September, 2005; 
12. **X13** = amount of bill statement in August, 2005; . . .; 
13. **X17** = amount of bill statement in April, 2005. 
14. **X18-X23**: Amount of previous payment (NT dollar). 
15. **X18** = amount paid in September, 2005; 
16. **X19** = amount paid in August, 2005; . . .;
17. **X23** = amount paid in April, 2005.

## Relevant Papers:
Yeh, I. C., & Lien, C. H. (2009). The comparisons of data mining techniques for the predictive accuracy of probability of default of credit card clients. Expert Systems with Applications, 36(2), 2473-2480.

## Citation Request:
Yeh, I. C., & Lien, C. H. (2009). The comparisons of data mining techniques for the predictive accuracy of probability of default of credit card clients. Expert Systems with Applications, 36(2), 2473-2480.
