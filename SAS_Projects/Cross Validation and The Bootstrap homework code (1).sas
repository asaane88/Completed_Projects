libname neisshw '/home/u36241478/my_courses/nicholassoulakis0/lib/neiss';

proc format
	cntlin=neisshw.neiss_fmt;
run;

title 'Frequency of the NEISS formats';
title2 'Note: PROD N=1,115';
proc freq data=neisshw.neiss_fmt;
	tables fmtname;
run;


/* Adding day of week format to see if injury is more likely on a particular day */
proc format;
 	value dowf
 		1 = 'Sunday'
 		2 = 'Monday'
 		3 = 'Tuesday'
 		4 = 'Wednesday'
 		5 = 'Thursday'
 		6 = 'Friday'
 		7 = 'Saturday';
run;

/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/* Combine three years of NEISS data */
/* Apply formats for all revelant variables */
/* Combine NARR1 and NARR2 fields into one with CAT function */
/* Create date variable with WEEKDAY,WEEK,MONTH,YEAR functions */
/* Note: Sunday=1, Saturday=7 in the WEEKDAY function */
/* Create a random number to pick a selection of injuries.  */
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

data injuries; set neisshw.neiss2015 neisshw.neiss2016 neisshw.neiss2017;
	drop fmv race raceoth diagoth;
	format sex gender.;
	format race race.;
 	format bdpt bdypt.;
 	format diag diag.;
 	format disp disp.;
 	format loc loc.;
	format dow dowf.;
	format prod1 prod.;
	
	narrative=cat(narr1,narr2);
	dow=weekday(trmt_date);
	week=week(trmt_date);
	month=month(trmt_date);
	year=year(trmt_date);
	if dow in (1,7) then we=1; else we=0;
	if dow in (2,3,4,5,6) then wd=1; else wd=0; 
	call streaminit(4567);
	randno=rand('uniform');
run;

/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/* use the query to see what terms come up 
/* often to aid in choosing what classifiers to select
/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

title 'Random Selection of Basketball ankle Injuries Narratives';
proc sql outobs=25;
	select randno, diag label='Diagnosis', prod1, narr1, narr2
	from injuries
	where bdpt=37 and prod1=1205
	order by randno;
quit;

title 'Distribution of Ankle injuries by Sampling Stratum';
title2 'Note: National Estimate is the Sum of the wt Variable';
proc sql outobs=25;
	select stratum label='Sampling Stratum', 
		count(*) as freq label='Frequency', 
		sum(wt) as sum_wt label='National Estimate'
	from injuries
	where bdpt=37 and prod1=1205     /* bdpt=37 diag=64*/
	group by stratum
	order by freq desc;
quit;

/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/* CREATING 5 CLASSIFIERS
/* THE AUC's for 5 and 10 Fold CV's of the same model were the same, however other metrics such as
/* the ASE would be different when comparing the two (lower for 10 Fold) 
/* I included the AUC's for Model 5 so you can compare different AUC's for each model
/* How I chose which model was the best: 
/* the model with highest AUC and secondly, the lowest ASE
/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

/* Classifier 1 */
/* Model 5 AUC = 0.83 */ 
data basketball; set injuries;
	where prod1=1205 AND (age > 14 AND age < 19);
	if index(narrative,'SPRAIN') > 0 then narr_sprain=1;
		else narr_sprain=0;
	if index(narrative,'STRAIN') > 0 then narr_basketball=1;
		else narr_basketball=0; 
	if index(narrative,'STRAINED')>0 then narr_strained=1;
		else narr_strained=0;
	if  bdpt=37 then baketball_ankles=1;
		else baketball_ankles=0;
run;

/* Classifier 2 */
/* Model 5 AUC = 0.8630 */
data basketball; set injuries;
	where prod1=1205 AND (age > 14 AND age < 19);
	if index(narrative,'SPRAIN') > 0 then narr_sprain=1;
		else narr_sprain=0;
	if index(narrative,'STRAIN') > 0 then narr_basketball=1;
		else narr_basketball=0; 
	if index(narrative,'STRAINED')>0 then narr_strained=1;
		else narr_strained=0;
	if index(narrative,'TWISTED')>0 then narr_twisted=1;
		else narr_twisted=0;
	if bdpt=37 then baketball_ankles=1;
		else baketball_ankles=0;
run;

/* Classifier 3 */
/* Model 5 AUC = 0.84 */
/* I changed the "TWISTED" term to "FX" (fracture) to see the difference on AUC each narrative term has independently on the classifer */
data basketball; set injuries;
	where prod1=1205 AND (age > 14 AND age < 19);
	if index(narrative,'SPRAIN') > 0 then narr_sprain=1;
		else narr_sprain=0;
	if index(narrative,'STRAIN') > 0 then narr_basketball=1;
		else narr_basketball=0; 
	if index(narrative,'STRAINED')>0 then narr_strained=1;
		else narr_strained=0;
	if index(narrative,'FX')>0 then narr_fx=1;
		else narr_fx=0;
	if  bdpt=37 then baketball_ankles=1;
		else baketball_ankles=0;
run;

/* Classifier 4 */
/* Model 5 AUC = 0.8653 */
/* I then added both 'FX' and 'TWISTED' to my original classifier of three narrative terms to see is there was a compound effect and there was */
/* 'FX' + original had an AUC of 0.84 while 'TWISTED' had an AUC of of 0.8630, together it slightly improves to 0.8653 */
data basketball; set injuries;
	where prod1=1205 AND (age > 14 AND age < 19);
	if index(narrative,'SPRAIN') > 0 then narr_sprain=1;
		else narr_sprain=0;
	if index(narrative,'STRAIN') > 0 then narr_basketball=1;
		else narr_basketball=0; 
	if index(narrative,'STRAINED')>0 then narr_strained=1;
		else narr_strained=0;
	if index(narrative,'FX')>0 then narr_fx=1;
		else narr_fx=0;
	if index(narrative,'TWISTED')>0 then narr_twisted=1;
		else narr_twisted=0;
	if  bdpt=37 then baketball_ankles=1;
		else baketball_ankles=0;
run;

/* Classifier 5 */
/* Model 5 AUC = 0.8674 */
/* This is the best model as it has the largest AUC and smallest ASE */
data basketball; set injuries;
	where prod1=1205 AND (age > 14 AND age < 19);
	if index(narrative,'SPRAIN') > 0 then narr_sprain=1;
		else narr_sprain=0;
	if index(narrative,'STRAIN') > 0 then narr_basketball=1;
		else narr_basketball=0; 
	if index(narrative,'STRAINED')>0 then narr_strained=1;
		else narr_strained=0;
	if index(narrative,'FX')>0 then narr_fx=1;
		else narr_fx=0;
	if index(narrative,'TWISTED')>0 then narr_twisted=1;
		else narr_twisted=0;
	if index(narrative,'FRACTURE')>0 then narr_fracture=1;
		else narr_fracture=0;
	if  bdpt=37 then baketball_ankles=1;
		else baketball_ankles=0;
run;

/* PROC FREQ to calculate PREVALENCE of ankle injuries in basketball data - 25.55% prevalence */ 

title 'Frequency of Basketball Ankle Injuries among high school-age population';
proc freq data=basketball;
	tables baketball_ankles;
run;



/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/* 5 CV VALIDATION */
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

title '5 Fold VC Model 1';
title2 'Variables Defining Model 1 Case Population: narr_';
proc hpsplit data=basketball cvcc cvmodelfit
	assignmissing=similar
	cvmethod=random (5);
	prune reducederror;
	id NEK psu wt stratum;
	weight wt;
	class baketball_ankles narr_:;
	model baketball_ankles(event='1') =narr_:;
	output out=bball_cv05_model01;
run;

title '5 Fold VC Model 2';
title2 'Variables Defining Model 2 Case Population: narr_, loc';
proc hpsplit data=basketball cvcc
	cvmodelfit
	assignmissing=similar
	cvmethod=random (5);
	prune reducederror;
	id NEK psu wt stratum;
	weight wt;
	class baketball_ankles narr_: loc;
	model baketball_ankles(event='1') =narr_: loc;
	output out=bball_cv05_model02;
run;


title '5 Fold VC Model 3';
title2 'Variables Defining Model 3 Case Population: narr_, loc, sex';
proc hpsplit data=basketball cvcc
	cvmodelfit
	assignmissing=similar
	cvmethod=random (5);
	prune reducederror;
	id NEK psu wt stratum;
	weight wt;
	class baketball_ankles narr_: loc sex;
	model baketball_ankles(event='1') =narr_: loc sex;
	output out=bball_cv05_model03;
run;

title '5 Fold VC Model 4';
title2 'Variables Defining Model 4 Case Population: narr_, loc, sex, disp';
proc hpsplit data=basketball cvcc
	cvmodelfit
	assignmissing=similar
	cvmethod=random (5);
	prune reducederror;
	id NEK psu wt stratum;
	weight wt;
	class baketball_ankles narr_: loc sex disp;
	model baketball_ankles(event='1') =narr_: loc sex disp;
	output out=bball_cv05_model04;
run;

title '5 Fold VC Model 5';
title2 'Variables Defining Model 5 Case Population: narr_, loc, sex, disp, dow';
proc hpsplit data=basketball cvcc
	cvmodelfit
	assignmissing=similar
	cvmethod=random (5);
	prune reducederror;
	id NEK psu wt stratum;
	weight wt;
	class baketball_ankles narr_: loc sex disp dow;
	model baketball_ankles(event='1') =narr_: loc sex disp dow;
	output out=bball_cv05_model05;
run;

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/* 10 CV VALIDATION */
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

title '10 Fold VC Model 1';
title2 'Variables Defining Model 1 Case Population: narr_';
proc hpsplit data=basketball cvcc cvmodelfit
	assignmissing=similar
	cvmethod=random (10);
	prune reducederror;
	id NEK psu wt stratum;
	weight wt;
	class baketball_ankles narr_:;
	model baketball_ankles(event='1') =narr_:;
	output out=bball_cv10_model01;
run;

title '10 Fold VC Model 2';
title2 'Variables Defining Model 2 Case Population: narr_, loc';
proc hpsplit data=basketball cvcc
	cvmodelfit
	assignmissing=similar
	cvmethod=random (10);
	prune reducederror;
	id NEK psu wt stratum;
	weight wt;
	class baketball_ankles narr_: loc;
	model baketball_ankles(event='1') =narr_: loc;
	output out=bball_cv10_model02;
run;

title '10 Fold VC Model 3';
title2 'Variables Defining Model 3 Case Population: narr_, loc, sex';
proc hpsplit data=basketball cvcc
	cvmodelfit
	assignmissing=similar
	cvmethod=random (10);
	prune reducederror;
	id NEK psu wt stratum;
	weight wt;
	class baketball_ankles narr_: loc sex;
	model baketball_ankles(event='1') =narr_: loc sex;
	output out=bball_cv10_model03;
run;

title '10 Fold CV Model 4';
title2 'Variables Defining Model 4 Case Population: narr_, loc, sex, disp';
proc hpsplit data=basketball cvcc
	cvmodelfit
	assignmissing=similar
	cvmethod=random (10);
	prune reducederror;
	id NEK psu wt stratum;
	weight wt;
	class baketball_ankles narr_: loc sex disp;
	model baketball_ankles(event='1') =narr_: loc sex disp;
	output out=bball_cv10_model04;
run;

title '10 Fold CV Model 5';
title2 'Variables Defining Model 5 Case Population: narr_, loc, sex, disp, dow';
proc hpsplit data=basketball cvcc
	cvmodelfit
	assignmissing=similar
	cvmethod=random (10);
	prune reducederror;
	id NEK psu wt stratum;
	weight wt;
	class baketball_ankles narr_: loc sex disp dow;
	model baketball_ankles(event='1') =narr_: loc sex disp dow;
	output out=bball_cv10_model05;
run;


/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/* Coding Probability for 10 CV Fold mode */
/* If the probability of basketball ankle injuries [P_basketball_ankles1] is  */
/* greater than 0.50 TEST is positive. */
/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

data basketball_code; set bball_cv10_model05;
	if P_baketball_ankles1 > 0.50 then test=1;
		else test=0;
run;


/* BOOTSTRAP - 1000 REPS */

title 'Bootstrap Analysis - 1000 Reps';
proc surveyfreq data=basketball_code varmethod=bootstrap (reps=1000);
   	tables  baketball_ankles*test / row column cl alpha=0.05 plots=all;
   	weight wt;
   	strata stratum;
	cluster psu;
run;










