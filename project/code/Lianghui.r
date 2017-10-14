#author: Lianghui Li(25180845)
#topic: Housing Affordability

#_________________________________________________________________________________
#Data cleanning

#using "gdata" package
library(gdata)

#set working directories
setwd("../code")


#import data
house = read.csv("../rawdata/house.csv")
interest = read.csv("../rawdata/interest.csv", stringsAsFactors = F)

#skip 4 lines because the first four lines are introduction
income_raw = read.xls("../rawdata/income.xls", skip = 4, stringsAsFactors = F)

#data cleaning for interest rate data
interest$year =
  substr(interest$Date, nchar(interest$Date) - 3, nchar(interest$Date))

#change the rate to numeric format then change from % to decimal
interest$Mortgage.Rate.30.Year.Conventional = as.numeric(
  substr(interest$Mortgage.Rate.30.Year.Conventional, 1, 4)) / 100

#combine the monthly data in to yearly, using average for month sum get the mean
# rate of year
interest_raw =
  aggregate.data.frame(interest$Mortgage.Rate.30.Year.Conventional,
                       by = list(interest$year), mean)

#finding the our data starting position(year 1996) and ending position(year 2013)
start_1996 = grep('1996',interest_raw$Group.1)
end_2013 = grep('2013', interest_raw$Group.1)

#subset the data frame that we are interested in
interest_rate = interest_raw$x[start_1996:end_2013]
interest_clean = data.frame(Year = 1996:2013,
                            interest_rate = interest_rate)

write.csv(interest_clean, file = '../data/interest_clean.csv', row.names = F)


#we are trying to find the income data, whose base year is 2013(ie, every income
#distribution data is converting to the income value in 2013)
#subset the starting and ending row of our interested data(2013 base year income)

start_income =
  grep('2013 dollar', income_raw$Year, ignore.case = T) + 2
end_icome = grep('source', income_raw$Year, ignore.case = T) - 1
income_2013 = income_raw[start_income:end_icome,]

#need to subset again only for the income between 1996 and 2013
start_income = grep('1996',income_2013$Year)
end_income = grep('2013',income_2013$Year)
income_clean = income_2013[start_income:end_income,]

#create a year column
income_clean$Year = substr(income_clean$Year, 1, 4)

#change "," into numeric form
income_clean = as.data.frame(apply(income_clean, 2, function(y)
  as.numeric(gsub(",", "", y))))

#source from "CPI_calculator.html" from resources data
#change income value(ie, instead of using income value of base year "2013",
#using CPI value for each value divided by the CPI value in year "2013"
#we would get the income value for each year, not the base year value)
inflation_rate =
  c(
    156.9, 160.5, 163.0, 166.6, 172.2, 177.1, 179.9, 184.0, 188.9,
    195.3, 201.6, 207.3, 215.303, 214.537, 218.056, 224.939, 229.594,
    232.957
  ) / 232.957
for (i in 1:nrow(income_clean)) {
  income_clean[i, 2:7] = income_clean[i, 2:7] * inflation_rate[i]
}

write.csv(income_clean, file = '../data/income_clean.csv', row.names = F)


#after inspecting the data frame, we know that "regionID", "region name", "metro"
#"statecodefips", "municipalcodefips", "sizerank" are not our focus in this analysis
#so we delete them
house_new = house[,-c(1:2, 4:7)]

#create a new data frame aggregate all the number by their state name(our focus)
#using their mean
house_mid = aggregate.data.frame(house_new[2:ncol(house_new)],
                                 by = list(house_new$State), mean, na.rm = T)

#again, we focus on the year between 1996 and 2013, so subset out year 2014 and 2015
house_mid =
  house_mid[,-c(min(grep('2014', colnames(house_mid))):ncol(house_mid))]

#inspecting again, for the state "ND" in row29, it has miss value for more than
#7 years, so I think it is advisirable to let it out in order not to bias our
#analysis
house_mid = house_mid[-29,]

#find the starting and ending position for each year
#and add them on the lise using their corresponding year names
year_list = list()
for (i in 1:(2013 - 1996 + 1)) {
  year_list[[i]] =
    c(min(grep(paste0(1995 + i), colnames(house_mid))),
      max(grep(paste0(1995 + i), colnames(house_mid))))
}
names(year_list) = c(paste0(1996:2013))



#create a function calculate the average house median value for each state
#in each year
#I delibreately leave out the average value for partial year(ie, some states have
#some missing value in some year ex. state "AK", have value from september to
#december) but not for the whole year(no missing value for all 12 months)
#since there is potential biased involved (sensality is associated with 
#housing price)in that case, I put NA for that specific year for specific state

year_average = function(state, year) {
  year_location = year_list[paste0(year)]
  min_location = year_location[[1]][1]
  max_location = year_location[[1]][2]
  state_id = which(house_mid$Group.1 == paste0(state))
  average =
    sum(house_mid[state_id, min_location:max_location]) / 
    (max_location - min_location + 1)
  if (is.nan(average))
    return(NA)
  return(unname(average))
}

#checking the average median housing price of state "AK" in 1999
year_average("AK", 1999)

#create a new data frame house_clean with the averge price for
#all states in the year between 1996 and 2013
house_clean = data.frame()
for (i in 1996:2013) {
  for (j in 1:nrow(house_mid)) {
    house_clean[i - 1995, j] = year_average(house_mid$Group.1[j], i)
  }
}
#create a new "year" column and put it as our first column
house_clean$year = c(1996:2013)
colnames(house_clean) = c(levels(house_mid$Group.1)[-29], "Year")
house_clean = house_clean[,c(50, 1:49)]

#export the new clean data
write.csv(house_clean, file = '../data/house_clean.csv', row.names = F)

#_________________________________________________________________________________


#Data Analysis

#using packages
library(reshape2)
library(ggplot2)
library(grid)

#sort the average price over the years for each state in increasing order
sort(colMeans(house_clean)[-1])

#compare the price trend of minimum average price ("WV") and
#maximum average price ("HI")
time_trend <- {
  ggplot(house_clean, aes(Year)) +
    geom_line(aes(y = HI, color = "HI")) +
    geom_point(aes(y = HI, color = "HI")) +
    geom_line(aes(y = WV, color = "WV")) +
    geom_point(aes(y = WV, color = "WV")) +
    labs(y = "housing price", 
         title = "Highest and lowest housing price in the states") +
    theme(
      legend.position = "top", legend.direction = "horizontal",
      legend.title = element_blank()
    )
}

#export "time_trend" image
time_trend
png("../images/time_trend.png")
time_trend
dev.off()

pdf("../images/time_trend.pdf")
time_trend
dev.off()


#create function for calculating qualifying income for specific state
#in specific year
qualify_income <- function(state, year) {
  median_price <-
    house_clean[year - 1995, which(colnames(house_clean) == paste0(state))]
  #if there is missing value when calculating the housing price and
  #the specified year is not within 1996 to 2013, the function will stop
  if (year < 1996 | year > 2013 | is.na(median_price)) {
    print("No sufficient data support")
  } else {
    interest_rate <- interest_clean$interest_rate[year - 1995]
    #using the formula given in "index_formula" in resources folder
    payment <-
      median_price * 0.8 * ((interest_rate / 12) / (1 - (1 / (
        1 + interest_rate / 12) ^ 360)))
    qualify_income <- payment * 4 * 12
    return(qualify_income)
  }
}

qualify_income('AK', 1999)

#create function calculating housing index(affordbility)
#using the info from "index_formula" in resources folder
#giving the year default value "2008"

housing_index <- function(income, state, year = 2008) {
  qualify <- qualify_income(state, year)
  index <- income / qualify
  return(index)
}

#less than 1 means you can not afford this housing price
#more than 1 means you can afford this housing price
housing_index(64930, "AL", 2008)


#function that explore the overall affordbility for American in
#specific year in specific state
housing_affordability <- function(state, year) {
  #subset in the income distribution for specified year
  #minus 1995 because of the corrsponding row id
  income <- income_clean[year - 1995, 2:7]
  i <- 1
  index <- housing_index(income[1], state, year)
  #using while loop to find at least (until) how many american can afford
  #this price(ie, the housing index is greater than one)
  while (index < 1) {
    index <- housing_index(income[i], state, year)
    i <- i + 1
  }
  i <- as.character(i)
  switch(
    i,
    '1' = 'More than 80% American can afford',
    '2' = 'More than 60% American can afford',
    '3' = 'About 40% American can afford',
    '4' = 'Less than 40% American can afford',
    '5' = 'Less than 20% American can afford',
    '6' = 'Only 5 % American can afford'
  )
}
#check overall American affordbility for the housing price in "OK" in 1999
housing_affordability('OK', 1999)

#_________________________________________________________________________________
#General Affordability in 2008

#subset corrsponding info in the year 2008
#"13" is the row id corrsponding to 2008
income_2008 <- income_clean[13,-1]
house_2008 <- house_clean[13,-1]
interest_rate_2008 <- interest_clean$interest_rate[13]

#data frame that include all the necessary info in the year 2008
#using the same method above calculating the housing method
df_2008 <- data.frame()
for (j in 1:49) {
  for (i in 1:6) {
    pay <-
      house_2008[j] * 0.8 * ((interest_rate_2008 / 12) / (1 - (1 / (
        1 + interest_rate_2008 / 12
      ) ^ 360)))
    df_2008[j, i] <- income_2008[i] / (pay * 48)
  }
}


#name the cloumn expcet the first one (year is not necessary
#since we are interested only in 2008)
df_2008$states <- colnames(house_clean)[-1]


#change the data frame from short formate to long formate
housing_2008 <- melt(df_2008)

#bar plot that show affordbility for each income distribution in the year 2008
#for each state
housing_index_graph <-
{
  ggplot(housing_2008, aes(states, value, fill = variable)) +
    geom_bar(stat = "identity") +
    labs(y = "housing index", title = "Housing index for each states in 2008") +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 90, hjust = 1),
          axis.text = element_text(size = 7)) +
    guides(fill = guide_legend(title = "Income distribution")) +
    scale_y_discrete(breaks = c(seq(2, 8, 2), seq(10, 40, 10)))
}

#inspect the graph
housing_index_graph

#export images
png("../images/housing_index.png")
housing_index_graph
dev.off()

pdf("../images/housing_index.pdf")
housing_index_graph
dev.off()

