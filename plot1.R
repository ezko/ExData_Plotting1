  # verify lubridate exists
  if (!library(lubridate,logical.return=TRUE)) {
    stop("Failed to load lubridate package")     
  }

  # speed up loading by evaluating the colClasses
  tab10rows <- read.csv("household_power.txt", header = TRUE, nrows = 10,sep = ";",na.strings = "?") 
  classes <- sapply(tab10rows, class) 
  
  # read up to first days of feburary
  tabAll <- read.csv("household_power.txt", header = TRUE, colClasses = classes , nrows = 70000,sep = ";",na.strings = "?")
  
  # make one col with date and time
  tabAll$DateTime <- paste(tabAll$Date,tabAll$Time)
  
  # use lubridate to parse date and time
  tabAll$DateTime <- dmy_hms(tabAll$DateTime)
  
  # extract first 2 days of feburary
  tabSub <- tabAll[tabAll$DateTime >= ymd("2007-02-01") & tabAll$DateTime < ymd("2007-02-03") ,]

  # make histogram of Global Active Power
  with(tabSub,hist(Global_active_power,main="Global Active Power" ,col = "red", xlab="Global Active Power (kilowatts)"))
  
  ## Copy my plot to a PNG file
  dev.copy(png, file = "plot1.png",width = 480, height = 480)
  
  ## Don't forget to close the PNG device!
  dev.off()