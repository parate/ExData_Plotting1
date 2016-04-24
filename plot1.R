library(dplyr)
library(lubridate)

#Skip not needed columns with NULL type to save memory:
cClasses <- c("character", "character","numeric", rep("NULL", times=6))

#construct interval to filter out the rows of interest
start <- ymd_hms("2007-02-01 00:00:00")
end <- ymd_hms("2007-02-02 23:59:59")
int <- interval(start,end)

#Place household_power_consumption.txt in a folder named data for this to work:
powerdata <- read.table("./data/household_power_consumption.txt",
                        sep = ";",
                        header = TRUE,
                        na.strings = "?",
                        colClasses = cClasses)

#prepare data for plotting
gap <- powerdata %>%
    mutate(Timestamp = parse_date_time(paste(Date, Time, " "), "dmYHMS")) %>%
    filter(Timestamp %within% int) %>%
    filter(!is.na(Global_active_power)) %>%
    select(Timestamp, Global_active_power)

png(filename = "plot1.png", width = 480, height = 480)
hist(gap$Global_active_power,
     col="red", xlab="Global Active Power (kilowatts)",
     main = "Global Active Power")
dev.off()
