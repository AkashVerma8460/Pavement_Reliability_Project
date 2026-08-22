# ============================================================
# SYNTHETIC COMMERCIAL TRAFFIC DATASET
# Two-Lane Two-Way Flexible Pavement
# Historical Period: 1976-2025
#
# IMPORTANT:
# This is SYNTHETIC data.
# It is NOT actual historical traffic data.
#
# IRC:37-2018 provisions are used for:
# - Two-lane two-way road
# - LDF = 0.50
# - Indicative VDF categories
# - 20-year design period
# - 5% minimum traffic-growth consideration
#
# Vehicle-category proportions and historical CVPD are
# synthetic modelling assumptions.
# ============================================================


# ------------------------------------------------------------
# 1. RANDOM SEED
# ------------------------------------------------------------

set.seed(456)


# ------------------------------------------------------------
# 2. SAVE LOCATION
# ------------------------------------------------------------

save_folder <- "E:/Pavement_Reliability_Project/_Raw_Data"

if (!dir.exists(save_folder)) {
  dir.create(
    save_folder,
    recursive = TRUE
  )
}

output_file <- file.path(
  save_folder,
  "Traffic_raw_synthetic.csv"
)


# ------------------------------------------------------------
# 3. TRUNCATED NORMAL FUNCTION
# ------------------------------------------------------------

rtruncnorm_base <- function(
    n,
    mean,
    sd,
    lower,
    upper
) {
  
  result <- numeric(0)
  
  while (length(result) < n) {
    
    x <- rnorm(
      n * 2,
      mean = mean,
      sd = sd
    )
    
    x <- x[
      x >= lower &
        x <= upper
    ]
    
    result <- c(
      result,
      x
    )
  }
  
  result[1:n]
}


# ------------------------------------------------------------
# 4. YEARS
# 1976-2025 = 50 observations
# ------------------------------------------------------------

Year <- 1976:2025

n_years <- length(Year)


# ------------------------------------------------------------
# 5. SYNTHETIC ANNUAL TRAFFIC GROWTH
#
# IRC:37-2018:
# 5% is the minimum growth rate adopted when the estimated
# growth is below 5% / adequate growth information is not
# available.
#
# For this synthetic dataset:
# 5.0% to 5.5% is used ONLY as a modelling assumption
# to introduce realistic year-to-year variability.
#
# It is NOT an IRC-prescribed growth-rate distribution.
# ------------------------------------------------------------

Growth_Rate <- rtruncnorm_base(
  n = n_years,
  mean = 0.0525,
  sd = 0.0015,
  lower = 0.05,
  upper = 0.055
)


# ------------------------------------------------------------
# 6. GENERATE TOTAL CVPD
#
# Synthetic initial two-way commercial traffic:
#
# 1976 = 250 CVPD
#
# This is NOT claimed to be actual 1976 Indian traffic.
# It is a synthetic baseline selected for the model.
# ------------------------------------------------------------

Total_CVPD <- numeric(
  n_years
)

Total_CVPD[1] <- 250


# Apply annual growth

for (i in 2:n_years) {
  
  Total_CVPD[i] <-
    Total_CVPD[i - 1] *
    (1 + Growth_Rate[i])
}


# Round to whole vehicles/day

Total_CVPD <- round(
  Total_CVPD,
  0
)


# ------------------------------------------------------------
# 7. GENERATE COMMERCIAL VEHICLE SHARES
#
# These are SYNTHETIC assumptions.
# They are NOT vehicle-class proportions prescribed by IRC.
#
# Approximate average composition:
#
# LCV          = ~25%
# Bus          = ~10%
# 2-Axle Truck = ~25%
# 3-Axle Truck = ~20%
# MAV          = ~20%
#
# Small year-to-year variation is introduced.
# ------------------------------------------------------------

LCV_share <- runif(
  n_years,
  min = 0.22,
  max = 0.28
)

Bus_share <- runif(
  n_years,
  min = 0.08,
  max = 0.12
)

Truck_2Axle_share <- runif(
  n_years,
  min = 0.22,
  max = 0.28
)

Truck_3Axle_share <- runif(
  n_years,
  min = 0.17,
  max = 0.23
)

MAV_share <- runif(
  n_years,
  min = 0.17,
  max = 0.23
)


# ------------------------------------------------------------
# 8. NORMALIZE VEHICLE SHARES
#
# Ensures all shares add exactly to 1.00
# ------------------------------------------------------------

share_total <-
  LCV_share +
  Bus_share +
  Truck_2Axle_share +
  Truck_3Axle_share +
  MAV_share


LCV_share <-
  LCV_share /
  share_total


Bus_share <-
  Bus_share /
  share_total


Truck_2Axle_share <-
  Truck_2Axle_share /
  share_total


Truck_3Axle_share <-
  Truck_3Axle_share /
  share_total


MAV_share <-
  MAV_share /
  share_total


# ------------------------------------------------------------
# 9. CALCULATE VEHICLE COUNTS
# ------------------------------------------------------------

LCV <- round(
  Total_CVPD *
    LCV_share
)

Bus <- round(
  Total_CVPD *
    Bus_share
)

Truck_2Axle <- round(
  Total_CVPD *
    Truck_2Axle_share
)

Truck_3Axle <- round(
  Total_CVPD *
    Truck_3Axle_share
)


# ------------------------------------------------------------
# 10. CALCULATE MAV AS REMAINDER
#
# This guarantees:
#
# LCV + Bus + Truck_2Axle + Truck_3Axle + MAV = CVPD
# ------------------------------------------------------------

MAV <-
  Total_CVPD -
  LCV -
  Bus -
  Truck_2Axle -
  Truck_3Axle


# ------------------------------------------------------------
# 11. CALCULATE CVPD FROM VEHICLE CATEGORIES
# ------------------------------------------------------------

CVPD <-
  LCV +
  Bus +
  Truck_2Axle +
  Truck_3Axle +
  MAV


# ------------------------------------------------------------
# 12. TERRAIN
# ------------------------------------------------------------

Terrain <- rep(
  "Plain/Rolling",
  n_years
)


# ------------------------------------------------------------
# 13. ASSIGN INDICATIVE VDF
#
# For Plain/Rolling terrain:
#
# 0-150 CVPD        -> VDF = 1.7
# >150-1500 CVPD   -> VDF = 3.9
# >1500 CVPD       -> VDF = 5.0
#
# VDF is assigned automatically from CVPD.
# ------------------------------------------------------------

VDF <- ifelse(
  
  CVPD <= 150,
  
  1.7,
  
  ifelse(
    CVPD <= 1500,
    3.9,
    5.0
  )
)


# ------------------------------------------------------------
# 14. LATERAL DISTRIBUTION FACTOR
#
# Two-lane two-way road:
#
# LDF = 0.50
# ------------------------------------------------------------

LDF <- rep(
  0.50,
  n_years
)


# ------------------------------------------------------------
# 15. DESIGN PERIOD
#
# Selected road category:
# NH / SH / Urban-road type
#
# Design period = 20 years
# ------------------------------------------------------------

Design_Period_Years <- rep(
  20,
  n_years
)


# ------------------------------------------------------------
# 16. ROAD TYPE
# ------------------------------------------------------------

Road_Type <- rep(
  "Two-lane Two-way",
  n_years
)


# ------------------------------------------------------------
# 17. CREATE FINAL DATASET
# ------------------------------------------------------------

traffic_data <- data.frame(
  
  Year = Year,
  
  LCV = LCV,
  
  Bus = Bus,
  
  Truck_2Axle = Truck_2Axle,
  
  Truck_3Axle = Truck_3Axle,
  
  MAV = MAV,
  
  CVPD = CVPD,
  
  Growth_Rate_percent =
    round(
      Growth_Rate * 100,
      2
    ),
  
  VDF = VDF,
  
  LDF = LDF,
  
  Terrain = Terrain,
  
  Road_Type = Road_Type,
  
  Design_Period_Years =
    Design_Period_Years
)


# ------------------------------------------------------------
# 18. CHECK THAT VEHICLE COUNTS = CVPD
# ------------------------------------------------------------

calculated_cvpd <-
  traffic_data$LCV +
  traffic_data$Bus +
  traffic_data$Truck_2Axle +
  traffic_data$Truck_3Axle +
  traffic_data$MAV


CVPD_Check <-
  calculated_cvpd ==
  traffic_data$CVPD


cat("\n========================================\n")
cat("CVPD CHECK\n")
cat("========================================\n")


if (all(CVPD_Check)) {
  
  cat(
    "PASSED: All vehicle categories add exactly to CVPD.\n"
  )
  
} else {
  
  cat(
    "FAILED: CVPD calculation error detected.\n"
  )
}


# ------------------------------------------------------------
# 19. CHECK YEAR RANGE
# ------------------------------------------------------------

cat("\n===== YEAR RANGE =====\n")

print(
  range(
    traffic_data$Year
  )
)


# ------------------------------------------------------------
# 20. CHECK NUMBER OF OBSERVATIONS
# ------------------------------------------------------------

cat("\n===== NUMBER OF OBSERVATIONS =====\n")

cat(
  nrow(traffic_data),
  "\n"
)


# ------------------------------------------------------------
# 21. CHECK CVPD RANGE
# ------------------------------------------------------------

cat("\n===== CVPD RANGE =====\n")

print(
  range(
    traffic_data$CVPD
  )
)


# ------------------------------------------------------------
# 22. CHECK GROWTH RATE
# ------------------------------------------------------------

cat("\n===== GROWTH RATE RANGE =====\n")

print(
  range(
    traffic_data$Growth_Rate_percent
  )
)


# ------------------------------------------------------------
# 23. CHECK VDF VALUES
# ------------------------------------------------------------

cat("\n===== VDF VALUES =====\n")

print(
  unique(
    traffic_data$VDF
  )
)


# ------------------------------------------------------------
# 24. CHECK LDF
# ------------------------------------------------------------

cat("\n===== LDF VALUES =====\n")

print(
  unique(
    traffic_data$LDF
  )
)


# ------------------------------------------------------------
# 25. CHECK DESIGN PERIOD
# ------------------------------------------------------------

cat("\n===== DESIGN PERIOD =====\n")

print(
  unique(
    traffic_data$Design_Period_Years
  )
)


# ------------------------------------------------------------
# 26. CHECK MISSING VALUES
# ------------------------------------------------------------

cat("\n===== MISSING VALUES =====\n")

print(
  colSums(
    is.na(
      traffic_data
    )
  )
)


# ------------------------------------------------------------
# 27. CHECK DUPLICATE YEARS
# ------------------------------------------------------------

cat("\n===== DUPLICATE YEARS =====\n")

cat(
  "Number of duplicate years:",
  sum(
    duplicated(
      traffic_data$Year
    )
  ),
  "\n"
)


# ------------------------------------------------------------
# 28. DISPLAY FIRST 10 ROWS
# ------------------------------------------------------------

cat("\n===== FIRST 10 ROWS =====\n")

print(
  head(
    traffic_data,
    10
  )
)


# ------------------------------------------------------------
# 29. DISPLAY LAST 10 ROWS
# ------------------------------------------------------------

cat("\n===== LAST 10 ROWS =====\n")

print(
  tail(
    traffic_data,
    10
  )
)


# ------------------------------------------------------------
# 30. SAVE DATASET
# ------------------------------------------------------------

write.csv(
  traffic_data,
  output_file,
  row.names = FALSE
)


# ------------------------------------------------------------
# 31. CONFIRM SAVE LOCATION
# ------------------------------------------------------------

cat("\n========================================\n")
cat("TRAFFIC DATASET SUCCESSFULLY SAVED\n")
cat("File location:\n")
cat(output_file)
cat("\n========================================\n")