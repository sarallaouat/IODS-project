# Sara Allaouat 
# 25.11.2019 
# Exercise 4 data wrangling

# Reading  "Human development" and "Gender inequality" datasets 
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
hd
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")
gii

# Exploring the datasets
str(hd)
dim(hd)
colnames(hd)

## human development (hd) dataset has 195 observations of 8 variables, 
## of which 2 are character variables (country and Gross National Income),
## 2 are integer variables ( rank HDI, and rank GNI minus rank HDI) 
## and the rest numeric (HDI, life expectancy at birth, expected years of 
## education, mean years of education).

str(gii)
dim(gii)
colnames(gii)

## gender inequality index (gii) has 195 observations of 10 variables
## 1 character variable (country), 1 integer variable (maternal mortality ratio)
## and 8 numeric (gender inequality index, maternal mortality ratio, adolescent 
## birth rate, % representation in parliament, female and male with secondary education
## and female and male labour force participation)

# Renaming variables 
## Human Development dataset
install.packages("dplyr")
library(dplyr)
hd$HDIr <- hd$HDI.Rank
hd$cy <- hd$Country
hd$HDI <- hd$Human.Development.Index..HDI.
hd$health_birth <- hd$Life.Expectancy.at.Birth
hd$edu_exp <- hd$Expected.Years.of.Education
hd$edu_year <- hd$Mean.Years.of.Education
hd$GNI <- hd$Gross.National.Income..GNI..per.Capita
hd$GNIr_HDIr <- hd$GNI.per.Capita.Rank.Minus.HDI.Rank
hd <- select(hd, HDIr, cy, HDI, health_birth, edu_exp, edu_year, GNI, GNIr_HDIr)
glimpse(hd)

## Gender Inequality dataset
gii$GIIr <- gii$GII.Rank
gii$cy <- gii$Country
gii$GII <- gii$Gender.Inequality.Index..GII.
gii$MMR <- gii$Maternal.Mortality.Ratio
gii$ABR <- gii$Adolescent.Birth.Rate
gii$parliament <- gii$Percent.Representation.in.Parliament
gii$edu_f<- gii$Population.with.Secondary.Education..Female.
gii$edu_m <- gii$Population.with.Secondary.Education..Male.
gii$work_f <- gii$Labour.Force.Participation.Rate..Female.
gii$work_m <- gii$Labour.Force.Participation.Rate..Male.
str(gii)
gii <- select(gii, GIIr, cy, GII, MMR, ABR, parliament, edu_f, edu_m, work_f, work_m)
str(gii)

# Adding education and work ratios columns to Gender Inequality dataset
gii <- mutate(gii, work= work_f/work_m, edu=edu_f/edu_m)
str(gii)

# Combining the two datasets with "cy" as the identifying variable
human <- inner_join(hd, gii, by = "cy")
dim(human)
str(human) 

## the new dataset has 195 observations of 19 variables

# saving the new dataset to my working directory 
setwd("C:/Users/Sara Allaouat/Documents/IODS-project/data")
write.table(human, file = "human.txt")

# Loading the human dataset into R
setwd("C:/Users/Sara Allaouat/Documents/IODS-project/data")
library(dplyr)
human <- read.table("human.txt")
human
# Exploring the human dataset
str(human)
dim(human)
## The dataset has 195 observations of 19 variables including countries, education, health and economic indicators.

# Mutating GNI to numeric variable
human <- mutate(human, GNI = as.numeric(GNI))
str(human)

# Keeping only needed variables
keep <- c("cy", "edu", "work_f", "health_birth", "edu_exp", "GNI", "MMR", "ABR", "parliament")
human <- select(human, one_of(keep))
dim(human)

# Removing NAs

complete.cases(human)
data.frame(human[-1], comp = complete.cases(human))
human_ <- filter(human, complete.cases(human))
dim(human_)

## The dataset human_ has 162 observations of the 9 previously selected variables.
## There were 33 rows with missing values for at least one variable.

# Removing rows relating to regions
human_$cy 
last <- nrow(human_) - 7
last
human_2 <- human_[1:last,]
dim(human_2)
# Defining row names by country 
rownames(human_2) <- human_2$cy

# Removing the country column
human_2 <- select(human_2, -cy)
str(human_2)

## The final dataset has 155 observations and 8 variables.

write.table(human_2, file = "human2.txt")
