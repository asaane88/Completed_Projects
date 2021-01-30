# Movie Genre Prediction
![Kaggle](https://img.shields.io/badge/Dataset-Kaggle-blue.svg) ![Python 3.6](https://img.shields.io/badge/Python-3.6-brightgreen.svg) ![NLTK](https://img.shields.io/badge/Library-NLTK-orange.svg)

## Overview
This project is for the prediction of the genres of a movie using its plot summary. I have used recurrent neural networks with Long Short Term Memory (LSTM) units for the classification task.

## Motivation
I have been an avid movie watcher. I am generally able to guess the genres of a movie in my mind while reading the plot summary of that movie. So, I got the idea of making this fun little project to see if a deep learning implementation could do the genre prediction task for me.

## Libraries and Frameworks

Deep Learning library - Keras 2.0 ( with TensorFlow as backend)
Web Framework - Flask
Dataset

In order to create the dataset for this experiment, you need to download genres.list and plot.list files from ftp://ftp.fu-berlin.de/pub/misc/movies/database/, and then parse files in order to associate the titles, plots, and genres.

I’ve already done this, and parsed both files in order to generate a single file, available here movies_genres.csv, containing the plot and the genres associated to each movie.

## Project Description

The user interacts with a web application, currently hosted on localhost, where they can enter the plot summary of the movie and then the trained model makes the prediction about the genres of the movie. I have used the micro web-framework Flask to interface my trained RNN model with the web application.

For the firstpass of the algorithm, the code for the training of the model is invoked. The model is trained using GloVe word embeddings for the encoding of the words. More information about GloVe embeddings can be found here.

After the firstpass is completed, a file 'firstpass' is created. For any further passes of the algorithm, the code for genre prediction is invoked. The result is passed to the web page through Flask for display.

## Results

The F1 score achieved on the test set by the model in the code was 0.95.
The exact prediction accuracy achieved on the test set by the model in the code was 78%.
