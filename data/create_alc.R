# Sara Allaouat 
# 09.11.2019 
# Exercise 3 data wrangling
# Reference: https://archive.ics.uci.edu/ml/datasets/Student+Performance

#Importing and exploring 'student-por.csv' in R
## This dataset has 649 observations of 33 variables, including 16 integer variables and 17 factor variables. 
student_por <- read.table("~/IODS-project/student-por.csv", header = T, sep = ";")
student_por
str(student_por)
dim(student_por)

#Importing and exploring 'student-mat.csv' in R
## This dataset has 395 observations of 33 variables, including 16 integer variables and 17 factor variables. 
student_mat <- read.table("~/IODS-project/student-mat.csv", header = T, sep = ";")
student_mat
str(student_mat)
dim(student_mat)

## The two datasets have the same variables
identical(colnames(student_mat), colnames(student_por))

# Merging the two datasets in one, given specific variables (student identifers). 
## The function 'inner_join' returns the students present in both datasets.
## The new dataset 'mat_por' has 382 observations representing students in both 'student_por' and 'student_mat'.
## It has also 53 variables, including the 13 student identifiers, 20 variables with results from 'student_mat' and 20 same variables with results from 'student_por'.
library(dplyr)
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")
mat_por <- inner_join(student_mat, student_por, by = join_by, suffix = c(".mat", ".por"))
str(mat_por)
dim(mat_por)

## Further exploration 
identical(mat_por$guardian.mat, mat_por$guardian.por)
which(mat_por$guardian.por != mat_por$guardian.mat)

# Cleaning the dataset by combining duplicated answers to the same questions.
## Creating the cleaned dataset frame 'alc'
alc <- select(mat_por, one_of(join_by))

## Accessing the '.mat' columns
notjoined_columns <- colnames(student_mat)[!colnames(student_mat) %in% join_by]
notjoined_columns

## For every '.mat' column, merge it with a '.por' column which has the same original name. 
## The entries will be from '.mat' column.
## If the vector of '.mat' column is numeric, take the rounded average of entries 
## in '.mat' and '.por' columns to the 'alc' dataframe. If not, report the entries of '.mat' to 'alc'.
for(column_name in notjoined_columns) {
  two_columns <- select(mat_por, starts_with(column_name))
  first_column <- select(two_columns, 1)[[1]]
  
  if(is.numeric(first_column)) {
    alc[column_name] <- round(rowMeans(two_columns))
  } else { 
    alc[column_name] <- first_column
  }
}

## glimpse at the cleaned dataset 'alc'
### 'alc' has now 382 observations and 33 variables.
glimpse(alc)


# Add column 'alc_use' by averaging column 'Dalc' and column 'Walc' entries.
# Add column 'high_use' where alc_use > 2.

alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
alc <- mutate(alc, high_use = alc_use > 2)

#The dataset now has 382 observations of 35 variables. 
glimpse(alc)


#Saving the new dataset to the 'data' folder 
setwd("~/IODS-project/data")
write.table(alc, file="alc.csv")

