#' Intro to Data Analysis  
#' R Code for Lecture 3
#' @author Ram Narasimhan
#' Data Manipulation and Summarization
#' 

# Let's Read the input files for use later on.

## CHANGE PATH TO THAT OF YOUR LAPTOP
gdp <- read.csv("~/data/countries_wide.csv")
names(gdp)

## CHANGE PATH TO THAT OF YOUR LAPTOP
getwd()
santa <- read.csv("data/KCASANTA142.csv")
names(santa)
head(santa)
dim(santa)

# Split the Time column
daytime <- strsplit(as.character(santa$Time), " ")
library("plyr")
df <- ldply(daytime)
colnames(df) <- c("Date", "_Time")
santa <- cbind(santa, df)
str(santa)

### 

## CHANGE PATH TO THAT OF YOUR LAPTOP
gdp <- read.csv("~/Documents/Personal/Analytics/data/countries_wide.csv")
names(gdp)

## CHANGE PATH TO THAT OF YOUR LAPTOP
santa <- read.csv("~/data/KCASANTA142.csv")
names(santa)
head(santa)
dim(santa)

############################

# Understanding NaN

Inf/Inf #one way to create NaN
x <- 4/0
x/x
class(x/x) #Note the type. Not a number is also of type numeric

x <- 4/0
y<- x/x
is.nan(y) #This is how you detect a NaN
# [1] TRUE


#' Understanding NA's
#' 
#' 
x <- c(3,4, NA, 6)
x
x[3]
class(x[3]) #numeric
is.na(x)
na.omit(x)


y <- c(TRUE, NA, FALSE, TRUE)
class(y[2])


####
duplicated(iris)
iris[143,]
iris[with(iris, Sepal.Length==5.8),]


## DEALING WITH NA's

airquality$Ozone #make sure that we do see some NA's

#First, run is.na() on the column.
is.na(airquality$Ozone)

#How many Ozone values are NA?
sum(is.na(airquality$Ozone))

#Shortcut. Simply use summary()
summary(airquality) #Notice that Summary tells us how many NA's there are

#Print ROWS that DON'T have an NA for Ozone
airquality[!is.na(airquality$Ozone) , ]

#But wait, airquality$Solar.R has NA's too.
na.omit(airquality)

# USING COMPLETE CASES
airquality[complete.cases(airquality), ]

#Finally, let's convert these NA's to 0s
#Note this is not always a good idea. 0s are very different from NA's
tf <- is.na(airquality$Solar.R) # TRUE FALSE conditional vector
airquality$Solar.R[tf] <- 0
summary(airquality)


#---------------------------------------------
#Convert strings to numbers
as.numeric("18.3")
as.integer("18")
as.integer("18.9") #rounds it down to an integer
as.numeric("18a")

#Extract Numbers from Strings
x <-  '8 23 37 38 20 40 39 41 21 33'
tokens <- strsplit(x, " ")
str(tokens)
vec <- unlist(tokens)
str(vec)
nums <- as.numeric(vec)
str(nums)

# or in one line - efficient perhaps, but less readable
nums <- as.numeric(unlist(strsplit(x," ")))
str(nums)
#---------------------------------------------



# Split the Time column
daytime <- strsplit(as.character(santa$Time), " ")
library("plyr")
df <- ldply(daytime)
colnames(df) <- c("Date", "_Time")
santa <- cbind(santa, df)
str(santa)

##--- factors in R ------------------#
class(iris$Species)
iris$Species[1:5] #notice that all Levels are listed

str(mtcars)
#Let's make the "gear" column into a factor
mtcars$gear <- as.factor(mtcars$gear)
str(mtcars$gear)
##--- factors in R ------------------#

### USE of SUBSET() COMMAND
# Format: subset(dataframe, condition)

# Note: movies is present in ggplot2
# To keep only the R-rated movies
subset(movies, mpaa=="R") 
subset(iris, Species=="versicolor")
subset(iris, Sepal.Length > 7)

#Let's find the Murder Rate of the States in the highest Quartile
topQuartileMurderRate <- quantile(USArrests$Murder)[4]
#Now print the Arrests for these states with the highest Arrests for Murder
subset(USArrests, Murder > topQuartileMurderRate )

# USE OF Subset to get condition and only print out certain columns.
# We have to use the select argument to get the columns we want.
# If multiple columns are desired, use c(column1, column2, column3)
subset(USArrests, Murder > topQuartileMurderRate, select=UrbanPop )

# TO DROP COLUMNS FROM DATA SETS USING just the column names subset()
smallUSArrests <- subset(USArrests, select=c(-UrbanPop, -Rape)) #Minus means we don't want those columns




#################
# TABLE
Usage: table(vector)
table(iris$Species)

table(mtcars$gear)
table(mtcars$cyl)
table(mtcars$gear, mtcars$cyl) #put it together to create a summary table

names(mtcars)

names(movies)
library(ggplot2)
#Table Using "with" -- notice that we don't need to use $
with(movies, table(year))
with(movies, table(length))
with(movies, table(length>200))


#---------------
# X T A B S
#---------------
#CROSS TABULATION
#xtabs Uses the 'formula syntax'


xtabs(Freq ~ Class, data=Titanic)
xtabs(Freq ~ Sex, data=Titanic)
xtabs(Freq ~ Survived, data=Titanic)

#-- Make it slightly more complex. Bring in TWO VARIABLES.

#Notice the difference between the following two commands
xtabs(Freq ~ Survived+Sex, data=Titanic)
xtabs(Freq ~ Sex+Survived, data=Titanic)
#In the first Survived is the rows. In the other, Survived becomes the columns



########################
#AGGREGATE
########################

#---- 
# Aggregate WITHOUT USING THE FORMULA SYNTAX
# You can also use aggregate without the formula syntax.
# Here are some examples.

aggregate(airquality, by=list(airquality$Month), FUN=mean)
aggregate(airquality, by=list(airquality$Month), FUN=mean, na.rm=TRUE)
aggregate(airquality, by=list(airquality$Month, airquality$Day), FUN=mean, na.rm=TRUE)

#BONUS Example
aggregate(state.x77, list(Region = state.region), mean)


#-----
# USING FORUMLA SYNTAX
#------

aggregate(data=airquality, Ozone~Month, mean)
aggregate(data=airquality, Ozone~Month+Day, mean)

#use cbind if you want to aggregate more than one variable
aggregate(data=airquality, cbind(Ozone,Wind)~Month+Day, mean)

#Bonus Example: IRIS DATA SET
aggregate(. ~Species, data=iris, FUN='length')
aggregate(Species ~ Sepal.Length, data=iris, FUN='length') #this is NOT what we want


# ------------------------
# C U T
# ------------------------

grouped.T <- cut(santa$TemperatureF, 10)
summary(grouped.T)

breaks=seq(0,100, by =10)
nice.groups <- cut(santa$TemperatureF, breaks)
summary(nice.groups)

hml <- cut(santa$TemperatureF, breaks=c(0, 70, 90, 110), labels=c("Low","Medium","High"))
summary(hml)

#--------------------------------
# A P P L Y Family of Functions
#-------------------------------

apply(mtcars, 1, max) #take each row of mtcars, and find its max value.

apply(iris[,1:4], 1, mean) #caution: This is just for illustration.
#taking the mean of a bunch of different columns usually doesn't make mathematical sense.

#applying functions to columns
apply(mtcars, 2, summary)


summary(movies)

# L A P P L Y

lst <- list(1,"abc", 1.3, TRUE)
listClasses <- lapply(lst, class)
listClasses

#--- SAPPLY might be even better 
#--- understand the difference between the two commands:
lClasses <- lapply(lst, class)
sClasses <- sapply(lst,class)
str(lClasses)
str(sClasses)


lClasses <- lapply(mtcars, mean)
sClasses <- sapply(mtcars,mean)
str(lClasses)
str(sClasses)



lapply(airquality$Ozone, round)
sapply(airquality$Ozone, round)

sapply(airquality, max)
head(airquality)


#-------BY------------
# Notice the contrast when using BY
# By is a "group by" for different factors
by(iris[, 1:4], Species, colMeans)


# L A P P L Y

l <- lapply(iris, class)
s <- sapply(iris,class)

lapply(airquality$Ozone, round)
sapply(airquality$Ozone, round)

sapply(airquality, max)
head(airquality)


# T A P P L Y

#hts of 10 people 
heights <- c(177, 153, 133, 121, 164, 161, 127, 122, 180, 161, 131, 128)
groupIndex <- c("Male", "Woman", "Child", "Child","Male", "Woman", "Child", "Child","Male", "Woman", "Child", "Child")
#IMPORTANT: heights and index should be of the same length. 
# Each element of the vector should have an group identified in the Index vector.
tapply(heights, groupIndex, mean)



gdp <- read.csv("~/data/countries_wide.csv") #replace this with the right path for your file
str(gdp)
tapply(gdp$POP, gdp$country.isocode, mean)
tapply(gdp$POP, list(gdp$country.isocode,gdp$year), mean)


############
# D D P L Y 
############
library(plyr)
#Let's use the in-built Titanic dataset to understand ddply
#what does ddply do?
# DDPLY: For each subset of a data frame, apply function then combine results into a data frame

str(Titanic)
titanic <- as.data.frame(Titanic)
titanic
ddply(titanic, .(Class), summarize, Total=sum(Freq))
ddply(titanic, .(Class, Survived), summarize, Total=sum(Freq))
ddply(titanic, .(Sex, Survived), summarize, Total=sum(Freq))
ddply(titanic, .(Class, Sex, Survived), summarize, Total=sum(Freq))


str(titanic)



## M E R G E
x <- data.frame(hrs=c(3,4,7), values=1:3)
x
We want to fill in all missing hrs from 1 to 10, and fill in the value 0 for those.
allhours <- data.frame(hours=1:10) 
allhours

merge(x, allhours, all=T, by.y="hours", by.x="hrs")
df <- merge(x, allhours, all.y=TRUE, by=c("hrs"))
df # convert the NA to 0
df$values[is.na(df$values)] <- 0
df



### TIDY DATA
##  RESHAPING
############

str(iris)
iris
dim(iris)
names(iris)
library(reshape2)

m.iris <- melt(iris)
names(m.iris)
dcast(m.iris, Species~variable)

m.iris <- melt(data=iris, id.var="Species")
#Once you melt it this way, no way to "remember" which rows came from where.

#need a row ID
iris$id <- row.names(iris)
irislong <- melt(iris, c("Species", "id"))
dcast(irislong, Species+id~variable)

gdp
melt(gdp)
m.gdp <- melt(gdp, id.vars=c("country","country.isocode", "year"))
names(m.gdp)
dcast(m.gdp, country.isocode+year ~ variable)

## DATE AND TIME MANIPULATION
as.Date('2013-10-30')
dte <- c("02/27/13")
as.Date(dte, "%m/%d/%y")

# You can use ISOdate to combine elements and then convert to a date type
ISOdate(year, month, day) and then as.Date()
as.Date(ISOdate(2013,1,1))

#The format() argument inside date
#format(Sys.Date(), format=“%m/%d/%Y”
#       Extracting Parts of a Date
d <- as.Date("2013-10-15")
p <- as.POSIXlt(d)
# Get parts of p
p$mon; p$year+1900


s <- as.Date("2013-10-01")
e <- as.Date("2013-11-01")
#Creating a Sequence of Dates
seq(from=s, to=e, by=1)
seq(from=s, by='year', length.out=3)
       


