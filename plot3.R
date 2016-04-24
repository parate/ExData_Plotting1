library(dplyr)
library(lubridate)

#Skip not needed columns with NULL type to save memory:
cClasses <- c("character", "character",rep("NULL",4), rep("numeric",3))

#construct interval to filter out the rows of interest
start <- ymd_hms("2007-02-01 00:00:00")
end <- ymd_hms("2007-02-02 23:59:59")
int <- interval(start,end)

#Place household_power_consumption.txt in a folder named data for this to work:
powerdata <- read.table("./data/household_power_consumption.txt",
                        sep = ";",
                        header = TRUE,
                        na.strings = "?",
                        colClasses = cClasses, skipNul = TRUE)

#prepare data for plotting
sub_m <- powerdata %>%
    mutate(Timestamp = parse_date_time(paste(Date, Time, " "), "dmYHMS")) %>%
    filter(Timestamp %within% int) %>%
    select(Timestamp, Sub_metering_1:Sub_metering_3)

#save plot
png(filename = "plot3.png", width = 480, height = 480)
plot(sub_m$Timestamp, sub_m$Sub_metering_1,
     xlab="", ylab = "Energy sub metering",
     type="n")
lines(sub_m$Timestamp, sub_m$Sub_metering_1, col="black")
lines(sub_m$Timestamp, sub_m$Sub_metering_2, col="red")
lines(sub_m$Timestamp, sub_m$Sub_metering_3, col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col=c("black", "red", "blue"), lty = c(1,1,1))
dev.off()
