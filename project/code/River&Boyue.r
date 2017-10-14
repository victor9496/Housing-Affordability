#River He(25157135) & Boyue Sun(25852807)
#Housing Price and Education

#_________________________________________________________________________________

#set working directories
setwd("../code")

#housing price data
house = read.csv("../rawdata/house.csv",header = TRUE)

#CA school  data
California = read.delim("../rawdata/pubschils.csv", header = TRUE)

Alabama = read.csv("../rawdata/AlabamaSchoolListing.csv",header=TRUE)


#Alabama part
Clear_AL = subset(house, State == "AL")

# clear levels
Clear_AL = within(Clear_AL,{
  RegionName = droplevels(RegionName)
})

# get average price of house
Mean = c()
for (i in 1:nrow(Clear_AL)) {
  Mean = c(Mean,mean(as.numeric(Clear_AL[i,8:242]),na.rm = T))
}

# clear empty
sch = subset(Alabama, County != "",select = County)

# clear useless contens
sch = within(sch,{
  County = na.omit(droplevels(County))
})

#classify schools based on counties
sch_num = data.frame(table(sch$County))
colnames(sch_num) = c("RegionName","Num")
sch_num

New_merged_Al = merge(Clear_AL,sch_num)

#export images
# use the prices in oct 2015 to plot (linear model)
png("../images/house_Al.png")
plot(
  New_merged_Al[,242] ~ New_merged_Al[,243],
  main = "Price of 2015.10 VS Number of Schools",
  xlab = "Schools",ylab = "Price",pch = 11, cex = 1.1, col = "#33BB79"
)
dev.off()

pdf("../images/house_Al.pdf")
plot(
  New_merged_Al[,242] ~ New_merged_Al[,243],
  main = "Price of 2015.10 VS Number of Schools",
  xlab = "Schools",ylab = "Price",pch = 11, cex = 1.1, col = "#33BB79"
)
dev.off()
cor(New_merged_Al[,242],New_merged_Al[,243])

#There is a positive relationship between house price and school numbers in Alabama but the correlation is only 0.019 which is very small. We can ignore it.
#Also from this graph, we found the relationship is not linear,so we decided to use linear-log model.

#graphs use linear-log model
png("../images/house_logAl.png")
plot(
  New_merged_Al[,242] ~ log(New_merged_Al[,243]),
  main = "Price of 2015.10 VS log form of School numbers",
  xlab = "log of School #",ylab = "Price",pch = 13, cex = 1.2, col =
    "#2929DD"
)
dev.off()

pdf("../images/house_logAl.pdf")
plot(
  New_merged_Al[,242] ~ log(New_merged_Al[,243]),
  main = "Price of 2015.10 VS log form of School numbers",
  xlab = "log of School #",ylab = "Price",pch = 13, cex = 1.2, col =
    "#2929DD"
)
dev.off()

cor(New_merged_Al[,242],log(New_merged_Al[,243]))

#There is a positive relationship between house price and school numbers in Alabama and the correlation is only 0.3374 which is higher.

#California part
# get the house price in CA
CA = subset(house, State == "CA")

# clear levels
CA = within(CA,{
  RegionName = droplevels(RegionName)
})
# get all the data which situations are active
sch = subset(California, StatusType == "Active")

# clear levels
sch = within(sch,{
  County = droplevels(County)
})

#classify schools based on counties
sch_num = data.frame(table(sch$County))
colnames(sch_num) = c("RegionName","Num")
sch_num

#merge
Ca = merge(CA, sch_num)

write.csv(Ca, "../data/housing_school_CA.csv")

#export images
# use the prices in oct 2015 to plot (linear model)
png("../images/house_CA.png")
plot(
  Ca[,242] ~ Ca[,243],main = "Price of 2015.10 VS Number of Schools",
  xlab = "Schools",ylab = "Price",cex = 1,pch = 7,col = hsv(h = 0.9,s =
                                                              0.7,v = 0.8)
)
dev.off()

pdf("../images/house_CA.pdf")
plot(
  Ca[,242] ~ Ca[,243],main = "Price of 2015.10 VS Number of Schools",
  xlab = "Schools",ylab = "Price",cex = 1,pch = 7,col = hsv(h = 0.9,s =
                                                              0.7,v = 0.8)
)
dev.off()

#graph
plot(
  Ca[,242] ~ Ca[,243],main = "Price of 2015.10 VS Number of Schools",
  xlab = "Schools",ylab = "Price",cex = 1,pch = 7,col = hsv(h = 0.9,s =
                                                              0.7,v = 0.8)
)
cor(Ca[,242],Ca[,243])
#There is a positive relationship between house price and school numbers in California



#export images
#graphs use linear-log model
pdf("../images/house_CA_log.pdf")
plot(
  Ca[,242] ~ log(Ca[,243]),
  main = "Price of 2015.10 VS log form of School numbers",
  xlab = "log of School #",ylab = "Price",
  cex = 1,pch = 9 ,col = hsv(h = 0.5,s = 0.5,v = 0.5)
)
dev.off()

png("../images/house_CA_log.png")
plot(
  Ca[,242] ~ log(Ca[,243]),
  main = "Price of 2015.10 VS log form of School numbers",
  xlab = "log of School #",ylab = "Price",
  cex = 1,pch = 9 ,col = hsv(h = 0.5,s = 0.5,v = 0.5)
)
dev.off()

#graph
plot(
  Ca[,242] ~ log(Ca[,243]),
  main = "Price of 2015.10 VS log form of School numbers",
  xlab = "log of School #",ylab = "Price",
  cex = 1,pch = 9 ,col = hsv(h = 0.5,s = 0.5,v = 0.5)
)
cor(Ca[,242],log(Ca[,243]))
#There is a positive relationship between house price and log of school numbers in California
