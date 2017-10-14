#resources_download command

#----------------------------------------------------------------------------------
#Housing_index_formula
download.file(
  "http://www.realtor.org/topics/housing-affordability-index/methodology",
  destfile = "./resources/index_formula.html"
)

#CPI_calculator
download.file(
  paste0(
    "http://www.usinflationcalculator.com/inflation/consumer-price-index",
    "-and-annual-percent-changes-from-1913-to-2008/"),
  destfile = "./resources/CPI_calculator.html"
)
