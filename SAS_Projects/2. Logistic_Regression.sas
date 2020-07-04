
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

/**********************************************************************************/;
* Load in data 
/**********************************************************************************/;

libname class '/home/u36241478/trial/hw1_data_sets';

/* Set one DRG (638 diabetes) and one location CA */
/* Look at the frequency of the data in one of the variables just to make sure selection works*/
/* Need to run these so that the linear regressions run */

proc freq data=class.cms_ipps_2011 order=freq;
	tables DRG_Definition;
run;

data ipps; set class.cms_ipps_2011;
	drop Provider_Street_Address;
	format Average_Covered_Charges Average_Total_Payments Average_Medicare_Payments dollar20.;
	where index(DRG_Definition,'638') > 0
		and Provider_State='CA';
run;

proc freq data=class.cms_ipps_2011 order=freq;
	where index(DRG_Definition,'638') > 0
		and Provider_State='CA';
	tables Average_Total_Payments;
run;

/**********************************************************************************/;
* Single Variable Linear Regression on Average_Medicare_Payments;
* Average_Medicare_Payments was chosen because it was one of the predictors in the dataset
* It also produced statistically significant P-values (P=0.0124) 
Source	DF	Sum of
Squares	Mean
Square	F Value	Pr > F
Model	1	1409406789	1409406789	6.39	0.0124
Error	158	34824736973	220409728	 	 
Corrected Total	159	36234143762	 	 	 
Root MSE	14846	R-Square	0.0389
Dependent Mean	38543	Adj R-Sq	0.0328
Coeff Var	38.51878	 	 
Parameter Estimates
Variable	DF	Parameter
Estimate	Standard
Error	t Value	Pr > |t|	Type I SS	Type II SS	Standardized
Estimate	95% Confidence Limits
Intercept	1	28573	4113.58354	6.95	<.0001	2.376871E11	10634134813	0	20448	36698
Average_Medicare_Payments	1	1.50549	0.59535	2.53	0.0124	1409406789	1409406789	0.19722	0.32961	2.68137
/**********************************************************************************/;

ods graphics on;   
proc reg;
      model Average_Covered_Charges = Average_Medicare_Payments 
	  / ss1 ss2 stb clb;
   run;   
ods graphics off;

/**********************************************************************************/;
* Single Variable Linear Regression on Average_Total_Payments;
* Average_Total_Payments was chosen because it was one of the predictors in the dataset
* It also produced statistically significant P-values (P=0.0089) 
Source	DF	Sum of
Squares	Mean
Square	F Value	Pr > F
Model	1	1539054371	1539054371	7.01	0.0089
Error	158	34695089391	219589173	 	 
Corrected Total	159	36234143762	 	 	 
Root MSE	14819	R-Square	0.0425
Dependent Mean	38543	Adj R-Sq	0.0364
Coeff Var	38.44701	 	 
Parameter Estimates
Variable	DF	Parameter
Estimate	Standard
Error	t Value	Pr > |t|	Type I SS	Type II SS	Standardized
Estimate	95% Confidence Limits
Intercept	1	26639	4646.41674	5.73	<.0001	2.376871E11	7217997241	0	17462	35816
Average_Total_Payments	1	1.58550	0.59889	2.65	0.0089	1539054371	1539054371	0.20610	0.40264	2.76836
/**********************************************************************************/;

ods graphics on;   
proc reg;
      model Average_Covered_Charges = Average_Total_Payments
	  / ss1 ss2 stb clb;
   run; 
ods graphics off;

/**********************************************************************************/;
* Single Variable Linear Regression on Total_Discharges;
* Total_Discharges was chosen because it was one of the predictors in the dataset
* It did not produce statistically significant results.
* THIS WAS MY FINDING OF INTEREST AS IT HAD THE BEST DIAGNOSTIC SPREAD BUT
* THE RESULTS WERE NOT SIGNIFCANT
Source	DF	Sum of
Squares	Mean
Square	F Value	Pr > F
Model	1	91450810	91450810	0.40	0.5281
Error	158	36142692952	228751221	 	 
Corrected Total	159	36234143762	 	 	 
Root MSE	15125	R-Square	0.0025
Dependent Mean	38543	Adj R-Sq	-0.0038
Coeff Var	39.24089	 	 
Parameter Estimates
Variable	DF	Parameter
Estimate	Standard
Error	t Value	Pr > |t|	Type I SS	Type II SS	Standardized
Estimate	95% Confidence Limits
Intercept	1	36819	2977.19554	12.37	<.0001	2.376871E11	34985525191	0	30939	42699
Total_Discharges	1	83.61053	132.23575	0.63	0.5281	91450810	91450810	0.05024	-177.56726	344.78831
/**********************************************************************************/;

ods graphics on;  
proc reg;
      model Average_Covered_Charges = Total_Discharges
	  / ss1 ss2 stb clb;
   run;   
ods graphics off;


/* scatter plot for summary graphic*/

ods graphics on;  
proc corr data =class.cms_ipps_2011 nomiss plots=matrix(histogram);
	var Average_Covered_Charges Average_Medicare_Payments Average_Total_Payments Total_Discharges;
run;
ods graphics off;


/**********************************************************************************/;
* Single Variable Linear Regression With Categoricals 
/**********************************************************************************/;
/*
 * 
*I chose the vairable Provider_City to test because I thought that
* location would impact the outcome Average_Covered_Charges however the data
* from this variable did not produce significant results
Source	DF	Sum of Squares	Mean Square	F Value	Pr > F
Model	123	29410619240	239110726	1.26	0.2130
Error	36	6823524522	189542348	 	 
Corrected Total	159	36234143762	 	 	 
R-Square	Coeff Var	Root MSE	Average_Covered_Charges Mean
0.811682	35.71990	13767.44	38542.76
Source	DF	Type I SS	Mean Square	F Value	Pr > F
Provider_City	123	29410619240	239110726	1.26	0.2130
Source	DF	Type III SS	Mean Square	F Value	Pr > F
Provider_City	123	29410619240	239110726	1.26	0.2130
 */

proc glm data=class.cms_ipps_2011 plots=(diagnostics residuals);
  class Provider_City;
  where index(DRG_Definition,'638') > 0
		and Provider_State='CA';
  model Average_Covered_Charges = Provider_City; 
run;

/*
* I chose the vairable Provider_Zip_Code to test as another filter for
* location that would impact the outcome Average_Covered_Charges however the data
* from this variable did not produce significant results although better than
* Provider_City
* 
* Source	DF	Sum of Squares	Mean Square	F Value	Pr > F
Model	148	34942105461	236095307	2.01	0.0975
Error	11	1292038301	117458027	 	 
Corrected Total	159	36234143762	 	 	 
R-Square	Coeff Var	Root MSE	Average_Covered_Charges Mean
0.964342	28.11891	10837.81	38542.76
Source	DF	Type I SS	Mean Square	F Value	Pr > F
Provider_Zip_Code	148	34942105461	236095307	2.01	0.0975
Source	DF	Type III SS	Mean Square	F Value	Pr > F
Provider_Zip_Code	148	34942105461	236095307	2.01	0.0975
*/

proc glm data=class.cms_ipps_2011 plots=(diagnostics residuals);
  class Provider_Zip_Code;
  where index(DRG_Definition,'638') > 0
		and Provider_State='CA';
  model Average_Covered_Charges = Provider_Zip_Code; 
run;

/*
 * I thought that Medicare might have a list of the provider names 
 * to see who does and does not accept Medicare
 * This model produced a significant P-value = 0.03 at the 5%
 * significant level
 * 
 * 
 * Source	DF	Sum of Squares	Mean Square	F Value	Pr > F
Model	158	36233719872	229327341	541.01	0.0342
Error	1	423890	423890	 	 
Corrected Total	159	36234143762	 	 	 
R-Square	Coeff Var	Root MSE	Average_Covered_Charges Mean
0.999988	1.689211	651.0686	38542.76
Source	DF	Type I SS	Mean Square	F Value	Pr > F
Provider_Name	158	36233719872	229327341	541.01	0.0342
Source	DF	Type III SS	Mean Square	F Value	Pr > F
Provider_Name	158	36233719872	229327341	541.01	0.0342
 * 
 */

proc glm data=class.cms_ipps_2011 plots=(diagnostics residuals);
  class Provider_Name;
  where index(DRG_Definition,'638') > 0
		and Provider_State='CA';
  model Average_Covered_Charges = Provider_Name; 
run;

/* 
 * The hospital referral region could also be calculated by Medicare
 * to calculate Medicare paymenbts
 * THIS IS THE BEST SINGLE VARIABLE MODEL
 * WITH THE BEST P-VALUE (P<0.0001) AND LOWEST RMSE (RMSE = 13246)
 * 
 * Source	DF	Sum of Squares	Mean Square	F Value	Pr > F
Model	22	12195626466	554346658	3.16	<.0001
Error	137	24038517296	175463630	 	 
Corrected Total	159	36234143762	 	 	 
R-Square	Coeff Var	Root MSE	Average_Covered_Charges Mean
0.336578	34.36772	13246.27	38542.76
Source	DF	Type I SS	Mean Square	F Value	Pr > F
Hospital_Referral_Re	22	12195626466	554346658	3.16	<.0001
Source	DF	Type III SS	Mean Square	F Value	Pr > F
Hospital_Referral_Re	22	12195626466	554346658	3.16	<.0001
 
 */
proc glm data=class.cms_ipps_2011 plots=(diagnostics residuals);
  class Hospital_Referral_Region_Descrip;
  where index(DRG_Definition,'638') > 0
		and Provider_State='CA';
  model Average_Covered_Charges = Hospital_Referral_Region_Descrip; 
run;

/**********************************************************************************/;
* Multivariable Linear Regression 
/**********************************************************************************/;

/* interaction between quantitative variables 
I thought Total Discharges may become significant if measured with Average Medicare Payments
While they did improve, Total Discharges did not become significant
Analysis of Variance
Source	DF	Sum of
Squares	Mean
Square	F Value	Pr > F
Model	2	1536291629	768145815	3.48	0.0333
Error	157	34697852133	221005428	 	 
Corrected Total	159	36234143762	 	 	 
Root MSE	14866	R-Square	0.0424
Dependent Mean	38543	Adj R-Sq	0.0302
Coeff Var	38.57080	 	 
Parameter Estimates
Variable	DF	Parameter
Estimate	Standard
Error	t Value	Pr > |t|	Type I SS	Type II SS	Standardized
Estimate	95% Confidence Limits
Intercept	1	26406	5015.00321	5.27	<.0001	2.376871E11	6127027109	0	16500	36311
Average_Medicare_Payments	1	1.52585	0.59676	2.56	0.0115	1409406789	1444840819	0.19989	0.34713	2.70457
Total_Discharges	1	98.58537	130.10952	0.76	0.4498	126884840	126884840	0.05924	-158.40555	355.57630
*/

ods graphics on;   
proc reg;
      model Average_Covered_Charges = Average_Medicare_Payments Total_Discharges
	  / ss1 ss2 stb clb;
   run;
ods graphics off;

/* creating interaction between Average_Total_Payments and Total_Discharges */
/* And outcome of Average_Covered_Charges with Average_Medicare_Payments and the interaction */
/*
 * Analysis of Variance
Source	DF	Sum of
Squares	Mean
Square	F Value	Pr > F
Model	2	1628034870	814017435	3.69	0.0271
Error	157	34606108892	220421076	 	 
Corrected Total	159	36234143762	 	 	 
Root MSE	14847	R-Square	0.0449
Dependent Mean	38543	Adj R-Sq	0.0328
Coeff Var	38.51977	 	 
Parameter Estimates
Variable	DF	Parameter
Estimate	Standard
Error	t Value	Pr > |t|	Type I SS	Type II SS	Standardized
Estimate	95% Confidence Limits
Intercept	1	27830	4180.75603	6.66	<.0001	2.376871E11	9767342654	0	19572	36088
Average_Medicare_Payments	1	1.21406	0.66340	1.83	0.0691	1409406789	738216772	0.15904	-0.09628	2.52439
totpaydischarge	1	0.01736	0.01743	1.00	0.3208	218628081	218628081	0.08655	-0.01707	0.05178
 * 
 * 
 * 
 */
data class.cms_ipps_2011;
	set class.cms_ipps_2011;
	totpaydischarge = Average_Total_Payments*Total_Discharges;
run;

proc reg;
      model Average_Covered_Charges = Average_Medicare_Payments totpaydischarge
	  / ss1 ss2 stb clb;
run;

/* Multivariable model with categorical Hospital_Referral_Region_Descrip*/
/* best multivariable variable model, lowest RMSE and P-value - used for testing/traing */
/*
 * Source	DF	Sum of Squares	Mean Square	F Value	Pr > F
Model	23	12222522071	531414003	3.01	<.0001
Error	136	24011621690	176556042	 	 
Corrected Total	159	36234143762	 	 	 
R-Square	Coeff Var	Root MSE	Average_Covered_Charges Mean
0.337321	34.47454	13287.44	38542.76
Source	DF	Type I SS	Mean Square	F Value	Pr > F
Average_Medicare_Pay	1	1409406789	1409406789	7.98	0.0054
Hospital_Referral_Re	22	10813115283	491505240	2.78	0.0002
Source	DF	Type III SS	Mean Square	F Value	Pr > F
Average_Medicare_Pay	1	26895605	26895605	0.15	0.6969
Hospital_Referral_Re	22	10813115283	491505240	2.78	0.0002
 */
proc glm data=class.cms_ipps_2011 plots=(diagnostics residuals);
  class Hospital_Referral_Region_Descrip;
  where index(DRG_Definition,'638') > 0
		and Provider_State='CA';
  model Average_Covered_Charges = Average_Medicare_Payments Hospital_Referral_Region_Descrip; 
run;

/**********************************************************************************/;
* Training/Testing Data
/**********************************************************************************/;

/* making the training and testing datasets */
data traincms;
set class.cms_ipps_2011(firstobs=5 obs=115);
run;

data testcms;
set class.cms_ipps_2011(obs=45);
run;

/* Training Output
 * 
 * Source	DF	Sum of Squares	Mean Square	F Value	Pr > F
Model	21	10032761173	477750532	3.19	<.0001
Error	89	13332334340	149801509	 	 
Corrected Total	110	23365095513	 	 	 
R-Square	Coeff Var	Root MSE	Average_Covered_Charges Mean
0.429391	31.76389	12239.34	38532.26
Source	DF	Type I SS	Mean Square	F Value	Pr > F
Average_Medicare_Pay	1	1564363693	1564363693	10.44	0.0017
Hospital_Referral_Re	20	8468397480	423419874	2.83	0.0004
Source	DF	Type III SS	Mean Square	F Value	Pr > F
Average_Medicare_Pay	1	10635496	10635496	0.07	0.7905
Hospital_Referral_Re	20	8468397480	423419874	2.83	0.0004
 * 
 */
proc glm data=traincms;
	class Hospital_Referral_Region_Descrip;
	model Average_Covered_Charges = Average_Medicare_Payments Hospital_Referral_Region_Descrip;
run;
quit;

/*Testing Output
 * 
 * Source	DF	Sum of Squares	Mean Square	F Value	Pr > F
Model	15	2971202743	198080183	3.39	0.0024
Error	29	1696648875	58505134	 	 
Corrected Total	44	4667851618	 	 	 
R-Square	Coeff Var	Root MSE	Average_Covered_Charges Mean
0.636525	21.25525	7648.865	35985.77
Source	DF	Type I SS	Mean Square	F Value	Pr > F
Average_Medicare_Pay	1	441669708	441669708	7.55	0.0102
Hospital_Referral_Re	14	2529533035	180680931	3.09	0.0050
Source	DF	Type III SS	Mean Square	F Value	Pr > F
Average_Medicare_Pay	1	14154270	14154270	0.24	0.6265
Hospital_Referral_Re	14	2529533035	180680931	3.09	0.0050
 * 
 */

proc glm data=testcms;
	class Hospital_Referral_Region_Descrip;
	model Average_Covered_Charges = Average_Medicare_Payments Hospital_Referral_Region_Descrip;
run;
quit;
