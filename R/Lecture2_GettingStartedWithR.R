#' R Code for 30211 - Lecture 2
#' Getting a feel for R
#' @author Ram Narasimhan
#' 

#USING R as a calculator
15 * 7.7 #simple math
x <- 3  #assign. In R syntax <- is used over =
x <- 3:10 #assign a set of values
x * 3 # element-wise operations


# Using it for basic stats
a <- 1:10
b <- c(4,4,4,5,5,6,6,6,7,8)
c <- c(1,1,1,1,1,10,10,10,10,10)

mean(a)
mean(b); mean(c)

sd(a); sd(b); sd(c)

####################
# Getting Help

??Binomial # broader search
?Binomial  #When you know the function name
help(Binomial)

####################

.libPaths() # Where are the libraries stored
ls(package:ggplot2) #everything in a particular library
notes <- help.search('aes', package='ggplot2')

#########
# FINDING OUR WAY WITHIN DIRECTORIES

getwd() # get working dir. Equivalent to Unix pwd
setwd("~/RStats")

ls() #which objects are in memory
rm() #remove an R object
rm(list=ls()) #clean start
search() #which pkgs are loaded into R


list.files() #to search current director
dirpath <- “~/Rstats”
dir(dirpath, full=TRUE)
  
##########################
# R E A D data into R

presidents <- read.csv("~/Documents/Personal/Analytics/data/USPresidents.csv")

save(presidents, file='USP.Rdata')
write.csv(presidents, file='data/pres1.csv')

#Verify that the data was read as intended
class(presidents)
dim(presidents)
names(presidents)
str(presidents) #hey what's with all these factors?

#Let's fix those 'factors'
presidents <- read.csv("~/Documents/Personal/Analytics/data/USPresidents.csv"
                       , stringsAsFactors=FALSE)

str(presidents)


# V E C T O R S 
6:10 # The numbers
c(TRUE,FALSE,FALSE) #Logical
c('Santa Clara','San Ramon', 'SFO', 'San Jose')
x <-  c(a = 'SC', b = 'SR', c= 'SJ')
x['a']
class(x)
mean(x)


# SUBSETTING USING LOGICAL CONDITIONS

temp <- c(77,50,63,71,44,68)
temp>68
temp[temp>68]


presidents$Home.State == "Virginia"
cond <- presidents$Home.State == "Virginia"
presidents$Name[cond]


### IN CLASS EXERCISE

x <- c(1,2,3,4)
y <- c(3,4,5)
z <- c(7,8)

x+2
x*2
x+y
x+z

#################
# BASIC PLOTTING
################

?plot
?qqnorm
?par

?faithful # an in-built dataset
plot(faithful)
plot(faithful, type='l')
plot(faithful, type='p')

plot(faithful, type='p', ann=FALSE)
title(main="The Title", xlab="X Axis Label", ylab="Y Axis Label")
hist(faithful$waiting)

######################






