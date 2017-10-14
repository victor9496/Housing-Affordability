#create subdierctories
dir.create("rawdata")
dir.create("code")
dir.create("data")
dir.create("resources")
dir.create("resport")
dir.create("images")

#download data

#____________________________________________________________________________________
#interest rate data
download.file("http://www.data360.org/export.aspx?Data_Set_Group_Id=245",
              destfile = "./rawdata/interest.csv")

#income distribution data
download.file(
  "https://www.census.gov/hhes/www/income/data/historical/household/2013/h03AR.xls",
  destfile = "./rawdata/income.xls"
)

#housing price data
download.file(
  "http://files.zillowstatic.com/research/public/County/County_Zhvi_AllHomes.csv",
  destfile = "./rawdata/house.csv"
)

#CA school  data
download.file("ftp.cde.ca.gov/demo/schlname/pubschls.txt",
              destfile = "./rawdata/pubschils.csv")

#download s&p500 historical data from preselecting yahoo finance form
stock_price_url = paste0(
  "http://real-chart.finance.yahoo.com/table.csv?s=%5EG",
  "SPC&a=00&b=3&c=1980&d=10&e=18&f=2015&g=m&ignore=.csv"
)

download.file(stock_price_url,destfile = "./rawdata/stock.csv")
