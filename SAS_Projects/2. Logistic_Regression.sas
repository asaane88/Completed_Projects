
/*Load Data In */
libname hf '/home/u36241478/LogRegHomework/logdata';

/*See general frequencies in the data set */

proc freq data=hf.classified_cities_hf order=freq;
	where Provider_State in ('IN','MO'); 
	tables class_var_hf;
run;

/******* SUMMARY GRAPHIC AND FINDING OF INTEREST *********/

ods graphics on;
title 'Summary Of All Predictor Variables';
proc corr data=hf.classified_cities_hf nomiss plots=matrix(histogram) plots(maxpoints=100000);
	var var_BPHIGH var_CHD var_CSMOKING var_BPMED var_OBESITY var_ACCESS2;
run;
ods graphics off;

/* Interesting that smoking alone did not lead to *
   statistically significant results as none of the
   P-values even cleared the 5% threshold.   */
  
proc logistic data=hf.classified_cities_hf outmodel=pout;
	where Provider_State in ('IN','MO'); 
	model class_var_hf=var_CSMOKING;
run;	

/************* SINGLE VARIABLE LOGISTIC REGRESSION ***********************/

/* BPHigh is the best single variable model smallest P-value, largest chi-square */

/*
 * High blood pressure was chosen because it will impact heart failure (HF)
 * 

Response Profile
Ordered
Value	class_var_hf	Total
Frequency
1	Low	22
2	Medi	19
Probability modeled is class_var_hf='Low'.

Model Convergence Status
Convergence criterion (GCONV=1E-8) satisfied.
Model Fit Statistics
Criterion	Intercept Only	Intercept and Covariates
AIC	58.618	52.973
SC	60.332	56.401
-2 Log L	56.618	48.973
Testing Global Null Hypothesis: BETA=0
Test	Chi-Square	DF	Pr > ChiSq
Likelihood Ratio	7.6450	1	0.0057
Score	6.6769	1	0.0098
Wald	5.4782	1	0.0193
Analysis of Maximum Likelihood Estimates
Parameter	DF	Estimate	Standard
Error	Wald
Chi-Square	Pr > ChiSq
Intercept	1	-8.6221	3.7547	5.2734	0.0217
var_BPHIGH	1	0.2670	0.1141	5.4782	0.0193
Odds Ratio Estimates
Effect	Point Estimate	95% Wald
Confidence Limits
var_BPHIGH	1.306	1.044	1.633
Association of Predicted Probabilities and Observed Responses
Percent Concordant	64.8	Somers' D	0.385
Percent Discordant	26.3	Gamma	0.423
Percent Tied	8.9	Tau-a	0.196
Pairs	418	c	0.693
 * 
 */
proc logistic data=hf.classified_cities_hf outmodel=pout;
	where Provider_State in ('IN','MO'); 
	model class_var_hf=var_BPHIGH;
run;





/*
 * Coronary heart disease is a type of HF so it was chose


Model Convergence Status
Convergence criterion (GCONV=1E-8) satisfied.
Model Fit Statistics
Criterion	Intercept Only	Intercept and Covariates
AIC	58.618	53.693
SC	60.332	57.120
-2 Log L	56.618	49.693
Testing Global Null Hypothesis: BETA=0
Test	Chi-Square	DF	Pr > ChiSq
Likelihood Ratio	6.9256	1	0.0085
Score	6.2580	1	0.0124
Wald	4.6374	1	0.0313
Analysis of Maximum Likelihood Estimates
Parameter	DF	Estimate	Standard
Error	Wald
Chi-Square	Pr > ChiSq
Intercept	1	-7.4208	3.5755	4.3076	0.0379
var_CHD	1	1.1362	0.5276	4.6374	0.0313
Odds Ratio Estimates
Effect	Point Estimate	95% Wald
Confidence Limits
var_CHD	3.115	1.107	8.760
Association of Predicted Probabilities and Observed Responses
Percent Concordant	56.0	Somers' D	0.251
Percent Discordant	30.9	Gamma	0.289
Percent Tied	13.2	Tau-a	0.128
Pairs	418	c	0.626
 * 
 */
proc logistic data=hf.classified_cities_hf outmodel=pout;
	where Provider_State in ('IN','MO'); 
	model class_var_hf=var_CHD;
run;




/*
 * I thought smoking and HF would be a significant association 
 * but no significant results were produced for this model
 * 

Model Convergence Status
Convergence criterion (GCONV=1E-8) satisfied.
Model Fit Statistics
Criterion	Intercept Only	Intercept and Covariates
AIC	58.618	56.917
SC	60.332	60.344
-2 Log L	56.618	52.917
Testing Global Null Hypothesis: BETA=0
Test	Chi-Square	DF	Pr > ChiSq
Likelihood Ratio	3.7010	1	0.0544
Score	3.5444	1	0.0597
Wald	3.1046	1	0.0781
Analysis of Maximum Likelihood Estimates
Parameter	DF	Estimate	Standard
Error	Wald
Chi-Square	Pr > ChiSq
Intercept	1	-3.5242	2.1296	2.7387	0.0979
var_CSMOKING	1	0.1653	0.0938	3.1046	0.0781
Odds Ratio Estimates
Effect	Point Estimate	95% Wald
Confidence Limits
var_CSMOKING	1.180	0.982	1.418
Association of Predicted Probabilities and Observed Responses
Percent Concordant	51.7	Somers' D	0.122
Percent Discordant	39.5	Gamma	0.134
Percent Tied	8.9	Tau-a	0.062
Pairs	418	c	0.561
 * 
 */
proc logistic data=hf.classified_cities_hf outmodel=pout;
	where Provider_State in ('IN','MO'); 
	model class_var_hf=var_CSMOKING;
run;



/*
 * Obesity can lead to HF so it was chosen
 * 
 * Model Fit Statistics
Criterion	Intercept Only	Intercept and Covariates
AIC	58.618	53.636
SC	60.332	57.063
-2 Log L	56.618	49.636
Testing Global Null Hypothesis: BETA=0
Test	Chi-Square	DF	Pr > ChiSq
Likelihood Ratio	6.9822	1	0.0082
Score	6.3086	1	0.0120
Wald	5.0803	1	0.0242
Analysis of Maximum Likelihood Estimates
Parameter	DF	Estimate	Standard
Error	Wald
Chi-Square	Pr > ChiSq
Intercept	1	-5.6797	2.6003	4.7710	0.0289
var_OBESITY	1	0.1683	0.0747	5.0803	0.0242
Odds Ratio Estimates
Effect	Point Estimate	95% Wald
Confidence Limits
var_OBESITY	1.183	1.022	1.370
Association of Predicted Probabilities and Observed Responses
Percent Concordant	66.7	Somers' D	0.423
Percent Discordant	24.4	Gamma	0.465
Percent Tied	8.9	Tau-a	0.216
Pairs	418	c	0.712
 */
proc logistic data=hf.classified_cities_hf outmodel=pout;
	where Provider_State in ('IN','MO'); 
	model class_var_hf=var_OBESITY;
run;


/*
 * Lack of Access to healthcare is generally considered lead to poor health outcomes
 * So it was chosen to see how it related to HF population and it did produce
 * a significant P-value (P=0.03).
 * 
 * Model Fit Statistics
Criterion	Intercept Only	Intercept and Covariates
AIC	58.618	55.996
SC	60.332	59.423
-2 Log L	56.618	51.996
Testing Global Null Hypothesis: BETA=0
Test	Chi-Square	DF	Pr > ChiSq
Likelihood Ratio	4.6224	1	0.0316
Score	4.3201	1	0.0377
Wald	3.7735	1	0.0521
Analysis of Maximum Likelihood Estimates
Parameter	DF	Estimate	Standard
Error	Wald
Chi-Square	Pr > ChiSq
Intercept	1	-2.1263	1.2018	3.1300	0.0769
var_ACCESS2	1	0.1491	0.0768	3.7735	0.0521
Odds Ratio Estimates
Effect	Point Estimate	95% Wald
Confidence Limits
var_ACCESS2	1.161	0.999	1.349
Association of Predicted Probabilities and Observed Responses
Percent Concordant	61.7	Somers' D	0.354
Percent Discordant	26.3	Gamma	0.402
Percent Tied	12.0	Tau-a	0.180
Pairs	418	c	0.677
 * 
 */
proc logistic data=hf.classified_cities_hf outmodel=pout;
	where Provider_State in ('IN','MO'); 
	model class_var_hf=var_ACCESS2;
run;




/************* MULTIVARIABLE LOGISTIC REGRESSION ***********************/

/* Smoking and high blood pressure together */  
  
 /*
  * 
  * Model Fit Statistics
Criterion	Intercept Only	Intercept and Covariates
AIC	58.618	54.571
SC	60.332	59.712
-2 Log L	56.618	48.571
Testing Global Null Hypothesis: BETA=0
Test	Chi-Square	DF	Pr > ChiSq
Likelihood Ratio	8.0472	2	0.0179
Score	6.9472	2	0.0310
Wald	5.2999	2	0.0707
Analysis of Maximum Likelihood Estimates
Parameter	DF	Estimate	Standard
Error	Wald
Chi-Square	Pr > ChiSq
Intercept	1	-9.2787	4.1339	5.0380	0.0248
var_BPHIGH	1	0.2368	0.1242	3.6361	0.0565
var_CSMOKING	1	0.0727	0.1169	0.3874	0.5337
Odds Ratio Estimates
Effect	Point Estimate	95% Wald
Confidence Limits
var_BPHIGH	1.267	0.993	1.616
var_CSMOKING	1.075	0.855	1.352
Association of Predicted Probabilities and Observed Responses
Percent Concordant	67.7	Somers' D	0.438
Percent Discordant	23.9	Gamma	0.478
Percent Tied	8.4	Tau-a	0.223
Pairs	418	c	0.719
  * 
  */

proc logistic data=hf.classified_cities_hf outmodel=pout;
	where Provider_State in ('IN','MO'); 
	model class_var_hf=var_BPHIGH var_CSMOKING;
run;








/* Creating an Interaction and a Multivariable Regression */
/* Tests interaction between coronary heart disease and high blood pressure */
/* Then modeled with a logistic regression to see the relationship the 
	interaction has with smoking
	This multivariable logistic regression model is the best with the most significant P-value
	Below 1% threshold (P=0.0089).
	*/
	
/*
 * Model Fit Statistics
Criterion	Intercept Only	Intercept and Covariates
AIC	58.618	53.062
SC	60.332	58.202
-2 Log L	56.618	47.062
Testing Global Null Hypothesis: BETA=0
Test	Chi-Square	DF	Pr > ChiSq
Likelihood Ratio	9.5568	2	0.0084
Score	8.0852	2	0.0176
Wald	6.6202	2	0.0365
Analysis of Maximum Likelihood Estimates
Parameter	DF	Estimate	Standard
Error	Wald
Chi-Square	Pr > ChiSq
Intercept	1	-4.5204	2.5769	3.0771	0.0794
var_CSMOKING	1	-0.1225	0.1655	0.5476	0.4593
highbpchd	1	0.0336	0.0154	4.7701	0.0290
Odds Ratio Estimates
Effect	Point Estimate	95% Wald
Confidence Limits
var_CSMOKING	0.885	0.640	1.224
highbpchd	1.034	1.003	1.066
Association of Predicted Probabilities and Observed Responses
Percent Concordant	71.1	Somers' D	0.505
Percent Discordant	20.6	Gamma	0.551
Percent Tied	8.4	Tau-a	0.257
Pairs	418	c	0.752
 * 
 */

data hf.classified_cities_hf;
	set hf.classified_cities_hf;
	highbpchd = var_BPHIGH*var_CHD;
run;

proc logistic data=hf.classified_cities_hf outmodel=pout;
	where Provider_State in ('IN','MO'); 
	model class_var_hf=var_CSMOKING highbpchd;
run;









/* Multivariable Regression With Categorical Variable */
/* I wanted to see how high blood pressure varied by city
and if that yielded important or significant results where a potential
inference could be made; however, it did not.

/*
*
Model Fit Statistics
Criterion	Intercept Only	Intercept and Covariates
AIC	58.618	67.961
SC	60.332	100.519
-2 Log L	56.618	29.961
Testing Global Null Hypothesis: BETA=0
Test	Chi-Square	DF	Pr > ChiSq
Likelihood Ratio	26.6572	18	0.0857
Score	19.4178	18	0.3665
Wald	0.5106	18	1.0000
Type 3 Analysis of Effects
Effect	DF	Wald
Chi-Square	Pr > ChiSq
var_BPHIGH	1	0.0032	0.9549
Provider_City	17	0.3085	1.0000
 * 
 */

proc logistic data=hf.classified_cities_hf outmodel=pout;
	class Provider_City;
	where Provider_State in ('IN','MO'); 
	model class_var_hf= var_BPHIGH Provider_City;
run;




/***************** TESTING/TRAINING THE LOGISTIC MODEL *****************/

/* Creating the training/testing data sets */

data trainhf;
	set hf.classified_cities_hf (firstobs=10 obs=38);
run;

data testhf;
	set hf.classified_cities_hf (obs=12);
run;




/* Executing the training/testing models */
/* Modeling to be done on BPHigh and Obesity as these are the two most important health factors from above testing */
/* After emailing the professor and him confirming the code is fine, I don't get an error but 
	the following in the log:
	NOTE: No observations were selected from data set WORK.TRAINHF.
 	NOTE: There were 0 observations read from the data set WORK.TRAINHF.
       WHERE Provider_State in ('IN', 'MO');
       
    I get this even when I change the firstobs= 1 obs=28 or any other sets of parameters
    
    So I tried it another way (from the lab 3 - titled "Other Test/Train Code Attempt") and got the same response
    
    This code should train on 70% and test on 30% of the data to make a predictive model for heart failure (outcome)
    dependent on the two strongest individual predictors high blood pressure as well as obesity.
       */
      
proc logistic data = trainhf;
	where Provider_State in ('IN','MO');
	model class_var_hf=var_BPHIGH var_OBESITY;
run;
quit;

proc logistic data=testhf;
where Provider_State in ('IN','MO'); 
model class_var_hf=var_BPHIGH var_OBESITY;
run;

/* Other Test/Train Code Attempt */
	
proc logistic data=trainhf outmodel=outm1;
	where Provider_State in ('IN','MO');
	model class_var_hf = var_BPHIGH var_OBESITY;
run;

proc logistic inmodel=outm1;
	where Provider_State in ('IN','MO');
	score clm data = testhf out=preds1 ;
run;

proc freq data=preds1;










