  # verify lubridate exists
  if (!library(lubridate,logical.return=TRUE)) {
    stop("Failed to load lubridate package")     
  }
  
  Sys.setlocale(category = "LC_TIME", locale = "english")
  
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
  
  # make plot
  with(tabSub,plot(DateTime,Sub_metering_1,main="" ,col="black" ,type = "l", ylab="Energy Sub Metering"))
  with (tabSub,lines(DateTime,Sub_metering_2,col="red"))
  with (tabSub,lines(DateTime,Sub_metering_3,col="blue"))
  
  # legend
  legend("topright", lwd=1, col = c("black", "red" , "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  
  # Copy my plot to a PNG file
  dev.copy(png, file = "plot3.png",width = 480, height = 480)
  
  # Don't forget to close the PNG device!
  dev.off()