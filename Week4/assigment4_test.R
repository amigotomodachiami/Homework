library(XML)
library(dplyr)
library(tidyr)
library(stringi)
library(rvest)
library(ggplot2)
library(RCurl)
library(WDI)
library(plyr)

data <-getURL("https://www.w3schools.com/xml/simple.xml")
doc <- xmlParse(data)
names <- xpathSApply(doc,"//name",xmlValue)
price <- xpathSApply(doc,"//price",xmlValue)
description <- xpathSApply(doc,"//description",xmlValue)
bfasts = data.frame(names,price,description)
bfasts
bfasts$description
which(grepl("toast",bfasts$description))
grep("covered",bfasts$description)


data <-getURL("http://www.imdb.com/title/tt1201607/fullcredits?ref_=tt_ql_1")
#1A / 1B
hp<-read_html("http://www.imdb.com/title/tt1201607/fullcredits?ref_=tt_ql_1")
hp_table<-html_nodes(hp,"table")
derp<-html_table(hp_table)
derp[3]

#1C - Cleaning
a<-data.frame(derp[3])
names(a) <- c("Blank", "Actor", "Blank2","Character")
df<-a[2:length(a$Actor),c("Actor", "Character")]
df$Character[10] <- "Griphook / Professor Filius Flitwick"

# 1D -Edit The Cast List
b<-df %>%
  slice(-92) %>% # Removes the row that is just noting the rest is alphabetical
  separate(Actor, into=c("FirstNames", "Surname"), sep="[ ](?=[^ ]+$)") # Separates the Last Name

#1E 
head(b, 10)

#2A / 2B
sas <-read_html("http://www.espn.com/nba/team/stats/_/name/sa/san-antonio-spurs")
sas_table<-html_nodes(sas,"table")
derp_sas<-html_table(sas_table, fill=TRUE)
#2C Cleaning tables
player_stats1 = derp_sas[[6]]
player_stats2 = derp_sas[[8]] 

player_stats = cbind(player_stats1,player_stats2)

player_stats<-player_stats %>%
  slice(-14) %>% # Removes the total row
  separate(Name, into=c("Name", "Position"), sep="[ ](?=[^ ]+$)") #Separate the name and position

player_stats<-player_stats[c("Name","Position","FG%")]
player_stats$Position <- as.factor(player_stats$Position)

#check type
sapply(player_stats, class)

#2D plot
par(las=2,mar=c(11,10,5,3),mgp=c(2,1,0)) 
#barplot(player_stats$'FG%',main="SA Spurs 18-19 Field Goal Percentage",col="blue",names.arg=player_stats$Name,xlab="Player",ylab="FG%",ylim=c(0,100))
#freq table
position_freq <- count(player_stats$Position)
#count number of position
number_of_position <- nrow(position_freq)
#rainbow color
mycolor <- rainbow(number_of_position)
par(las=2)
barplot(player_stats$'FG%',main="SA Spurs 18-19 Field Goal Percentage",col=mycolor[player_stats$Position],names.arg=player_stats$Name,xlab="Player",ylab="FG%",ylim=c(0,100))
#custom color with static number of position of 5
colortest <- c("blue","red","yellow","green","grey")
barplot(player_stats$'FG%',main="SA Spurs 18-19 Field Goal Percentage",col=colortest[player_stats$Position],names.arg=player_stats$Name,xlab="Player",ylab="FG%",ylim=c(0,100))

colortest[1]

j=data.frame(plot=c("N10-11","N10-14","N13-11","N13-14"),
             dbh=as.numeric(c("60.6","68.5","55.6","61.5")),
             year=c("2011","2014","2011","2014"))
mycols <- c("red","blue")
barplot(j$dbh, names.arg = j$plot, ylab = "dbh" , 
        col = mycols[j$year], ylim=c(0,70))

barplot(player_stats$'FG%', names.arg=player_stats$Name, ylab = "dbh", col=mycols[player_stats$Position], ylim=c(0,70))
player_stats$Position
position_freq
str(player_stats)
str(j)
