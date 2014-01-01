#' Intro to Data Analysis  
#' R Code for Lecture 4
#' OBTAINING DATA (from the web)
#' @author Ram Narasimhan
#'

### LECTURE 4 Concepts
## READING FROM THE WEB
###

rm(list=ls())

#Reading Raw data directly from the Web
# First, take a look at http://data.princeton.edu/wws509/datasets/ 
# to see what's available.
copenhagen <- read.table("http://data.princeton.edu/wws509/datasets/copen.dat", header=TRUE)

divorce <- read.table("http://data.princeton.edu/wws509/datasets/divorce.raw", 
                      col.names=c("cplID","heduc","heblack","mixed","years","divIndicator"))
head(divorce)
str(divorce)
head(copenhagen)

#-------------------
read.csv("http://ichart.finance.yahoo.com/table.csv?s=MSFT&a=02&b=13&c=2013&d=07&e=26&f=2013&g=m")

## We want to fetch S&P500 daily range for all of 2012
# This involves several steps, all around building the URL step by step.
# All details can be found at this site:
# http://code.google.com/p/yahoo-finance-managed/wiki/csvHistQuotesDownload

base.url <- "http://ichart.finance.yahoo.com/table.csv?s="
symbol <- "%5EGSPC" # S&P 500
start.date <- "&a=0&b=01&c=2012" # a = Start.month-1, b = Day c=YYYY
end.date <- "&d=11&e=31&f=2012" # d = Ending.month e=day f=YYYY
timeinterval <- "&g=d" #m = monthly #w=weekly #d=daily
coda <- "&ignore=.csv" #static
url <- paste0(base.url, symbol, start.date, end.date, timeinterval, coda)
read.csv(url)

#######################
U S I N G    ReadHTMLTable
IN XML Package
################
library(XML)
url <- 'http://www.bls.gov/web/laus/laumstrk.htm'
t = readHTMLTable(url)
str(t) ## IMPORTANT. Notice that there are 2 tables. Looks like we need the second one
unemp.raw = readHTMLTable(url)[[2]]
unemp = readHTMLTable(url, colClasses = c('character', 'character', 'numeric'))[[2]]
names(unemp)
str(unemp.raw); str(unemp) #notice the difference. Factor vs. Numeric
unemp #this data frame is what we want


## BONUS Example. 
## How to Read all the courses in UCSC-X Database Systems department?
url.ucs <- "http://www.ucsc-extension.edu/programs/database-systems/schedule"
t <- readHTMLTable(url.ucs)
str(t) #looks like we got 4 tables.
#The second one is what we want
electives <- t[[2]]
electives <- electives[, c(1,2,3)]
electives 
# we can then delete blank rows, and rows without credits to get all the courses.



## BONUS Example: How to get the list of the top 250 movies from IMDB
library(RCurl)
library(XML)
html <- getURL("http://www.imdb.com/chart/top")
table.html<- readHTMLTable(html)
str(table.html)
movies.table <- table.html[[1]]
movies.table[1:2]



# Reference Links for this lecture
http://answers.oreilly.com/topic/1629-how-to-import-data-from-external-files-in-r/
http://stackoverflow.com/questions/1395528/scraping-html-tables-into-r-data-frames-using-the-xml-package
http://www.programmingr.com/content/webscraping-using-readlines-and-rcurl/
  
  


