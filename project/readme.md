# Average Home Purchasing Price Analysis

Our project is about average housing purchasing price analysis. It consists of three parts. The first part is about housing affordability in 51 states of United States. The second part is the relationship between hous
ing prices and number of schools in California's counties. The third part is the relationship between SP500 and housing prices in San Francisco, and focus on analyzing the relationship in 2001 .

Our project uses 5 different data sets.   
County_Zhvi_AllHomes.csv ( named as “house” in our project)    
includes  housing prices of each US county from 1996 to 2015.   
        from "www.zillow.com/research" (note: three parts all use this data set)

  - _part1_：__Housing Affordbility__  (_Lianghui Li_)  
  ho3AR.csv ( named as “income” in our project) shows mean household income received by Each fifth and and Top 5 percent, all races from 1967 to 2013. (from  "census.gov")  
Mortgage_Rate_30_year_(Recent History) (named as “interest” in our project ) lists the mortgage rate in the United States from 1971 to 2015. (from "data360.org")

  - _part2_: __Relationship between Housing Price and Education__  
(_River He & Boyue Sun_)  
pubschils.csv ( named as “California” in our project) presents the number of schools in each county of california. (from "ftp.cde.ca.gov")
AlabamaSchoolisting.csv (named as "Alabama" in our project) presents the number of schools in each county of Alabama. (from "web.alsde.edu")
_collecting data from "ftp.cde.ca.gov" and "web.alsde.edu" 
However, when we first downloaded the data from "web.alsde.edu",we could use
it, but somehow the website link has some problems when we use downloadfile     command.So we just put AlabamaSchoolListing.csv in our raw data folder_
  
  - _part3_: __Housing Price and Stock Market__  (_Zhongshu Wang_)     
 stock_price_url (named as “stock” in our project) shows the SP500 index from 1980 to 2015. (from"finance.yahoo.com")
 
### Organization of directories

The contents of our project can be listed as follow

* Code - contains code for data cleaning and analysis for all three parts
* Rawdata - includes all the data files directly downloaded from the Internet(before cleaning)
* Data - cleaned data files
* Resources - downloaded references used in our project
* Report - final research report in _pdf_, _rmd_ format
* Images - all the created graphs from our __code__
* README.md - general information about our project
* Skeleton.R - __R__ script with commands to create subdirectories and  download the raw data files 