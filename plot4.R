library(dplyr)
library(lubridate)

#Skip not needed columns with NULL type to save memory:
cClasses <- c("character", "character","numeric", NULL, rep("numeric",4))

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
pdat <- powerdata %>%
    mutate(Timestamp = parse_date_time(paste(Date, Time, " "), "dmYHMS")) %>%
    filter(Timestamp %within% int) %>%
    select(Timestamp, Global_active_power, Global_reactive_power,
           Voltage, Sub_metering_1:Sub_metering_3)


#save plot
png(filename = "plot4.png", width = 480, height = 480)

# Set up plottting environment with 2 cols, 2 rows
par(mfrow=c(2,2), mar=c(4,4,2,1))

plot(pdat$Timestamp, pdat$Global_active_power,
     ylab="Global Active Power", xlab="", type="n")
lines(pdat$Timestamp, pdat$Global_active_power)

plot(pdat$Timestamp, pdat$Voltage,
     ylab="Voltage", xlab="datetime", type="n")
lines(pdat$Timestamp, pdat$Voltage)

plot(pdat$Timestamp, pdat$Sub_metering_1,
     xlab="", ylab = "Energy sub metering",
     type="n")
lines(pdat$Timestamp, pdat$Sub_metering_1, col="black")
lines(pdat$Timestamp, pdat$Sub_metering_2, col="red")
lines(pdat$Timestamp, pdat$Sub_metering_3, col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col=c("black", "red", "blue"), lty = c(1,1,1), bty = "n")

plot(pdat$Timestamp, pdat$Global_reactive_power,
     xlab="datetime", ylab="Global_reactive_power", type="n")
lines(pdat$Timestamp, pdat$Global_reactive_power)
dev.off()
