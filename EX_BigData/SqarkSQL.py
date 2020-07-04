Executing SQL Commands with Spark

# importing required libraries
from pyspark.sql import SQLContext
from pyspark.sql import Row

# read the text data
raw_data = sc.textFile('sample_data_final_wh.txt').cache()

# get number of partitions
raw_data.getNumPartitions()
## >> 19

# view top 2 rows
raw_data.take(2)

# create spark sql context
sql_context = SQLContext(sc)

# split the data
csv_rdd = raw_data.map(lambda row: row.split(',')) 

# top 2 rows
csv_rdd.take(2)

# map the datatypes of each column
parsed = csv_rdd.map(lambda r : Row( age = int(r[0]),
                                     blood_group = r[1],
                                     city = r[2],
                                     gender = r[3],
                                     id_ = int(r[4])))
# top 5 rows
parsed.take(5)


# create dataframe 
data_frame = sql_context.createDataFrame(parsed)

# view the dataframe
data_frame.show(5)

# value counts of gender
data_frame.groupby('gender').count().show()

# register temporary table
data_frame.registerTempTable('sample')

# get the value count using the sql query
gender = sql_context.sql(" SELECT gender, count(*) as freq from sample GROUP BY gender ")

# view the results
gender.show()

# average age city wise
average_age = sql_context.sql(" SELECT city, AVG(age) as average_age from sample GROUP BY city ")

# view the results
average_age.show()