#author: Zhongshu Wang (25320903)
#topic: Housing Price and Stock Market

#_________________________________________________________________________________
#Data Cleaning

library(ggplot2)

#set working directories
setwd("../code")

housing_price = read.csv("../rawdata/house.csv") #load housing price information

stock_price = read.csv("../rawdata/stock.csv")

colnames(housing_price) #check duration of time
#housing data starts from 1996/4 till 2015/10
head(stock_price) #check the latest record of s&p500
tail(stock_price) #check the earliest record of s&p500

#gather ONLY the housing price information of certain county
get_price = function(county_name) {
  as.numeric(housing_price[housing_price$RegionName == county_name,
                           8:ncol(housing_price)])
}
#observe change in housing price of San Francisco over time
sf_series = get_price("San Francisco")

#create a dataframe assoicate with indexs of s&p500 and housing price in a specific county
house_sp_index = function(county_name) {
  #create a month labels associate with the time period
  monthseq = paste(rep(1996:2015,each = 12),"/",1:12,sep = "")
  months = monthseq[4:(length(monthseq) - 2)]
  #gather s&p500 record ONLY associated with the housing price infromation we have
  sp_series = rev((stock_price[1:length(months),7] +
                     stock_price[2:(length(months) + 1),7]) / 2)
  house_series = get_price(county_name)
  #output as a dataframe
  data.frame(time = months,
             house = get_price(county_name),
             sp = sp_series)
}
#entire index of s&p500 and housing price in San Francisco
sf_index = house_sp_index("San Francisco")
write.csv(sf_index,file = "../data/sf_index.csv")

#create a dataframe assoicate with change rate of s&p500 and housing price in a specific county
house_sp_rate = function(county_name) {
  monthseq = paste(rep(1996:2015,each = 12),"/",1:12,sep = "")
  months = monthseq[4:(length(monthseq) - 2)]
  sp_series = rev((stock_price[1:length(months),7] +
                     stock_price[2:(length(months) + 1),7]) / 2)
  duration = length(months)
  house_series = get_price(county_name)
  #use record in adjacent months to create a new vector of the rate of change
  #on both house price and s&p500
  rate_house = (house_series[-1] - house_series[-duration]) / house_series[-duration]
  rate_sp = (sp_series[-1] - sp_series[-duration]) / sp_series[-duration]
  #output also a dataframe
  data.frame(time = months[-duration],
             house_rate = rate_house,
             sp_rate = rate_sp)
}
#entire change rate of s&p500 and housing price in San Francisco
sf_rate = house_sp_rate("San Francisco")
write.csv(sf_rate,file = "../data/sf_rate.csv")

#subset either index or change rate given specific time period
get_period = function(data_frame,start_month,end_month) {
  #information_type is either house_sp_rate or house_sp_index
  monthseq = paste(rep(1996:2015,each = 12),"/",1:12,sep = "")
  months = monthseq[4:(length(monthseq) - 2)]
  start = grep(start_month,months)#find the matching position
  end = grep(end_month,months)
  data_frame[start:end,]
}
#get information during the "Dot Com"  economic crisis during the year 2001
sf_rate2001 = get_period(house_sp_rate("San Francisco"),"2001/1","2001/12")
write.csv(sf_rate2001,file = "../data/sf_rate2001.csv")



#======================================================================
#Analysis
plot(
  1:nrow(sf_index),sf_index$house / 500, col = "#EE0000", 
  type = "l", lwd = 3,at =
    FALSE,xlab = "Months",ylab = "Price Index"
)
lines(
  1:nrow(sf_index),sf_index$sp, col = "#00EE00", lwd = 3,at = FALSE
)
axis(side = 1,at = seq(10,nrow(sf_index),by = 12),labels = FALSE)
axis(
  side = 2, at = seq(500,2300,by = 200),labels = seq(500,2300,by = 200),las =
    1
)
text(
  seq(10,nrow(sf_index),by = 12),par("usr")[3] - 0.06,cex = 0.8,
  labels = sf_index$time[seq(10,nrow(sf_index),by = 12)],
  srt = 45, pos = 1, xpd = TRUE
)
legend(
  "topleft",legend = c("Housing Price / 500","S&P 500"),
  col = c("#EE0000","#00EE00"),lty = c(1,1)
)
title("Price Comparison")

png("../images/sf_index_graph.png")
plot(
  1:nrow(sf_index),sf_index$house / 500, col = "#EE0000", 
  type = "l", lwd = 3,at =
    FALSE,xlab = "Months",ylab = "Price Index"
)
lines(
  1:nrow(sf_index),sf_index$sp, col = "#00EE00", lwd = 3,at = FALSE
)
axis(side = 1,at = seq(10,nrow(sf_index),by = 12),labels = FALSE)
axis(
  side = 2, at = seq(500,2300,by = 200),labels = seq(500,2300,by = 200),las =
    1
)
text(
  seq(10,nrow(sf_index),by = 12),par("usr")[3] - 0.06,cex = 0.8,
  labels = sf_index$time[seq(10,nrow(sf_index),by = 12)],
  srt = 45, pos = 1, xpd = TRUE
)
legend(
  "topleft",legend = c("Housing Price / 500","S&P 500"),
  col = c("#EE0000","#00EE00"),lty = c(1,1)
)
title("Price Comparison")
dev.off()

pdf("../images/sf_index_graph.pdf")
plot(
  1:nrow(sf_index),sf_index$house / 500, col = "#EE0000", 
  type = "l", lwd = 3,at =
    FALSE,xlab = "Months",ylab = "Price Index"
)
lines(
  1:nrow(sf_index),sf_index$sp, col = "#00EE00", lwd = 3,at = FALSE
)
axis(side = 1,at = seq(10,nrow(sf_index),by = 12),labels = FALSE)
axis(
  side = 2, at = seq(500,2300,by = 200),labels = seq(500,2300,by = 200),
  las =1
)
text(
  seq(10,nrow(sf_index),by = 12),par("usr")[3] - 0.06,cex = 0.8,
  labels = sf_index$time[seq(10,nrow(sf_index),by = 12)],
  srt = 45, pos = 1, xpd = TRUE
)
legend(
  "topleft",legend = c("Housing Price / 500","S&P 500"),
  col = c("#EE0000","#00EE00"),lty = c(1,1)
)
title("Price Comparison")
dev.off()

#get a ggplot comapring house and s&p500 on rate of change during economic crisis 2001
graph_sf_rate2001 = data.frame(
  month = rep(sf_rate2001$time,time = 2),
  rate = c(sf_rate2001$house_rate,sf_rate2001$sp_rate),
  type = rep(c("Housing Price","S&P 500"),each =
               nrow(sf_rate2001))
)

sf_rate2001_graph = {
  ggplot(graph_sf_rate2001, aes(month,rate)) +
    geom_line(aes(colour = type, group = type)) +
    geom_point(aes(colour = type, group = type)) +
    labs(title = "Rate of Change Comparison") +
    theme(axis.text.x = element_text(angle = 90, hjust = 1))
}

sf_rate2001_graph

png("../images/sf_rate2001_graph.png")
sf_rate2001_graph
dev.off()

pdf("../images/sf_rate2001_graph.pdf")
sf_rate2001_graph
dev.off()

cor(sf_rate2001$house_rate,sf_rate2001$sp_rate)
cor(sf_rate$house_rate,sf_rate$sp_rate)