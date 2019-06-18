

#1a load the rda file
file_loc="/Users/wailunchung/Downloads/N-MHSS-2015-DS0001-bndl-data-r/N-MHSS-2015-DS0001-data/N-MHSS-2015-DS0001-data-r.rda"
load(file = file_loc)
#head(mh2015_puf,10)
#1b find distinct state abbreviations
library(plyr)
distinct(mh2015_puf,LST)
#1c remove AK, HI and keep mainland states only
#download 50 states files from internet
state_loc = "https://scottontechnology.com/wp-content/uploads/2014/08/50_us_states_two_letter_abbreviations.csv"
state_abb <- read.csv(url(state_loc),header=FALSE)
#remove AK, HI from the temp state df
state_abb2 <- subset(state_abb, !(state_abb$V1 %in% c("AK","HI")))
state_abb2$V1
str(state_abb2)
str(mh2015_puf) #LST is a factor and with spaces "AK    ","AL    "
#clean LST column
trim <- function( x ) {
  gsub("(^[[:space:]]+|[[:space:]]+$)", "", x)
}
mh2015_puf$LST = trim(mh2015_puf$LST)
#mh2015_puf$LST
#inner join 2 df to remove the AK, HI and non-mainland states
mh2015_puf2 <- merge(x=mh2015_puf,y=state_abb2,by.x="LST",by.y="V1")

#1d
#rainbow color
mycolor <- rainbow(48)

ggplot(mh2015_puf2, aes(LST)) + 
  geom_bar(fill=mycolor) + 
  labs(title="Number of VA hospital by state",subtitle="", x="State",caption="") +
  theme(plot.title = element_text(hjust = 0.5),axis.text.x = element_text(angle = 90, hjust = 1))

#2a
state_size_path<-"/Users/wailunchung/Documents/GitHub/MSDS-6306-Doing-Data-Science/Unit 6/statesize.csv"
state_size_df<-read.csv(state_size_path)
mh2015_puf3<-merge(x=mh2015_puf2,y=state_size_df,by.x="LST",by.y="Abbrev")
head(mh2015_puf3,10)
# I already found the issue in 1C, use paste to check one more time
head(paste(mh2015_puf$LST,'test'),10)
# there is a space!

#2b correct the problem (already done in 1C)
#clean LST column
trim <- function( x ) {
  gsub("(^[[:space:]]+|[[:space:]]+$)", "", x)
}
mh2015_puf$LST = trim(mh2015_puf$LST)
#inner join 2 df to remove the AK, HI and non-mainland states
mh2015_puf2 <- merge(x=mh2015_puf,y=state_abb2,by.x="LST",by.y="V1")
#inner join to add state size
mh2015_puf3<-merge(x=mh2015_puf2,y=state_size_df,by.x="LST",by.y="Abbrev")

#2c calculate VS hospital per thousand SqMiles
#merge dfs
library(plyr)
state_freq <-count(mh2015_puf3$LST)
state_freq2<-merge(x=state_freq,y=state_size_df,by.x="x",by.y="Abbrev")
#calculate VS hospital per thousand SqMiles
state_freq2$hospital_per_sq_miles<-state_freq2$freq/(state_freq2$SqMiles/1000)
#str(state_freq2)

#2d ggplot 1-descending, 2-color by region, 3-legend
ggplot(state_freq2, aes(x=reorder(StateName,-hospital_per_sq_miles),y=hospital_per_sq_miles,fill=Region)) + 
  geom_bar(stat="identity") + 
  labs(title="Number of VA hospital per thousand Sq Miles by state",subtitle="",x="State",y="VS hospital per thousand Sq Miles",caption="") +
  theme(plot.title=element_text(hjust=0.5),axis.text.x = element_text(angle = 90, hjust = 1))

#2e 
#The Northeast region seems relatively high for VA medical centers per thousand square miles.
#The West region seems relatively low. 
#The prelimilary discovery shows that the Northeast region seems to have more VA hospital per sq miles.
#However, the calculation is done by the size of the state, some larger state may not have large population.
#So, we should consider to look into the population and density of each state.

?distinct
