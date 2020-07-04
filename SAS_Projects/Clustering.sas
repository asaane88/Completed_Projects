data restaurants;
	set '/home/u36241478/my_courses/nicholassoulakis0/lib/cluster/lv_inspections_trim.sas7bdat';
run;

/*Subset the data - There are 352 observations of buffets in the region */

data buffet;
	set '/home/u36241478/my_courses/nicholassoulakis0/lib/cluster/lv_inspections_trim.sas7bdat';
	if (Category_Name = 'Buffet');
run;

/* Print out random set of records for review */

title 'Randomly Selected Restaurant Inspections';
proc sql outobs=10;
	select *
	from buffet
	order by randno;
quit;

proc sql outobs=50;
	create table lv_inspect_rando as
		select *
		from buffet;
quit;

/* HEIRARCHICAL CLUSTERING - EUCLIDEAN METHOD */

title 'Calculating Distance by Euclidean Method';
title2 'Outputs a Distance File for Hierarchical Clustering';
proc distance data=lv_inspect_rando method=euclid out=dist_euc;
	var interval(sum_demerits max_demerits avg_demerits min_demerits total_inspections/std=range);
	id permit_number;
run;

proc cluster data=dist_euc (type=distance) method=ward outtree=cluster_eu pseudo print=15
	plots(maxpoints=1000)=dendrogram(height=rsq);
	id permit_number;
run;

/* HEIRARCHICAL CLUSTERING - CITY BLOCK METHOD */

title 'Calculating Distance by City Block Method';
proc distance data=lv_inspect_rando method=cityblock out=dist_cbl;
	var interval(sum_demerits max_demerits avg_demerits min_demerits total_inspections/std=range);
	id permit_number;
run;

proc cluster data=dist_cbl (type=distance) method=ward outtree=cluster_cb pseudo print=15
	plots(maxpoints=1000)=dendrogram(height=rsq);
	id permit_number;
run;

/* K MEANS CLUSTERINS */

/* Standardize the data */

proc stdize data=buffet
	method=range 
	out=std_lv_inspects 
	outstat=stdize_lve; 
	var sum_demerits max_demerits avg_demerits min_demerits total_inspections; 
run; 

title 'Random Selection: 33% of Buffets';
proc sgscatter data=sample_lv_inspect; 
	matrix sum_demerits max_demerits avg_demerits min_demerits total_inspections; 
run;

proc fastclus data=std_lv_inspects
	maxclusters=5
	least=10
	maxiter=100
	out=lv_inspects_clus;
	var sum_demerits max_demerits avg_demerits min_demerits total_inspections;
run;


/* Unstandardize the values */


proc stdize data=lv_inspects_clus
	method=in(stdize_lve) 
        unstdize 
        out=lv_insps_clus;
    	var sum_demerits max_demerits avg_demerits min_demerits total_inspections;
run;


/* Sorting for the stratified sampling */
proc sort data=lv_insps_clus out=lv_insps_clus_sort;
    	by cluster;
    	format cluster cluster.;
run;



/* Specifying the number N will pull N from each strata, multiplying by the number of clusters */
proc surveyselect data=lv_insps_clus_sort noprint
	out=lv_insps_clus_sample 
	method=srs 
	n=2
	seed=1; 
	strata cluster;
run;

title'Random Selection of Restaurants Clustered';
proc sgscatter data=lv_insps_clus_sample;
    	matrix sum_demerits max_demerits avg_demerits min_demerits total_inspections / group=cluster;
run;


/* GEOGRAPHIC CLUSTERING */

proc format; 
	value cluster 	2='Highest Violations'
			1='Intermediate-High Violations'
			4='Intermediate Violations'
			3='Low Violations'
			5='Lowest Violations';
run;


options orientation=landscape;
ods graphics/ antialiasmax=14800 tipmax=14800 width=10.25in height=7.5in;
title 'Map of Buffets, by Violation Cluster';
proc sgplot data=lv_insps_clus_sort;
	format cluster cluster.;
	where (loc1 < 36.5 and Loc1 >35.9)
    		and (loc2 <115.50 and loc2 >114.75);
	scatter x=loc1 y=loc2 / group=cluster;
run;
ods graphics / reset;






