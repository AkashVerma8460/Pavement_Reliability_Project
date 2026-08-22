# ============================================================
# TRAFFIC DATA CLEANING
# Two-Lane Two-Way Flexible Pavement
# ============================================================

# ------------------------------------------------------------
# 1. FILE LOCATIONS
# ------------------------------------------------------------

input_file <- "E:/Pavement_Reliability_Project/_Raw_Data/Traffic_raw_synthetic.csv"

output_folder <- "E:/Pavement_Reliability_Project/_Clean_Data"

if (!dir.exists(output_folder)) {
  dir.create(
    output_folder,
    recursive = TRUE
  )
}

output_file <- file.path(
  output_folder,
  "Traffic_clean.csv"
)


# ------------------------------------------------------------
# 2. IMPORT RAW DATA
# ------------------------------------------------------------

traffic_raw <- read.csv(
  input_file,
  stringsAsFactors = FALSE
)


# ------------------------------------------------------------
# 3. INITIAL DATA INSPECTION
# ------------------------------------------------------------

cat("\n========================================\n")
cat("RAW TRAFFIC DATA INSPECTION\n")
cat("========================================\n")

cat("\nNumber of rows and columns:\n")
print(dim(traffic_raw))

cat("\nColumn names:\n")
print(names(traffic_raw))

cat("\nData structure:\n")
str(traffic_raw)

cat("\nFirst 10 observations:\n")
print(head(traffic_raw, 10))


# ------------------------------------------------------------
# 4. CHECK MISSING VALUES
# ------------------------------------------------------------

cat("\n========================================\n")
cat("MISSING VALUE CHECK\n")
cat("========================================\n")

missing_values <- colSums(
  is.na(traffic_raw)
)

print(missing_values)


# ------------------------------------------------------------
# 5. CHECK DUPLICATE YEARS
# ------------------------------------------------------------

cat("\n========================================\n")
cat("DUPLICATE YEAR CHECK\n")
cat("========================================\n")

duplicate_years <- duplicated(
  traffic_raw$Year
)

cat(
  "Number of duplicate years:",
  sum(duplicate_years),
  "\n"
)

# Remove duplicate year records
traffic_clean <- traffic_raw[
  !duplicate_years,
]


# ------------------------------------------------------------
# 6. CONVERT NUMERIC COLUMNS
# ------------------------------------------------------------

numeric_columns <- c(
  "Year",
  "LCV",
  "Bus",
  "Truck_2Axle",
  "Truck_3Axle",
  "MAV",
  "CVPD",
  "Growth_Rate_percent",
  "VDF",
  "LDF",
  "Design_Period_Years"
)

for (column in numeric_columns) {
  
  traffic_clean[[column]] <- as.numeric(
    traffic_clean[[column]]
  )
}


# ------------------------------------------------------------
# 7. CHECK NEGATIVE OR ZERO TRAFFIC VALUES
# ------------------------------------------------------------

vehicle_columns <- c(
  "LCV",
  "Bus",
  "Truck_2Axle",
  "Truck_3Axle",
  "MAV",
  "CVPD"
)

cat("\n========================================\n")
cat("VEHICLE COUNT CHECK\n")
cat("========================================\n")

for (column in vehicle_columns) {
  
  invalid_values <- sum(
    traffic_clean[[column]] < 0 |
      is.na(traffic_clean[[column]])
  )
  
  cat(
    column,
    ":",
    invalid_values,
    "invalid observations\n"
  )
}


# ------------------------------------------------------------
# 8. CHECK VEHICLE CATEGORIES = CVPD
# ------------------------------------------------------------

calculated_cvpd <-
  traffic_clean$LCV +
  traffic_clean$Bus +
  traffic_clean$Truck_2Axle +
  traffic_clean$Truck_3Axle +
  traffic_clean$MAV

CVPD_difference <-
  traffic_clean$CVPD -
  calculated_cvpd

cat("\n========================================\n")
cat("CVPD CONSISTENCY CHECK\n")
cat("========================================\n")

cat(
  "Number of inconsistent CVPD records:",
  sum(CVPD_difference != 0),
  "\n"
)

# Recalculate CVPD from vehicle categories
# so that the cleaned dataset is internally consistent

traffic_clean$CVPD <- calculated_cvpd


# ------------------------------------------------------------
# 9. CHECK TRAFFIC GROWTH RATE
# ------------------------------------------------------------

cat("\n========================================\n")
cat("GROWTH RATE CHECK\n")
cat("========================================\n")

cat(
  "Minimum growth rate:",
  min(
    traffic_clean$Growth_Rate_percent,
    na.rm = TRUE
  ),
  "%\n"
)

cat(
  "Maximum growth rate:",
  max(
    traffic_clean$Growth_Rate_percent,
    na.rm = TRUE
  ),
  "%\n"
)

# Check values below 5%
growth_below_5 <- sum(
  traffic_clean$Growth_Rate_percent < 5
)

cat(
  "Growth rates below 5%:",
  growth_below_5,
  "\n"
)


# ------------------------------------------------------------
# 10. CHECK VDF
# ------------------------------------------------------------

cat("\n========================================\n")
cat("VDF CHECK\n")
cat("========================================\n")

# Expected VDF according to the selected
# plain/rolling terrain categories

expected_VDF <- ifelse(
  traffic_clean$CVPD <= 150,
  1.7,
  ifelse(
    traffic_clean$CVPD <= 1500,
    3.9,
    5.0
  )
)

VDF_difference <-
  traffic_clean$VDF -
  expected_VDF

cat(
  "VDF inconsistencies:",
  sum(VDF_difference != 0),
  "\n"
)

# Correct VDF according to the selected rule
traffic_clean$VDF <- expected_VDF


# ------------------------------------------------------------
# 11. CHECK LDF
# ------------------------------------------------------------

cat("\n========================================\n")
cat("LDF CHECK\n")
cat("========================================\n")

cat(
  "Unique LDF values:\n"
)

print(
  unique(
    traffic_clean$LDF
  )
)

# For two-lane two-way road
# retain LDF = 0.50

traffic_clean$LDF <- 0.50


# ------------------------------------------------------------
# 12. CHECK DESIGN PERIOD
# ------------------------------------------------------------

cat("\n========================================\n")
cat("DESIGN PERIOD CHECK\n")
cat("========================================\n")

print(
  unique(
    traffic_clean$Design_Period_Years
  )
)

# Selected project design period
traffic_clean$Design_Period_Years <- 20


# ------------------------------------------------------------
# 13. CHECK ROAD TYPE
# ------------------------------------------------------------

cat("\n========================================\n")
cat("ROAD TYPE CHECK\n")
cat("========================================\n")

print(
  unique(
    traffic_clean$Road_Type
  )
)


# ------------------------------------------------------------
# 14. CHECK TERRAIN
# ------------------------------------------------------------

cat("\n========================================\n")
cat("TERRAIN CHECK\n")
cat("========================================\n")

print(
  unique(
    traffic_clean$Terrain
  )
)


# ------------------------------------------------------------
# 15. CHECK YEAR RANGE
# ------------------------------------------------------------

cat("\n========================================\n")
cat("YEAR CHECK\n")
cat("========================================\n")

cat(
  "Minimum year:",
  min(
    traffic_clean$Year,
    na.rm = TRUE
  ),
  "\n"
)

cat(
  "Maximum year:",
  max(
    traffic_clean$Year,
    na.rm = TRUE
  ),
  "\n"
)


# ------------------------------------------------------------
# 16. FINAL MISSING VALUE CHECK
# ------------------------------------------------------------

cat("\n========================================\n")
cat("FINAL MISSING VALUE CHECK\n")
cat("========================================\n")

print(
  colSums(
    is.na(traffic_clean)
  )
)


# ------------------------------------------------------------
# 17. FINAL DATA SUMMARY
# ------------------------------------------------------------

cat("\n========================================\n")
cat("CLEAN TRAFFIC DATA SUMMARY\n")
cat("========================================\n")

print(
  summary(
    traffic_clean
  )
)

cat(
  "\nNumber of observations after cleaning:",
  nrow(traffic_clean),
  "\n"
)


# ------------------------------------------------------------
# 18. SAVE CLEANED DATA
# ------------------------------------------------------------

write.csv(
  traffic_clean,
  output_file,
  row.names = FALSE
)


# ------------------------------------------------------------
# 19. CONFIRM FILE LOCATION
# ------------------------------------------------------------

cat("\n========================================\n")
cat("TRAFFIC CLEANING COMPLETED\n")
cat("Cleaned file saved at:\n")
cat(output_file)
cat("\n========================================\n")