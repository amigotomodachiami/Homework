install.packages("swirl")
packageVersion("swirl")
library(swirl)
install_from_swirl("R Programming")
swirl()

#HW3 
getwd()
# 2a. unzip the file from my local repository and move file to my homework folder
zipF<-"/Users/wailunchung/Documents/GitHub/awesome-public-datasets/Datasets/titanic.csv.zip"
outDir<-"/Users/wailunchung/Documents/SMU/MSDS6306_Doing_Data_Science/homeworks/W3"
unzip(zipF,exdir=outDir)
df = read.csv(paste(outDir,"/titanic.csv",sep=""))

# 2b. Simple Bar Plot with count of female and males
counts <- table(df$Sex)
barplot(counts, main="Count of Female and Males Aboard the Titanic", xlab="Sex")

# 2c. print mean of age, fare and survial.
df2 <- data.frame(df$Age, df$Fare,df$Survived)
sapply(df2, mean, na.rm = T) 

# 3 load data from internet
library(RCurl)
sleep <- getURL("http://talklab.psy.gla.ac.uk/L1_labs/lab_1/homework/sleep_data_01.csv")
sleepdata <- read.csv(textConnection(sleep),header=T)

# 3a create objects for 
# median Age, min dur of age, max dur of age, mean RSES, sd RSES
MedianAge <- median(sleepdata$Age, na.rm=T)
Min_Dur <- min(sleepdata$Duration, na.rm=T)
Max_Dur <- max(sleepdata$Duration, na.rm=T)
SelfEsteem <- mean(sleepdata$RSES, na.rm=T)
SE_SD <- sd(sleepdata$RSES, na.rm=T)
Dur_Range <- (Max_Dur - Min_Dur)
report <- data.frame("MedianAge"=MedianAge,"SelfEsteem"=SelfEsteem, "SE_SD" = SE_SD/5,"DurationRange" = Dur_Range)
# 3d round to 2 decimal
report = round(report, digits=2)

#4a
install.packages("fivethirtyeight")
#4b
library(fivethirtyeight)
df <- college_recent_grads
#4c
vignette("fivethirtyeight", package = "fivethirtyeight")
#http://fivethirtyeight.com/features/the-economic-guide-to-picking-a-college-major/
#4d
dim(df)
colnames(df)

#5a
dim(df)
ncol(df)
#5b
library(plyr)
major_count <- count(df,"major_category")
#5c
par(las=2) 
barplot(major_count$freq,main="Major Category Count",col="blue",horiz=TRUE,names.arg=major_count$major_category,xlab="major count",ylab="major category",xlim=c(0,30))
#5d
write.table(major_count,file="/Users/wailunchung/Documents/SMU/MSDS6306_Doing_Data_Science/homeworks/W3/major_count.csv" ,sep=",",row.names=FALSE,col.names=TRUE)

#6a
