# Sara Allaouat 09.11.2019 exercise 2 data wrangling
# name learning 2014 dataset as 'lrn14' and read it from the link provided 
lrn14 <- read.table("https://www.mv.helsinki.fi/home/kvehkala/JYTmooc/JYTOPKYS3-data.txt", header = TRUE, sep = '\t')
#print learning 2014 dataset table 
lrn14

# structure of 'lrn14'
## 60 variables of which 56 categorised from 1 to 5, 
##in addition to age of participants, gender (male/female), 
## attitude and points (0 to 30).
### further exploration with learn$, which.max(), which.min().
str(lrn14)

# dimension of 'lrn14'
## 183 observations (rows) of  60 variables (columns)
dim(lrn14)

#Create an analysis dataset with the variables 
#gender, age, attitude, deep, stra, surf and points:

##1. Create 'deep' variable from corresponding questions
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31") 
deep_columns <- select(lrn14, one_of(deep_questions)) 
lrn14$deep <- rowMeans(deep_columns) 

##2. Create 'surf' variable from corresponding questions
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32") 
surface_columns <- select(lrn14, one_of(surface_questions)) 
lrn14$surf <- rowMeans(surface_columns) 

##3. Create 'stra' variable from corresponding questions
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28") 
strategic_columns <- select(lrn14, one_of(strategic_questions)) 
lrn14$stra <- rowMeans(strategic_columns) 

##4. Select the variables for the new dataset 
install.packages("dplyr")
library(dplyr) 
lrn14 %>% select(gender,Age,Attitude,deep,stra,surf,Points) 

#Scale all combination variables to the original scales (by taking the mean). 
##1. For deep, surf, and stra this is not needed because the means were used to create them
## so they are already in their original scale.
##2. For Attitude, from the metadata one can see that the variable is made 
##from an overall score of 10 questions. So this variable should be devided by 10 to have the original scale
lrn14$attitude <- lrn14$Attitude/10

# Create the new dataset and exclude observations where the exam points variable is zero (in one line).
# This gives a dataset with 166 observations and 7 variables
learning2014 <- lrn14 %>% select(gender,Age,attitude,deep,stra,surf,Points) %>% filter(Points!=0)

# Set the working directory of you R session the iods project folder:
setwd("~/IODS-project")

#Save the analysis dataset to the 'data' folder, using for example write.csv() or write.table() functions.
setwd("~/IODS-project/data")
write.table(learning2014, file="learning2014.txt")

#Demonstrate that you can also read the data again by using 
#read.table() or read.csv().  (Use `str()` and `head()` 
#to make sure that the structure of the data is correct).
#Indeed data is correct
read.table("learning2014.txt")
str(learning2014)
head(learning2014)
