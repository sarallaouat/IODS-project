# Sara Allaouat 09.12.2019 exercise 6 data wrangling

# Loading datasets to R, exploring and saving them 

BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep  =" ", header = T)
BPRS
str(BPRS)
dim(BPRS)
summary(BPRS)
colnames(BPRS)
## BPRS has 40 observations of 11 variables (9 weeks, 2 treatment groups and 20 observations for each treatment group)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE, sep = '\t')
RATS
str(RATS)
dim(RATS)
summary(RATS)
colnames(RATS)
## BPRS has 16 observations of 13 variables (11 time points, 3 intervention groups and respectively 8, 4 and 4 observations for each intervention group)

setwd("~/IODS-project/data")
write.table(BPRS, file="BPRS.txt")

setwd("~/IODS-project/data")
write.table(RATS, file="RATS.txt")

# Converting categorical variables to factors
install.packages("dplyr")
install.packages("tydir")
library(dplyr)
library(tidyr)
## BPRS
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

## RATS
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

# Converting datasets to long form 
## BPRS
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject) %>%
mutate(week = as.integer(substr(weeks,5,5)))
BPRSL
glimpse(BPRSL)
dim(BPRSL)
summary(BPRSL)
colnames(BPRSL)
### The new dataset has 360 observations of 5 variables. 
### It has the same information as the wide dataset but it is organized differently. 
### All 40 observations for every column week (total = 9 columns) are collapsed in one column (bprs) giving a total number of observations 40 x 9 = 360. 
### Additional variables describe the week number (weeks and week), the treatment group (treatement) and the unique participant number (subject).

## RATS
RATSL <- RATS %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD,3,4))) 
RATSL
glimpse(RATSL)
dim(RATSL)
colnames(RATSL)

### The new dataset has 176 observations of 5 variables. 
### The group variable indicates the intervention group number, 
### WD and Time indicate the time point of the measure, 
### the ID is the rat number and the weight is the measure of interest. 