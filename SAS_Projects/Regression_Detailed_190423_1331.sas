/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/* Regression and Classification example */
/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/* Map the library to the location of two sas data sets */
/* Create a folder > get path from properties > replace path below */
/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

libname class 'C:\SAS\temp\Class04_de';

/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/* Select one DRG. 291 is selected for Severe Heart Failure
/* Choose your own DRG to understand another condition   */
/* Uses text matching with INDEX() function */
/* Changes display of variables to dollars with FORMAT Statement */
/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
proc freq data=class.cms_ipps_2011 order=freq;
	tables DRG_Definition;
run;

data ipps; set class.cms_ipps_2011;
	drop Provider_Street_Address;
	format Average_Covered_Charges Average_Total_Payments Average_Medicare_Payments dollar20.;
	where index(DRG_Definition,'470') > 0;
run;

/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/* Prepare data set of indicators, at appropritate age-adjusted level
/* Filtered with WHERE statement */
/* Uses UPCASE() function */
/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

data cities; set class.cdc_500_cities;
	where datavaluetypeID='AgeAdjPrv'
	and stateAbbr ne 'US';
	cdc_city=upcase(CityName);
run;

/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/* Several steps to prepare data from CDC file. Turn rows to colums using a SAS macro.
/* This is advanced SAS programming */
/* Uses SQL through SAS PROC SQL */
/* Codes data with DATA Step */
/* Iterates with a SAS Macro */
/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

proc sql;
	create table measure_unique as
		select distinct measureID, Short_Question_Text
		from cities;
quit;

data measure_var_name; set measure_unique;
	drop j;
	j+1;
	var_name=cats('var_',measureID);
run;

ods graphics on;

%macro factorgen;

proc sql noprint;
	select distinct measureID, var_name, Short_Question_Text into :fac_id1 - :fac_id999, :var1 - :var999, :lab1 - :lab999
	from measure_var_name;
quit;

data output1; set cities;
	%do i=1 %to &sqlobs;
		label &&var&i="&&lab&i";
		if measureID="&&fac_id&i" then &&var&i=data_value; else &&var&i=0;
	%end;
run;

%let N_1=%eval(&sqlobs - 1);
%let N=%eval(&sqlobs);

%put &sqlobs;

proc sql;
	create table output2 as 
		select upcase(CityName) as cdc_city,
			%do i=1 %to &N_1;
				max(&&var&i) as &&var&i label "&&lab&i",
			%end;
				max(&&var&N) as &&var&N label "&&lab&i"
		from output1
		group by CityName;
quit;

%mend factorgen;
run;

%factorgen; run;

/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/* Output of Macro (output2) consists of columns for each of the CDC indicators by city name
/* Join this back to the original data set */
/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

proc sql;
	create table ipps_cdc as 
	select distinct b.*, a.* 
	from output2 a left join ipps b
		on a.cdc_city=b.provider_city
	where drg_definition ne ''
	order by provider_city, provider_name;
run;

/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/* Descriptive Statistics for Hospital Charges
/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

proc sql outobs=10;
title 'Highest: Hospitals by Covered Charges';
	select DRG_Definition, Provider_Name, Provider_City, Provider_State, 
		Total_Discharges, Average_Covered_Charges, Average_Total_Payments, Average_Medicare_Payments
	from  ipps_cdc
	order by Average_Covered_Charges desc;
quit;
title;

proc sql outobs=10;
title 'Lowest: Hospitals by Covered Charges';
	select DRG_Definition, Provider_Name, Provider_City, Provider_State, 
		Total_Discharges, Average_Covered_Charges, Average_Total_Payments, Average_Medicare_Payments
	from  ipps_cdc
	order by Average_Covered_Charges;
quit;
title;

/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/* Begin regression analysis with a Regression Tree to understand how to categorize Medicare Charges
/* Accounting for regional differences and other related costs */
/* Note HPSPLIT outputs a rules file to the C: drive unless commented out */
/* If no such directory exists, will cause an error */
/* HPSPLIT also outputs a data set for each tree to WORK ipps_tree, ipps_tree_class01, ipps_tree_class02, ipps_tree_class03 */
/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

proc hpsplit data=ipps_cdc;
	id provider_id;
	prune costcomplexity (leaves=3);
/* 	rules file="C:\SAS\out\class_2019.02\ipps_cdc_00.txt"; */
	class Hospital_Referral_Region_Descrip Provider_City Provider_Zip_Code;
	model Average_Covered_Charges = Average_Medicare_Payments Total_Discharges Average_Total_Payments
		  Hospital_Referral_Region_Descrip Provider_City Provider_Zip_Code;
	output out=ipps_tree;
run;


/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/* Format for Node Values - Verify below: May be Different for Your Tree       
/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

proc format; 
	value charge_class	2 = 'High_Charges'
						4 = 'Medium_Charges'
						3 = 'Low_Charges';
run;


proc sql;
		title "Descriptive Statistics of Nodes";
		title2 "Three Nodes Essentially Breaks into High, Medium, Low Charges, Adjusting for Regional Differences";
		select _node_ format charge_class., _leaf_,
			count(*) as freq format comma20. label='Number',
			min(average_covered_charges) as min_average_covered_charges format dollar20.2 label="Minimum Charges",
			p_average_covered_charges format dollar20.2,
			max(average_covered_charges) as max_average_covered_charges format dollar20.2 label="Maximum Charges",
			std(average_covered_charges) as std_average_covered_charges format dollar20.2 label="Standard Deviation"
			from ipps_tree
			group by _node_, _leaf_, p_average_covered_charges
			order by p_average_covered_charges;
quit;
			
/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/* The output of the regression analysis places each provider into a charge indicator category
/* Basically, the categories are high-medium-low accounting for regional differences */
/* These are joined back to the original set, which then renames the _node_ variable to class_var to avoid confusion  */
/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
			
proc sql;
	create table Classified_Cities as
		select a.*, _node_ as class_var format charge_class. label='Class Variable', 
			p_average_covered_charges format dollar20.2 label 'Predicted Average Covered Charges',
			(a.average_covered_charges-p_average_covered_charges) as residual format dollar20.2 label="Residual -  Covered Charges"
		from ipps_cdc a left join ipps_tree b
			on a.provider_id=b.provider_id
		order by class_var;
quit;

ods graphics / reset;
title 'Box Plot of Residuals: Observed Charges versus Predicted Charges';
proc sgplot data=WORK.CLASSIFIED_CITIES;
	vbox residual / category=class_var;
	yaxis grid;
run;

ods graphics / reset;

/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/* Classification Trees of varying depths - Default- All - 20 nodes are then run
This tells us several things
1. Can the indicators classify the charge buckets at all?
2. If so, which indicators are important
3. What is the level of complexity appropriate for the tree?

/* All the trees output rules files and data sets for further investigation */
/* Update paths or comment out RULES statement */
/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

title 'Overview of City Indicator variables';
proc sql;
	select * from class.measures;
quit;

title;
proc hpsplit data=Classified_Cities;
	id provider_id;
/* 	rules file="C:\SAS\out\class_2019.02\ipps_cdc_01.txt"; */
	class class_var cdc_city;
	model class_var=cdc_city var:;
	output out=ipps_tree_class01;
run;

proc hpsplit data=Classified_Cities;
	id provider_id;
	prune costcomplexity (leaves=all);
/* 	rules file="C:\SAS\out\class_2019.02\ipps_cdc_02.txt"; */
	class class_var cdc_city;
	model class_var=cdc_city var:;
	output out=ipps_tree_class02;
run;

proc hpsplit data=Classified_Cities;
	id provider_id;
	prune costcomplexity (leaves=20);
/* 	rules file="C:\SAS\out\class_2019.02\ipps_cdc_03.txt"; */
	class class_var cdc_city;
	model class_var=cdc_city var:;
	output out=ipps_tree_class03;
run;

/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/* Whatever classification method is used, the probability of class membership will cluster  */
/* around certain points. If the data set is large enough, probability may approach continuous from  */
/* 0 to 1. In either case whether nodes, bands, or arbitrary quantiles, instances with similar probability */
/* can be investigated better understand the underlying drivers of class membership */
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

title 'Examine Node Composition';
proc sql;
	select _node_, 
	count(*) as freq label 'Frequency' format comma20.,
	sum(P_class_varHigh_Charges) as sum_P_class_High format 8.,
	sum(P_class_varHigh_Charges)/count(*) as pct_P_class_High format percent8.2,
	sum(P_class_varMedium_Charges) as sum_P_class_Med format 8.,
	sum(P_class_varMedium_Charges)/count(*) as pct_P_class_Med format percent8.2,
	sum(P_class_varLow_Charges) as sum_P_class_Low format 8.,
	sum(P_class_varLow_Charges)/count(*) as pct_P_class_Low format percent8.2
	from ipps_tree_class03
	group by _node_
	order by freq desc;
quit;