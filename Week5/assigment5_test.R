URL <- "http://bit.ly/1jXJgDh"
temp <- tempfile()
download.file(URL,temp)
UDSData <- read.csv(gzfile(temp,"uds_summary.csv"))
dim(UDSData)
names(UDSData)
str(UDSData)

install.packages("nycflights13")
library(nycflights13)
data()

#Week5

#1a
getwd()
setwd("/Users/wailunchung/Homework/Week5")
y2016 <- read.csv("yob2016.txt",sep=";",header=FALSE)
y2016 = setNames(y2016,c("name", "gender", "count_2016"))
#1b
summary(y2016)
str(y2016)
dim(y2016)
#1c check freq =2 and end="yyy"
grep("yyy$", y2016$name, value = TRUE)
row_to_remove = grep("yyy$", y2016$name, value = FALSE)
row_to_remove
y2016$name[row_to_remove]
#1d remove that name, save ->y2016
y2016 <- y2016[-c(row_to_remove), ]
y2016$name[row_to_remove]

#2a
y2015 <- read.csv("yob2015.txt",sep=",",header=FALSE)
y2015 = setNames(y2015,c("name", "gender", "count_2015"))
#2b describe last 10
tail(y2015,10)
# seems like the data is sort by name
#2c merge
final <- merge(y2015, y2016, by=c("name", "gender"))
head(final)

#3a get total 2015+2016
final$total <- final$count_2015+final$count_2016
head(final)
#3b sort and find top 10
#attach(final)
newfinal <- final[order(-final$total),]
head(newfinal,10)
#3c suppress boys
girlfinal=newfinal[newfinal$gender == "F", ]
#3d write top 10 girls in csv
head(girlfinal,10)
girlfinal <- girlfinal[1:10,]
girlfinal <-select(girlfinal, name,total)
head(girlfinal,20)
write.table(girlfinal,file="top_10_popular_baby_girl_name.csv",sep=",",row.names=FALSE,col.names=TRUE)




