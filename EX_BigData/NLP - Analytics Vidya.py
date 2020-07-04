# loading libraries and data

import re #for regular expressions
import nltk #for text manipulation
import string
import warnings
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

pd.set_option("display.max_colwidth", 200)
warnings.filterwarnings("ignore", category=DeprecationWarning)

%matplotlib inline

#Lets read train and test dataset 
train = pd.read_csv('train.csv')
test = pd.read_csv('test.csv')

# Data Inspection
train[train['label'] == 0].head(10)

train[train['label'] == 1].head(10)

train.shape
test.shape
#Train has 31,962 tweets and test has 17,197 tweets

train["label"].value_counts()
# 0 - 29720 (93 %) Non racists and non sexist
#1 - 2242 (7%) Racists and sexist

# Distribution of Data
length_train = train['tweet'].str.len()
length_test = test['tweet'].str.len()

plt.hist(length_train, bins=20, label="train_tweets")
plt.hist(length_test, bins=20, label="test_tweets")
plt.legend()
plt.show()

# Data Cleaning
combi = train.append(test, ignore_index=True)
combi.shape

# Function to remove unwanted text patterns from the tweets
def remove_pattern(input_txt, pattern):
r = re.findall(pattern, input_txt)
for i in r:
input_txt = re.sub(i, ", input_txt)
return input_txt

# Removing Twitter Handles (@User)
combi['tidy_tweet'] = np.vectorize(remove_pattern)(combi['tweet'], "@[\w]*")
combi.head()

# Removing Punctuation, Numbers and Special Characters
combi['tidy_tweet'] = combi['tidy_tweet'].str.replace("[^a-zA-Z#]","")
combi.head(10)

# Remove Short Words
combi['tidy_tweet'] = combi['tidy_tweet'].apply(lambda x: ''.join([w for w in x.split()if len(w)>3])) 
combi.head(10)

# Text Normalization
tokenized_tweet = combi['tidy_tweet'].apply(lambda x: x.split()) #Tokenizing
tokenized_tweet.head()

# Now we can normalize tokenized tweets
from nltk.stem.porter import *
stemmer = Porterstemmer()
tokenized_tweet = tokenized_tweet.apply(lambda x: [stemmer.stem(i) for i in x]) #Stemming

# Stitch Tokens together
for i in range(len(tokenized_tweet)):
tokenized_tweet[i] = ''.join(tokenized_tweet[i])
combi['tidy_tweet'] = tokenized_tweet