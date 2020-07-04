options nocenter;
x "cd c:\sasods";

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
 * 
 * 
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
	







