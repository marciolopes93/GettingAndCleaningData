---
title: "Getting and Cleaning Data: readme"
author: "Marcio Lopes"
date: "31 January 2016"
output: html_document
---

The `run_analysis.R` file downloads _Human Activity Recognition Using Smartphones_ data from the UCI machine learning repository. All processing is done with `run_analysis.R` in R. The output is a clean `tidy.txt` file which can be used for downstream analysis.

`run_analysis.R` does as follows:

1. Downloads and unzips the dataset
2. Reads in relevant files (`features`, `activity_labels`, `subject_train`, `X_train`, `y_train` and analagous test files) and labels colums appropriately (mainly as per `features`)
3. Test and training sets are combined into one data frame called `data`
4. All columns pertaining to mean and standard deviation only, as well as `Subject` and `ClassLabel` are kept, and stored as `subset`
5. `ClassLabel` is then stored as a more descriptive `ActivityName` and other variables are saved with easier to read names
6. The average of each variable for each activity and each subject is taken from `subset` and the output is `tidy.txt`